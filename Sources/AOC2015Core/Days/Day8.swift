import Foundation

class Day8: Day {
    var day: Int { 8 }
    let input: [String]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = #"""
""
"abc"
"aaa\"aaa"
"\x27"
"a\\b"
"""#
        } else {
            inputString = try InputGetter.getInput(for: 8, part: .first)
        }
        self.input = inputString
            .components(separatedBy: "\n")
    }

    func runPart1() async throws {
        let backslashRegex = #/\\\\/#
        let quotesRegex = #/\\\"/#
        let hexRegex = #/\\x[0-9,a-z,A-Z]{2}/#

        let cleaned = input.map { row in
            return row
                .replacing(backslashRegex, with: "_")
                .replacing(quotesRegex, with: "'")
                .replacing(hexRegex, with: "@")
        }

        let vals = cleaned.map { $0.count - 2 }
        let allVals = vals.reduce(0, +)

        let originalVals = input.map { $0.count }
        let allOriginalVals = originalVals.reduce(0, +)

        let res = allOriginalVals - allVals
        print(res)
    }

    
    func runPart2() throws {
        let res = input.reduce(0) { $0 + $1.debugDescription.count - $1.count }

        print(res)
    }
}
