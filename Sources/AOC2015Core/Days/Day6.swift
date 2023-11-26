import Foundation

class Day6: Day {
    var day: Int { 6 }
    let input: [String]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            // inputString = "turn on 0,0 through 999,999\nturn off 0,0 through 999,999"
            inputString = "toggle 0,0 through 999,0"
        } else {
            inputString = try InputGetter.getInput(for: 6, part: .first)
        }
        self.input = inputString
            .components(separatedBy: "\n")
    }

    func runPart1() throws {
        var lights: Set<Point2D> = []
        for row in input {
            let commands = row
                .components(separatedBy: " ")

            let startRangeIndex: Int = row.starts(with: "turn") ? 2 : 1
            let endRangeIndex: Int = row.starts(with: "turn") ? 4 : 3

            let startRangeString = commands[startRangeIndex].components(separatedBy: ",")
            assert(startRangeString.count == 2)
            let fromX = Int(startRangeString[0])!
            let fromY = Int(startRangeString[1])!

            let endRangeString = commands[endRangeIndex].components(separatedBy: ",")
            assert(endRangeString.count == 2)
            let endX = Int(endRangeString[0])!
            let endY = Int(endRangeString[1])!

            for y in fromY...endY {
                for x in fromX...endX {
                    let point = Point2D(x: x, y: y)
                    if commands[1] == "on" {
                        lights.insert(Point2D(x: x, y: y))
                    } else if commands[1] == "off" {
                        lights.remove(Point2D(x: x, y: y))
                    } else if commands[0] == "toggle" && lights.contains(point) {
                        lights.remove(point)
                    } else if commands[0] == "toggle" {
                        lights.insert(point)
                    }
                }
            }
        }
        print(lights.count)
    }

    func runPart2() throws {
        var lights: [Point2D: Int] = [:]
        for row in input {
            let commands = row
                .components(separatedBy: " ")
            
            assert(commands.count >= 4)

            switch commands[0] {
                case "turn":
                    let startRangeString = commands[2].components(separatedBy: ",")
                    assert(startRangeString.count == 2)
                    let fromX = Int(startRangeString[0])!
                    let fromY = Int(startRangeString[1])!

                    let endRangeString = commands[4].components(separatedBy: ",")
                    assert(endRangeString.count == 2)
                    let endX = Int(endRangeString[0])!
                    let endY = Int(endRangeString[1])!

                    for y in fromY...endY {
                        for x in fromX...endX {
                            let point = Point2D(x: x, y: y)
                            if commands[1] == "on" {
                                lights[point, default: 0] += 1
                            } else if commands[1] == "off" {
                                let curr = lights[point, default: 0]
                                lights[point] = max(0, curr - 1)
                            }
                        }
                    }
                case "toggle":
                    let startRangeString = commands[1].components(separatedBy: ",")
                    assert(startRangeString.count == 2)
                    let fromX = Int(startRangeString[0])!
                    let fromY = Int(startRangeString[1])!

                    let endRangeString = commands[3].components(separatedBy: ",")
                    assert(endRangeString.count == 2)
                    let endX = Int(endRangeString[0])!
                    let endY = Int(endRangeString[1])!
                    
                    for y in fromY...endY {
                        for x in fromX...endX {
                            let point = Point2D(x: x, y: y)
                            lights[point, default: 0] += 2
                        }
                    }
                default: 
                    break
            }
        }
        print(lights.values.reduce(0, +))
    }
}
