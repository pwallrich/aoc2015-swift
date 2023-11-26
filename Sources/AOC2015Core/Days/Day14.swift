import Foundation
import RegexBuilder

class Day14: Day {
    var day: Int { 14 }
    let input: [Substring: (speed: Int, fly: Int, rest: Int)]

    let regex = Regex {
        Capture {
            OneOrMore(.word)
        }
        OneOrMore(.any, .reluctant)
        TryCapture {
            OneOrMore(.digit)
        } transform: { Int($0) }
        OneOrMore(.any, .reluctant)
        TryCapture {
            OneOrMore(.digit)
        } transform: { Int($0) }
        OneOrMore(.any, .reluctant)
        TryCapture {
            OneOrMore(.digit)
        } transform: { Int($0) }
        OneOrMore(.any, .reluctant)
        "."
    }

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = """
Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.
"""
        } else {
            inputString = try InputGetter.getInput(for: 14, part: .first)
        }
        var deers: [Substring: (speed: Int, fly: Int, rest: Int)] = [:]
        for match in inputString.matches(of: regex) {
            print(match.1, match.2, match.3, match.4)
            deers[match.1] = (match.2, match.3, match.4)
        }
        self.input = deers
    }

    func runPart1() throws {
        let iterations = 2503

        let distanceTraveled = input.values.map { deer in
            let distancePerFlyRestInterval = deer.speed * deer.fly

            let traveled = iterations / (deer.fly + deer.rest) * distancePerFlyRestInterval
            
            let overlap = (deer.fly + deer.rest) % iterations

            let overlapDistance = min(overlap * deer.speed, distancePerFlyRestInterval)
            return traveled + overlapDistance
        }

        print(distanceTraveled)

        print(distanceTraveled.max()!)
    }

    func runPart2() throws {
        let iterations = 2503

        var points: [Substring: Int] = [:]
        var traveled: [Substring: Int] = [:]
        
        for i in 0...iterations {
            for (name, deer) in input {
                let currentInInterval = i % (deer.fly + deer.rest)
                if currentInInterval >= deer.fly {
                    continue
                }
                traveled[name, default: 0] += deer.speed
            }

            let leader = traveled.max { $0.value < $1.value }!.key
            points[leader, default: 0] += 1
        }

        print(points)

        print(points.values.max()!)

        print(traveled)
    }
}
