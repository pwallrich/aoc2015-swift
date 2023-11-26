import Foundation

class Day10: Day {
    var day: Int { 10 }
    let input: String

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "1"
        } else {
            inputString = "1113222113"
        }
        self.input = inputString
    }

    func runPart1() throws {
        let regex = #/(\d)\1*/#
         var current = input
        
         for i in 0..<50 {
             print(i)
             var next = ""
             for match in current.matches(of: regex) {
                 next += "\(match.output.0.count)\(match.output.1)"
             }
             current = next
         }
         print(current.count)
    }

    func runPart2() throws {}
}
