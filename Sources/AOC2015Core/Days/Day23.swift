import Foundation

class Day23: Day {
    var day: Int { 23 }
    let input: String

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = """
inc b
jio b, +2
tpl b
inc b
"""
        } else {
            inputString = try InputGetter.getInput(for: 23, part: .first)
        }
        self.input = inputString
    }

    func runPart1() throws {
        let instructions = input.split(separator: "\n").map { $0.components(separatedBy: " " )}
        var instructionPointer = 0
        var registers: [String: UInt] = ["a": 0, "b": 0]
        while instructionPointer < instructions.count {
            let instruction = instructions[instructionPointer]
            print(instruction, instructionPointer, registers)
            switch instruction[0] {
            case "hlf":
                registers[instruction[1]]! /= 2
                instructionPointer += 1
            case "tpl":
                registers[instruction[1]]! *= 3
                instructionPointer += 1
            case "inc":
                registers[instruction[1]]! += 1
                instructionPointer += 1
            case "jmp":
                instructionPointer += Int(instruction[1])!
            case "jie":
                let registerName = instruction[1].replacingOccurrences(of: ",", with: "")
                if registers[registerName]! % 2 == 0 {
                    instructionPointer += Int(instruction[2])!
                } else {
                    instructionPointer += 1
                }
            case "jio":
                let registerName = instruction[1].replacingOccurrences(of: ",", with: "")
                if registers[registerName]! == 1 {
                    instructionPointer += Int(instruction[2])!
                } else {
                    instructionPointer += 1
                }
            default:
                fatalError("Unknown instruction")
            }
        }
        print(registers["b"]!)
    }

    func runPart2() throws {
        let instructions = input.split(separator: "\n").map { $0.components(separatedBy: " " )}
        var instructionPointer = 0
        var registers: [String: UInt] = ["a": 1, "b": 0]
        while instructionPointer < instructions.count {
            let instruction = instructions[instructionPointer]
            print(instruction, instructionPointer, registers)
            switch instruction[0] {
            case "hlf":
                registers[instruction[1]]! /= 2
                instructionPointer += 1
            case "tpl":
                registers[instruction[1]]! *= 3
                instructionPointer += 1
            case "inc":
                registers[instruction[1]]! += 1
                instructionPointer += 1
            case "jmp":
                instructionPointer += Int(instruction[1])!
            case "jie":
                let registerName = instruction[1].replacingOccurrences(of: ",", with: "")
                if registers[registerName]! % 2 == 0 {
                    instructionPointer += Int(instruction[2])!
                } else {
                    instructionPointer += 1
                }
            case "jio":
                let registerName = instruction[1].replacingOccurrences(of: ",", with: "")
                if registers[registerName]! == 1 {
                    instructionPointer += Int(instruction[2])!
                } else {
                    instructionPointer += 1
                }
            default:
                fatalError("Unknown instruction")
            }
        }
        print(registers["b"]!)
    }
}
