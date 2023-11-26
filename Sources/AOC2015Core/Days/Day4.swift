//
//  File.swift
//  
//
//  Created by Philipp Wallrich on 27.09.23.
//

import Foundation
import CryptoKit

class Day4: Day {
    var day: Int { 4 }
    let input: String

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "abcdef"
        } else {
            inputString = "yzbqklnj"
        }
        self.input = inputString
    }

    func runPart1() throws {
        let regex = try Regex("00000[0-9]+")
        var curr = 1
        while curr < 1_000_000_000 {
            let hash = (input + "\(curr)").MD5
            if hash.starts(with: regex) {
                print(curr)
                break
            }
            curr += 1
            if curr % 1000 == 0 {
                print("current iteration: \(curr)")
            }
        }
    }

    func runPart2() throws {
        let regex = try Regex("000000[0-9]+")
        var curr = 1
        while curr < 1_000_000_000 {
            let hash = (input + "\(curr)").MD5
            if hash.starts(with: regex) {
                print(curr)
                break
            }
            curr += 1
            if curr % 1000 == 0 {
                print("current iteration: \(curr)")
            }
        }
    }
}

extension String {
var MD5: String {
        let computed = Insecure.MD5.hash(data: self.data(using: .utf8)!)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
}
