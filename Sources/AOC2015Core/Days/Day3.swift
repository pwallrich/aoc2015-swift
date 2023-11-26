//
//  File.swift
//  
//
//  Created by Philipp Wallrich on 27.09.23.
//

import Foundation

struct Point2D: Hashable, Equatable {
    let x: Int
    let y: Int
}

class Day3: Day {
    var day: Int { 3 }
    let input: String

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "^v^v^v^v^v"
        } else {
            inputString = try InputGetter.getInput(for: 3, part: .first)
        }
        self.input = inputString
    }

    func runPart1() throws {
        var curr = Point2D(x: 0, y: 0)
        var visited: Set<Point2D> = [curr]

        for char in input {
            switch char {
            case "^":
                curr = Point2D(x: curr.x - 1, y: curr.y)
            case "v":
                curr = Point2D(x: curr.x + 1, y: curr.y)
            case "<":
                curr = Point2D(x: curr.x, y: curr.y - 1)
            case ">":
                curr = Point2D(x: curr.x, y: curr.y + 1)
            default:
                break
            }
            visited.insert(curr)
        }

        print(visited.count)
    }

    func runPart2() throws {
        var santa = Point2D(x: 0, y: 0)
        var robot = Point2D(x: 0, y: 0)
        var visited: Set<Point2D> = [santa]

        for (idx, char) in input.enumerated() {
            var deltaX = 0
            var deltaY = 0
            switch char {
            case "^":
                deltaX = -1
            case "v":
                deltaX = 1
            case "<":
                deltaY = -1
            case ">":
                deltaY = 1
            default:
                break
            }
            if idx % 2 == 0 {
                santa = Point2D(x: santa.x + deltaX, y: santa.y + deltaY)
                visited.insert(santa)
            } else {
                robot = Point2D(x: robot.x + deltaX, y: robot.y + deltaY)
                visited.insert(robot)
            }
        }

        print(visited.count)
    }
}
