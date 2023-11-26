//
//  File.swift
//  
//
//  Created by Philipp Wallrich on 27.09.23.
//

import Foundation

class Day5: Day {
    var day: Int { 5 }
    let input: [String]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
//            inputString = "qjhvhtzxzqqjkmpb\nxxyxx\nuurcxstgmygtbstg\nieodomkazucvgmuy"
            inputString = "aaaa"
        } else {
            inputString = try InputGetter.getInput(for: 5, part: .first)
        }
        self.input = inputString
            .components(separatedBy: "\n")
            .filter { !$0.isEmpty }
    }

    func runPart1() throws {
        // three vowels
        let vowles: [Character] = ["a", "e", "i", "o", "u"]
        let forbidden: [Character: Character] = [
            "a": "b",
            "c": "d",
            "p": "q",
            "x": "y"
        ]
        // twice in a row
        // not ab, cd, pq, or xy
        var count = 0
        var lastChar: Character?
        for row in input {
            print(row)
            var vowelCount = 0
            var hasTwice = false
            var invalid = false
            for char in row {
                if vowles.contains(char) {
                    vowelCount += 1
                }
                if let lastChar, lastChar == char {
                    hasTwice = true
                }
                if let lastChar, let next = forbidden[lastChar], next == char {
                    invalid = true
                    break
                }
                lastChar = char
            }
            lastChar = nil
            print("\(hasTwice), \(vowelCount), \(invalid)")
            if hasTwice && vowelCount >= 3 && !invalid {
                count += 1
            }
        }
        print(count)
    }

    func runPart2() throws {

        var count = 0
        for row in input {
            print(row)
            var secondToLastChar: Character?
            var lastChar: Character?
            var lastAdded: String?

            var hasTwiceWithMiddle = false
            var characters: [String: Int] = [:]
            for idx in row.indices {
                let char = row[idx]


                if let lastChar {
                    let sequence = "\(lastChar)\(char)"
                    if sequence != lastAdded {
                        characters[sequence, default: 0] += 1
                        lastAdded = sequence
                    } else {
                        lastAdded = nil
                    }
                }

                if let secondToLastChar, secondToLastChar == char {
                    hasTwiceWithMiddle = true
                }
                if abs(row.distance(from: idx, to: row.startIndex)) >= 1 {
                    let secondToLast = row.index(idx, offsetBy: -1)
                    if secondToLast >= row.startIndex {
                        secondToLastChar = row[secondToLast]
                    }
                }
                lastChar = char
            }
            print(characters)
            print(hasTwiceWithMiddle)
            if hasTwiceWithMiddle && !(characters.values.filter { $0 >= 2 }.isEmpty) {
                count += 1
            }

        }
        print(count)
    }
}
