import Foundation

class Day20: Day {
    var day: Int { 20 }
    let input: String

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "180"
        } else {
            inputString = "33100000"
        }
        self.input = inputString
    }

    func runPart1() throws {
        let target = Int(input)!
        var houses: [Int] = Array(repeating: 0, count: target/10)
        for i in 1...(target / 10) {
            if i % 100 == 0 {
                print(i)
            }
            for j in stride(from: i, to: target/10, by: i) {
                houses[j] += i * 10
            }
        }

        print(houses.enumerated().first { $0.element >= target} )
    }

    func runPart2() throws {
        let target = Int(input)!
        var houses: [Int] = Array(repeating: 0, count: target / 10)

        for i in 1...(target / 10) {
            if i % 100 == 0 {
                print(i)
            }
            for j in 1...50 {
                if j * i >= target / 10 {
                    break
                }

                houses[j * i] += i * 11
            }

        }

        print(houses.enumerated().first { $0.element >= target} )
    }
}
