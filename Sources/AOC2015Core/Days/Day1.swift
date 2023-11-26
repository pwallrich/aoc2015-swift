//
//  File.swift
//  
//
//  Created by Philipp Wallrich on 01.12.22.
//

import Foundation

class Day1: Day {
    var day: Int { 1 }
    let input: String

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "()())"
        } else {
            inputString = try InputGetter.getInput(for: 1, part: .first)
        }
        self.input = inputString
    }

    func runPart1() throws {
        var floor = 0
        for char in input {
            switch char {
            case "(": floor += 1
            case ")": floor -= 1
            default: break
            }
        }
        print(floor)
    }

    func runPart2() throws {
        var floor = 0
        for (idx, char) in input.enumerated() {
            switch char {
            case "(": floor += 1
            case ")": floor -= 1
            default: break
            }
            if floor < 0 {
                print(idx + 1)
                break
            }
        }
    }
}
