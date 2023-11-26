import Foundation

class Day17: Day {
    var day: Int { 17 }
    let input: String
    let litersToFill: Int

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "20\n15\n10\n5\n5"
            litersToFill = 25
        } else {
            inputString = try InputGetter.getInput(for: 17, part: .first)
            litersToFill = 150
        }
        self.input = inputString
    }

    func runPart1() throws {
        let amounts = input
            .components(separatedBy: "\n")
            .map {Int($0)! }
            // .sorted()

        let res = amounts
            .combinations(ofCount: 0..<amounts.count)
            .filter { $0.reduce(0, +) == litersToFill }

        print(res.count)
    }

    func runPart2() throws {
        let amounts = input
            .components(separatedBy: "\n")
            .map {Int($0)! }
            // .sorted()

        let minimum = amounts
            .combinations(ofCount: 0..<amounts.count)
            .filter { $0.reduce(0, +) == litersToFill }
            .min { $0.count < $1.count }

        let res =  amounts
            .combinations(ofCount: minimum!.count)
            .filter { $0.reduce(0, +) == litersToFill }

        print(res.count)

    }
}
