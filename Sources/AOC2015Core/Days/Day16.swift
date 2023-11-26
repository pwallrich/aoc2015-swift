import Foundation
import RegexBuilder

class Day16: Day {
    var day: Int { 16 }
    let input: String

    // Sue 1: children: 1, cars: 8, vizslas: 7
    let sueNumberRegex = Regex {
        TryCapture {
            OneOrMore(.digit)
        } transform: { Int($0) }
    }

    let regex = Regex {
        Capture {
            OneOrMore(.word)
        }
        ": "
        TryCapture {
            OneOrMore(.digit)
        } transform: { Int($0) }
    }

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "foo"
        } else {
            inputString = try InputGetter.getInput(for: 16, part: .first)
        }
        self.input = inputString
    }

    let ticker = """
children: 3
cats: 7
samoyeds: 2
pomeranians: 3
akitas: 0
vizslas: 0
goldfish: 5
trees: 3
cars: 2
perfumes: 1
"""

    func runPart1() throws {
        var sues: [Int: [Substring: Int]] = [:]
        for row in input.components(separatedBy: "\n") {
            let numberMatch = row.firstMatch(of: sueNumberRegex)!
            let number = numberMatch.output.1

            var attributes: [Substring: Int] = [:]

            for match in row[numberMatch.range.upperBound...].matches(of: regex) {
                attributes[match.output.1] = match.output.2
            }
            sues[number] = attributes
        }
        
        var attributes: [Substring: Int] = [:]
        for row in ticker.components(separatedBy: "\n") {
            let split = row.split(separator: ": ")
            attributes[split[0]] = Int(split[1])!
        }

        var best = (-1, -1)
        for sue in sues {
            var count = 0
            for attr in sue.value {
                if attributes[attr.key] == attr.value {
                    count += 1
                }
            }
            best = count > best.0 ? (count, sue.key) : best
        }

        print(best)
    }

    func runPart2() throws {
        var sues: [Int: [Substring: Int]] = [:]
        for row in input.components(separatedBy: "\n") {
            let numberMatch = row.firstMatch(of: sueNumberRegex)!
            let number = numberMatch.output.1

            var attributes: [Substring: Int] = [:]

            for match in row[numberMatch.range.upperBound...].matches(of: regex) {
                attributes[match.output.1] = match.output.2
            }
            sues[number] = attributes
        }
        
        var attributes: [Substring: Int] = [:]
        for row in ticker.components(separatedBy: "\n") {
            let split = row.split(separator: ": ")
            attributes[split[0]] = Int(split[1])!
        }

        var best = (-1, -1)
        for sue in sues {
            var count = 0
            for attr in sue.value {
                if attr.key == "cats" || attr.key == "trees", attr.value > attributes[attr.key]! {
                    count += 1
                    continue
                }
                if attr.key == "pomeranians" || attr.key == "goldfish", attr.value < attributes[attr.key]! {
                    count += 1
                    continue
                }
                if attributes[attr.key] == attr.value {
                    count += 1
                }
            }
            best = count > best.0 ? (count, sue.key) : best
        }

        print(best)
    }
}
