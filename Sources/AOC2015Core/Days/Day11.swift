import Foundation

class Day11: Day {
    var day: Int { 11 }
    let input: String

    private let forbidden: Set<UInt8> = [Character("i").asciiValue!, Character("o").asciiValue!, Character("u").asciiValue!]
    private let asciiZ = Character("z").asciiValue!
    private let asciiA = Character("a").asciiValue!

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "ghijklmn"
        } else {
            inputString = "cqjxjnds"
        }
        self.input = inputString
    }

    func runPart1() throws {
        var asciiValues = input.map { $0.asciiValue! }
        let initial = asciiValues

        repeat {
            asciiValues = nextNumber(for: asciiValues)
            let valid = isValid(sequence: asciiValues)
             if valid {
                print(String(asciiValues.map { Character(UnicodeScalar($0))}))
                return
            }
        } while asciiValues != initial
    }

    func runPart2() throws {}













    func nextNumber(for sequence: [UInt8]) -> [UInt8] {
        var new = sequence
        var next = new.popLast()! + 1

         if forbidden.contains(next) {
            next += 1
        }

        return next > asciiZ ? nextNumber(for: new) + [asciiA] : new + [next]
    }

    func isValid(sequence: [UInt8]) -> Bool {
        var hasIncreasing = false
        var duplicateCount = 0
        var lastDuplicate: Int = -1

        for (idx, val) in sequence.enumerated() {
             guard idx + 1 < sequence.endIndex else {
                continue
            }
            if val == sequence[idx + 1], lastDuplicate != idx {
                duplicateCount += 1
                lastDuplicate = idx + 1
            }
            guard idx + 2 < sequence.endIndex else {
                continue
            }
            if sequence[idx] + 1 == sequence[idx + 1] && sequence[idx + 1] + 1 == sequence[idx + 2] {
                hasIncreasing = true
            }
        }
        return hasIncreasing && duplicateCount >= 2
    }
}
























fileprivate let alphabet: [Character] = "abcdefghijklmnopqrstuvwxyz".map { $0 }
fileprivate let forbidden: [Character] = ["i", "o", "u"]



extension String {
    func isValid() -> Bool {
        var hasIncreasing = false

        var duplicateCount = 0
        var lastDuplicate: Character = "_"

        for (subsequence) in windows(ofCount: 3) {
            if alphabet.contains(subsequence) {
                hasIncreasing = true
            }
            let firstIdx = subsequence.startIndex
            let secondIdx = subsequence.index(after: firstIdx)

            if subsequence[firstIdx] == subsequence[secondIdx] && lastDuplicate != subsequence[firstIdx] {
                duplicateCount += 1
            } else {
                lastDuplicate = "_"
            }
        }

        return hasIncreasing && duplicateCount >= 2
    }

    func nextPassword() -> String {
        var new = self

        if let idx = new.firstIndex(where: { forbidden.contains($0) }) {
            let next = alphabet.firstIndex(of: self[idx])! + 1
            let aCount = new.distance(from: idx, to: new.endIndex) - 1
            new = "\(new[..<idx])\(alphabet[next])\(String(repeating: "a", count: aCount))"
            return new
        }

        let removed = new.popLast()!
        let idx = alphabet.firstIndex(of: removed)! + 1

        return idx == alphabet.endIndex ? new.nextPassword() + "a" : new + "\(alphabet[idx])"
    }
}
