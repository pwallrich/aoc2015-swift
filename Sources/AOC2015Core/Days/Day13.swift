import Foundation
import RegexBuilder

class Day13: Day {
    var day: Int { 13 }
    let input: String

    let regex = Regex {
        Capture {
            OneOrMore(.word)
        }
        " would "
        TryCapture {
            ChoiceOf {
                "gain"
                "lose"
            }
        } transform: { val in
            return val == "gain" ? 1 : -1
        }
        " "
        TryCapture {
            OneOrMore(.digit)
        } transform: { Int($0) }
        " happiness units by sitting next to "
        Capture {
            OneOrMore(.word)
        }
    }

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = """
Alice would gain 54 happiness units by sitting next to Bob.
Alice would lose 79 happiness units by sitting next to Carol.
Alice would lose 2 happiness units by sitting next to David.
Bob would gain 83 happiness units by sitting next to Alice.
Bob would lose 7 happiness units by sitting next to Carol.
Bob would lose 63 happiness units by sitting next to David.
Carol would lose 62 happiness units by sitting next to Alice.
Carol would gain 60 happiness units by sitting next to Bob.
Carol would gain 55 happiness units by sitting next to David.
David would gain 46 happiness units by sitting next to Alice.
David would lose 7 happiness units by sitting next to Bob.
David would gain 41 happiness units by sitting next to Carol.
"""
        } else {
            inputString = try InputGetter.getInput(for: 13, part: .first)
        }
        self.input = inputString
    }

    

    func runPart1() throws {
        var people: [String: [String: Int]] = [:]

        for match in input.matches(of: regex) {
            var lookup = people[String(match.output.1), default: [:]]
            lookup[String(match.output.4)] = match.output.3 * match.output.2
            people[String(match.output.1)] = lookup
        }

        let permutations = people.keys.permutations()
        var best: Int = 0
        for (idx, perm) in permutations.enumerated() {
            print("checking permutation \(idx) of \(permutations.count)")
            var result = 0
            for (idx, person) in perm.enumerated() {
                let leftIdx = idx - 1 < 0 ? perm.count - 1 : idx - 1
                let rightIdx = (idx + 1) % perm.count
                let left = perm[leftIdx]
                let right = perm[rightIdx]
                let hapiness = people[person]![left]! + people[person]![right]!

                result += hapiness
            }
            best = max(best, result)
        }
        print(best)
    }

    func runPart2() throws {
        var people: [String: [String: Int]] = [:]

        for match in input.matches(of: regex) {
            var lookup = people[String(match.output.1), default: [:]]
            lookup[String(match.output.4)] = match.output.3 * match.output.2
            people[String(match.output.1)] = lookup
        }

        people["you"] = Dictionary(uniqueKeysWithValues: people.keys.map { ($0, 0)})
        for var (key, lookup) in people where key != "you"{
            lookup["you"] = 0
            people[key] = lookup 
        }

        let permutations = people.keys.permutations()
        var best: Int = 0
        for (idx, perm) in permutations.enumerated() {
            print("checking permutation \(idx) of \(permutations.count)")
            var result = 0
            for (idx, person) in perm.enumerated() {
                // print(person)
                let leftIdx = idx - 1 < 0 ? perm.count - 1 : idx - 1
                let rightIdx = (idx + 1) % perm.count
                let left = perm[leftIdx]
                let right = perm[rightIdx]
                let hapiness = people[person]![left]! + people[person]![right]!

                result += hapiness
            }
            best = max(best, result)
        }
        print(best)
    }
}
