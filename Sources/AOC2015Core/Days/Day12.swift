import Foundation
import RegexBuilder
import Algorithms

class Day12: Day {
    var day: Int { 12 }
    let input: String

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
        //    inputString = #"{"foo":{"d":"red","e":[1,2,3,4],"f":5},"val":[1,"red",5,7],"bar":{"a":1,"b":2}}"#
        //    inputString = #"{"foo": [1,2,3]}"#
            inputString = #"{"foo:": [1,"red",5]}"#
//            inputString = #"[1,{"c":"red","b":2},3]"#
        } else {
            inputString = try InputGetter.getInput(for: 12, part: .first)
        }
        self.input = inputString
    }

    func runPart1() throws {
        let numberRegex = #/-?\d+/#

        let res = input.matches(of: numberRegex).reduce(0) { $0 + (Int($1.output) ?? 0) }
        print(res)

    }

    func runPart2() async throws {
        let data = Data(input.utf8)
        do {
            let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: [])
            if let json =  jsonSerialized as? [String: Any] {
                let res = parse(json)
                print(res)
            }
        } catch {
            print("Failed to load: \(error.localizedDescription)")
        }
    }

    func parse(_ dict: [String: Any]) -> Int {
        var count = 0
        for item in dict.values {
            if let string = item as? String, string == "red" {
                return 0
            }
            if let number = item as? Int {
                count += number
            }
            if let array = item as? [Any] {
                let val = parse(array)
                count += val
            }
            if let d = item as? [String: Any] {
                let val = parse(d)
                count += val
            }
        }
        return count
    }

    func parse(_ array: [Any]) -> Int {
        var count = 0
        for item in array {
            if let number = item as? Int {
                count += number
            }
            if let a = item as? [Any] {
                let val = parse(a)
                count += val
            }
            if let d = item as? [String: Any] {
                let val = parse(d)
                count += val
            }
        }
        return count
    }
}
