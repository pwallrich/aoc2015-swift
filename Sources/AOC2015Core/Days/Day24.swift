import Foundation
import RegexBuilder

class Day24: Day {
    var day: Int { 24 }
    let input: String

    let regex = Regex {
        TryCapture {
            OneOrMore(.digit)
        } transform: {
            Int($0)
        }
    }

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "1\n2\n3\n4\n5\n7\n8\n9\n10\n11"
        } else {
            inputString = try InputGetter.getInput(for: 24, part: .first)
        }
        self.input = inputString
    }

    func runPart1() throws {
        let packages = input.matches(of: regex).map { $0.output.1 }.sorted(by: >)
        print(packages)

        var currentFirstCount = 2
        var results: [[Int]] = []
        while currentFirstCount < packages.count - 2 && results.isEmpty {
            let firstCombinations = packages.combinations(ofCount: currentFirstCount)

        firstPackageLoop:
            for (idx, firstPackages) in firstCombinations.enumerated() {
                //                print("scanning ", firstPackages , " at idx ", idx, " of ", firstCombinations.count, results.count, currentFirstCount, separator: "\t")
                let firstSum = firstPackages.reduce(0, +)

                var remainingSecondPackages = packages.filter { !firstPackages.contains($0) }

                if remainingSecondPackages.contains { $0 > firstSum } {
                    // if there's already a bigger number in the remaining packages, we will never make it
                    continue
                }
                for secondCount in 2..<remainingSecondPackages.count - 1 {
                    //                    print("checking second:", secondCount)
                    if remainingSecondPackages[..<secondCount].reduce(0, +) < firstSum {
                        // if the biggest numbers are smaller than the expected count, we can just continue, because there will be no combination for it
                        continue
                    }
                    if remainingSecondPackages.reduce(0, +) != 2 * firstSum {
                        continue
                    }
                    let secondCombinations = remainingSecondPackages.combinations(ofCount: secondCount)
                    for secondPackages in secondCombinations.sorted(by: { $0.reduce(1, *) < $1.reduce(1, *) }) {
                        //                        print("checking secondPackages", secondPackages)
                        let currentSecondSum = secondPackages.reduce(0, +)

                        if currentSecondSum >= firstSum {
                            continue
                        }

                        var remaining = remainingSecondPackages.filter { !secondPackages.contains($0) }
                        // do binarySearch
                        let idx = remainingSecondPackages.partitioningIndex(where: { $0 + currentSecondSum <= firstSum })
                        // no match found
                        guard idx < remaining.count else { continue }
                        let foundVal = remaining.remove(at: idx)
                        if firstSum == currentSecondSum + foundVal && remaining.reduce(0, +) == firstSum {
                            results.append(firstPackages)
                            // a result was found, we currently only care about the first packages
                            print("found match", firstPackages, firstPackages.reduce(1, *))
                            return
                        }
                    }
                }
            }
            currentFirstCount += 1
        }
        print(results)
    }


    func runPart2() throws {
        let packages = input.matches(of: regex).map { $0.output.1 }.sorted(by: >)
        print(packages)

        var currentFirstCount = 2
        var results: [[Int]] = []
        while currentFirstCount < packages.count - 2 && results.isEmpty {
            let firstCombinations = packages.combinations(ofCount: currentFirstCount)
        firstPackageLoop:
            for (idx, firstPackages) in firstCombinations.enumerated() {
                print("scanning ", firstPackages , " at idx ", idx, " of ", firstCombinations.count, results.count, currentFirstCount, separator: "\t")
                let firstSum = firstPackages.reduce(0, +)

                let remainingAfterFirst = packages.filter { !firstPackages.contains($0) }

                if remainingAfterFirst.reduce(0, +) != 3 * firstSum {
                    continue
                }

                for secondCount in 2..<remainingAfterFirst.count {
                    let secondCombinations = remainingAfterFirst.combinations(ofCount: secondCount)

                    for secondPackages in secondCombinations {
                        let currentSecondSum = secondPackages.reduce(0, +)
                        var remainingAfterSecond = remainingAfterFirst.filter { !secondPackages.contains($0) }

                        guard let secondIdx = remainingAfterSecond.indexOfValueThatAddesUp(to: firstSum, current: currentSecondSum) else {
                            continue
                        }
                        remainingAfterSecond.remove(at: secondIdx)

                        if remainingAfterSecond.reduce(0, +) != 2 * firstSum {
                            continue
                        }

                        for thirdCount in 2..<remainingAfterSecond.count {
                            let thirdCombinations = remainingAfterSecond.combinations(ofCount: thirdCount)
                            for thirdPackages in thirdCombinations {
                                let currentThirdSum = thirdPackages.reduce(0, +)
                                var remainingAfterThird = remainingAfterSecond.filter { !thirdPackages.contains($0) }

                                guard let secondIdx = remainingAfterThird.indexOfValueThatAddesUp(to: firstSum, current: currentThirdSum) else {
                                    continue
                                }
                                remainingAfterThird.remove(at: secondIdx)

                                guard remainingAfterThird.reduce(0, +) == firstSum else {
                                    continue
                                }
                                results.append(firstPackages)
                                continue firstPackageLoop
                            }
                        }

                    }
                }

            }
            currentFirstCount += 1
        }
        print(results)
        print(results.map { $0.reduce(1, *) }.min())
    }
}

extension Array where Element == Int {
    func indexOfValueThatAddesUp(to sum: Int, current: Int) -> Array.Index? {
        let idx = partitioningIndex(where: { $0 + current <= sum })
        guard idx < count else { return nil }
        guard self[idx] + current == sum else { return nil }
        return idx
    }
}
