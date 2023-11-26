import Foundation

class Day18: Day {
    var day: Int { 18 }
    let input: String
    let dimensions: Int

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            dimensions = 6
            inputString = """
.#.#.#
...##.
#....#
..#...
#.#..#
####..
"""

        } else {
            dimensions = 100
            inputString = try InputGetter.getInput(for: 18, part: .first)
        }
        self.input = inputString
    }

    func runPart1() throws {
        var grid: Set<Point2D> = []
        for (y, row) in input.split(separator: "\n").enumerated() {
            for (x, char) in row.enumerated() where char == "#" { 
                grid.insert(Point2D(x: x, y: y))
            }
        }

        for i in 0..<100 {
            print("iteration \(i)")
            var newGrid: Set<Point2D> = []
            for y in 0..<dimensions {
                for x in 0..<dimensions {
                    var count = 0
                    for dx in -1...1 {
                        for dy in -1...1 {
                            if dx == 0 && dy == 0 { continue }
                            if grid.contains(Point2D(x: x + dx, y: y + dy)) {
                                count += 1
                            }
                        }
                    }
                    let curr = Point2D(x: x, y: y)
                    switch (grid.contains(curr), count) {
                    case (true, 2), (true, 3):
                         newGrid.insert(curr)
                    case (false, 3):
                        newGrid.insert(curr)
                    default: 
                        break
                    }
                }
            }
            grid = newGrid
            grid.prettyPrint(dimensions: dimensions)
        }

        print(grid.count)
    }

    var initial: Set<Point2D> = [
        Point2D(x: 0, y: 0), Point2D(x: 0, y: 99),
        Point2D(x: 99, y: 0), Point2D(x: 99, y: 99),
    ]

    func runPart2() throws {
        var grid: Set<Point2D> = initial
        for (y, row) in input.split(separator: "\n").enumerated() {
            for (x, char) in row.enumerated() where char == "#" {
                grid.insert(Point2D(x: x, y: y))
            }
        }

        for i in 0..<100 {
            print("iteration \(i)")
            var newGrid: Set<Point2D> = initial
            for y in 0..<dimensions {
                for x in 0..<dimensions {
                    if initial.contains(Point2D(x: x, y: y)) { continue }
                    var count = 0
                    for dx in -1...1 {
                        for dy in -1...1 {
                            if dx == 0 && dy == 0 { continue }
                            if grid.contains(Point2D(x: x + dx, y: y + dy)) {
                                count += 1
                            }
                        }
                    }
                    let curr = Point2D(x: x, y: y)
                    switch (grid.contains(curr), count) {
                    case (true, 2), (true, 3):
                         newGrid.insert(curr)
                    case (false, 3):
                        newGrid.insert(curr)
                    default:
                        break
                    }
                }
            }
            grid = newGrid
            grid.prettyPrint(dimensions: dimensions)
        }

        print(grid.count)
    }
}

extension Set<Point2D> {
    func prettyPrint(dimensions: Int) {
        for y in 0..<dimensions {
            for x in 0..<dimensions {
                print(self.contains(Point2D(x: x, y: y)) ? "#" : ".", terminator: "")
            }
            print()
        }
    }
}
