import Foundation
import RegexBuilder

class Day19: Day {
    var day: Int { 19 }
    // let input: String

    let medicine: Substring
    let instructions: [Substring: [Substring]] 

    let regex = Regex {
        Capture {
            OneOrMore(.word)
        }
        " => "
        Capture {
            OneOrMore(.word)
        }
    }

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = """
e => H
e => O
H => HO
H => OH
O => HH

HOHOHO
"""
        } else {
            inputString = try InputGetter.getInput(for: 19, part: .first)
        }
        
        let split = inputString.split(separator: "\n\n")
        var instructions: [Substring: [Substring]] = [:]

        for match in split[0].matches(of: regex) {
            instructions[match.output.1, default: []].append(match.output.2)
        }

        self.instructions = instructions
        self.medicine = split[1]
    }

    func runPart1() throws {

        var newMolecules: Set<String> = []
        for instruction in instructions {
            for replacement in instruction.value {
                for match in medicine.ranges(of: instruction.key) {
                    let new = medicine.replacingCharacters(in: match, with: replacement)
                    newMolecules.insert(new)
                }
            }
        }
        print(newMolecules.count)
    }

    func runPart2() async throws {
        var priority: [[(string: String, iteration: Int)]] = Array(repeating: [], count: 2000)
        priority[0] = [(String(medicine), 0)]

        var seen: Set<String> = []

        while true {
            let nextPriority = priority.enumerated().first { !$0.element.isEmpty }!
            var pArray = nextPriority.element
            let nextStep = pArray.popLast()!
            priority[nextPriority.offset] = pArray

            print(nextStep.string, nextStep.string.count)

            if nextStep.string == "e" {
                print(nextStep.iteration)
                return
            }

            for instruction in instructions {
                for replacement in instruction.value {
                    for match in nextStep.string.ranges(of: replacement) {
                        let new = nextStep.string.replacingCharacters(in: match, with: instruction.key)
                        if seen.contains(new) {
                            continue
                        }
                        priority[new.count + nextStep.iteration + 1].append((new, nextStep.iteration + 1))
                    }
                }
            }
        }
    }


    func runPart2_old() async throws {
        var currentIteration: Set<String> = [String(medicine)]
        var count = 1
        var alreadySeen: Set<String> = []
        let instructions = instructions.sorted { $0.key < $1.key }
        while !currentIteration.contains("e") {
            print(count, currentIteration.count, currentIteration.map { $0.count }.min())

            var next: Set<String> = []
            for instruction in instructions {
                for replacement in instruction.value {
                    for start in currentIteration {
                        for match in start.ranges(of: replacement) {
                            let new = start.replacingCharacters(in: match, with: instruction.key)
                            if alreadySeen.contains(new) {
                                continue
                            }
                            next.insert(new)
                            alreadySeen.insert(new)
                        }
                    }
                }
            }
            count += 1
            currentIteration = next
        }
    }

    func runPart2_dfs() async throws {

        let res = deflate(string: String(medicine), iteration: 0)
        print(res)
    }

    struct CacheKey: Hashable {
        let string: String
        let iteration: Int
    }
    var cache: [CacheKey: Int?] = [:]
    var cacheHits: Int = 0
    func inflate(string: String, iteration: Int) -> Int? {
       if iteration > 20 {
            print("testing \(string), \(iteration) \(string.count)")
       }
        if let cached = cache[.init(string: string, iteration: iteration)] {
            cacheHits += 1
            return cached
        }
        if string == medicine {
            return iteration
        }
        if string.count >= medicine.count {
            return nil
        }
        var best: Int?
        for instruction in instructions {
            for replacement in instruction.value {
                for match in string.ranges(of: instruction.key) {
                    let new = string.replacingCharacters(in: match, with: replacement)
                    let value = inflate(string: new, iteration: iteration + 1)
                    if let b = best, let value {
                        best = min(value ?? .max, b)   
                    } else if let value {
                        best = value
                    }
                }
            }
        }
        cache[.init(string: string, iteration: iteration)] = best
        
        return best
    }

    func deflate(string: String, iteration: Int) -> Int? {
        if string.count < 10 {
            print("testing \(string), \(iteration) \(string.count)")
        }
        if let cached = cache[.init(string: string, iteration: iteration)] {
            cacheHits += 1
            return cached
        }
        if string == "e" {
            return iteration
        }
        if string.isEmpty {
            return nil
        }
        var best: Int?
        for instruction in instructions {
            for replacement in instruction.value {
                for match in string.ranges(of: replacement) {
                    let new = string.replacingCharacters(in: match, with: instruction.key)
                    let value = deflate(string: new, iteration: iteration + 1)
                    if let b = best, let value {
                        best = min(value, b)
                    } else if let value {
                        best = value
                    }
                }
            }
        }
        cache[.init(string: string, iteration: iteration)] = best

        return best
    }
}
