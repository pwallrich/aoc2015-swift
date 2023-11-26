//
//  File.swift
//  
//
//  Created by Philipp Wallrich on 26.09.23.
//

import Foundation

class Day2: Day {
    var day: Int { 2 }
    let input: [[Int]]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "2x3x4\n1x1x10"
        } else {
            inputString = try InputGetter.getInput(for: 2, part: .first)
        }
        self.input = inputString
            .components(separatedBy: "\n")
            .map { $0
                .components(separatedBy: "x")
                .compactMap { Int($0) }
            }
    }

    func runPart1() throws {
        var result = 0
        for row in input where row.count == 3 {
            print(row)
            let lw = row[0] * row [1]
            let wh = row[0] * row[2]
            let lh = row[1] * row[2]

            result += 2 * lw + 2 * wh + 2 * lh + min(lw, wh, lh)

        }

        print(result)
    }

    func runPart2() throws {
        var result = 0
        for row in input where row.count == 3 {
            print(row)
            let box = row
                .sorted()
                .prefix(2)
                .reduce(0) { 2 * $1 + $0 }

            let bow = row.reduce(1, *)

            let boxResult = bow + box
            result += boxResult
        }

        print(result)
    }
}
