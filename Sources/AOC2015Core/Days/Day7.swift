import Foundation

class Day7: Day {
    var day: Int { 7 }
    let input: [String]

    typealias Operation = (String, String?, (UInt16, UInt16) -> UInt16)

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "123 -> x\n456 -> y\nx AND y -> d\nx OR y -> e\n\nx LSHIFT 2 -> f\ny RSHIFT 2 -> g\nNOT x -> h\nNOT y -> i\nd -> a\n1 AND x -> z"
        } else {
            inputString = try InputGetter.getInput(for: 7, part: .first)
        }
        self.input = inputString
            .components(separatedBy: "\n")
    }

    func runPart1() throws {
        let (instructions, wires) = parseInput()
        let newWires = runProgram(instructions: instructions, values: wires)
        print(newWires["a"] ?? "none found")
    }

    func runPart2() throws {
        var (instructions, wires) = parseInput()
        let newWires = runProgram(instructions: instructions, values: wires)
        wires["b"] = newWires["a"]!
        let result = runProgram(instructions: instructions, values: wires)
        print(result["a"]  ?? "none found")
    }

    func runProgram(instructions: [String: Operation], values: [String: UInt16]) -> [String: UInt16] {
        var wires = values
        var instructions = instructions

        var count = 0
        var lastCount: Int?

        while !(instructions.isEmpty) {
            if count % 100 == 0 {
                print("Iteration \(count)")
            }
            guard lastCount != instructions.count else {
                fatalError("Nothing is changing")
            }
            lastCount = instructions.count
            count += 1

            var toRemove: [String] = []
            for instruction in instructions {
                let first = instruction.value.0

                guard let firstVal = UInt16(first) ?? wires[first] else {
                    // continue when value ist not yet set
                    continue
                }

                guard let second = instruction.value.1 else {
                    // operation only needs one argument, so calculation can be done
                    wires[instruction.key] = instruction.value.2(firstVal, 0)
                    toRemove.append(instruction.key)
                    continue
                }

                guard let secondVal = UInt16(second) ?? wires[second] else {
                    // continue when second value ist not yet set
                   continue
                }

                wires[instruction.key] = instruction.value.2(firstVal, secondVal)
                toRemove.append(instruction.key)
                
            }
            toRemove.forEach { instructions.removeValue(forKey: $0) }
        }

        return wires
    }

    private func parseInput() -> (operations: [String: Operation], wires: [String: UInt16]) {
        var instructions: [String: Operation] = [:]
        var wires: [String: UInt16] = [:]

        for row in input {
            let split = row.components(separatedBy: " ")
            switch split.count {
            // input, e.g 123 -> x
            case 3 where Int(split[0]) != nil:
                wires[split.last!] = UInt16(split[0])
            // passthrough, e.g. d -> a
            case 3:
                instructions[split.last!] = (split[0], nil, { first, _ in first })
            // complement, e.g. NOT y -> i
            case 4:
                instructions[split.last!] = (split[1], nil, { first, _ in ~first })
            // AND, e.g. x AND y -> i
            case 5 where split[1] == "AND":
                instructions[split.last!] = (split[0], split[2], { $0 & $1})
            // OR, e.g. x OR y -> i
            case 5 where split[1] == "OR":
                instructions[split.last!] = (split[0], split[2], { $0 | $1})
            // LSHIFT, e.g. x LSHIFT 2 -> i
            case 5 where split[1] == "LSHIFT":
                instructions[split.last!] = (split[0], split[2], { $0 << $1})
            // RSHIFT, e.g. x RSHIFT 2 -> i
            case 5 where split[1] == "RSHIFT":
                instructions[split.last!] = (split[0], split[2], { $0 >> $1})
            default:
                fatalError("Unknown instruction")
            }
        }
        return (instructions, wires)
    }
}