import Foundation
import RegexBuilder

class Day9: Day {
    var day: Int { 9 }
    let input: [Substring: Location]

    class Location {
        let name: Substring
        var connections: [(Location, Int)]

        init(name: Substring, connections: [(Location, Int)]) {
            self.name = name
            self.connections = connections
        }
    }

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "London to Dublin = 464\nLondon to Belfast = 518\nDublin to Belfast = 141"
        } else {
            inputString = try InputGetter.getInput(for: 9, part: .first)
        }
        let regex = Regex {
            Capture {
                OneOrMore(.word)
            }
            " to "
            Capture {
                OneOrMore(.word)
            }
            " = "
            TryCapture {
                OneOrMore(.digit) 
            } transform: {
                Int($0)
            }
        }

        var locations: [Substring: Location] = [:]
        for match in inputString.matches(of: regex) {
            let location = locations[match.1] ??  Location(name: match.1, connections: [])
            let to = locations[match.2] ?? Location(name: match.2, connections:[])

            location.connections.append((to, match.3))
            to.connections.append((location, match.3)) 

            locations[match.1] = location
            locations[match.2] = to
        }

        self.input = locations
    }

    func runPart1() throws {
        var best: Int = .max
        // consider every location as possible startPoint
        for location in input {
            let res = takeStep(current: location.value, visited: [location.key], currentLength: 0)
            best = min(best, res)
        }

        print(best)
    }

    func runPart2() throws {
        var best: Int = .min

        // consider every location as possible startPoint
        for location in input {
            let res = takeStep(current: location.value, visited: [location.key], currentLength: 0, useShortest: false)
            best = max(best, res)
        }

        print(best)
    }

    func takeStep(current: Location, visited: Set<Substring>, currentLength: Int, useShortest: Bool = false) -> Int {
        if visited.count == input.count {
            return currentLength
        }

        let nextSteps = current.connections.filter({ !visited.contains($0.0.name) })
        var best = useShortest ? Int.max : Int.min

        for nextStep in nextSteps {
            let res = takeStep(current: nextStep.0, visited: visited.union([nextStep.0.name]), currentLength: nextStep.1 + currentLength, useShortest: useShortest)
            best = useShortest ? min(best, res) : max(best, res)
        }
        return best
    }
}