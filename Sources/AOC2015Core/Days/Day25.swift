import Foundation

class Day25: Day {
    var day: Int { 25 }
    let row: Int
    let column: Int

    init(testInput: Bool) throws {
        if testInput {
            row = 2
            column = 4
        } else {
            row = 2981
            column = 3075
        }
    }

    var grid: [Point2D: Int] = [
        Point2D(x: 1, y: 1): 20151125
    ]

    func runPart1() throws {
        var currentMaxY = 1
        var point = Point2D(x: 1, y: 1)
        while point != Point2D(x: column, y: row) {
            var nextPoint = Point2D(x: point.x + 1, y: point.y - 1)
            if nextPoint.y <= 0 {
                currentMaxY += 1
                nextPoint = Point2D(x: 1, y: currentMaxY)
            }
            let lastValue = grid[point]!
            let nextValue = (lastValue * 252533) % 33554393
//            print(nextPoint, nextValue)
            grid[nextPoint] = nextValue
            point = nextPoint
        }

        print(point)
        print(grid[point]!)
    }

    func runPart2() throws {}
}
