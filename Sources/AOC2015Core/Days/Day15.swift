import Foundation
import RegexBuilder
import Algorithms

class Day15: Day {
    var day: Int { 15 }
    let input: String

    let regex = Regex {
        Capture {
            OneOrMore(.word)
        }
        ": capacity "
        TryCapture {
            Optionally {
                "-"
            }
            OneOrMore(.digit)
        } transform: { Int($0) }
        ", durability "
        TryCapture {
            Optionally {
                "-"
            }
            OneOrMore(.digit)
        } transform: { Int($0) }
        ", flavor "
        TryCapture {
            Optionally {
                "-"
            }
            OneOrMore(.digit)
        } transform: { Int($0) }
        ", texture "
        TryCapture {
            Optionally {
                "-"
            }
            OneOrMore(.digit)
        } transform: { Int($0) }
        ", calories "
        TryCapture {
            Optionally {
                "-"
            }
            OneOrMore(.digit)
        } transform: { Int($0) }
    }

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = """
Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3
"""
        } else {
            inputString = try InputGetter.getInput(for: 15, part: .first)
        }
        self.input = inputString
    }

    typealias Ingredient = (capacity: Int, durability: Int, flavor: Int, texture: Int, calories: Int)

    func runPart1() throws {
        var ingredients: [Substring: Ingredient] = [:]
        
        for match in input.matches(of: regex) {
            // print(match.output)
            ingredients[match.1] = (match.2, match.3, match.4, match.5, match.6)
        }

        // print(ingredients)
        
        let combinations = (1...99).combinations(ofCount: ingredients.count).filter { $0.reduce(0, +) == 100 }
        let permutations = ingredients.keys.permutations()
        // print(combinations)

        var best = 0
        for permutation in permutations {
            for combination in combinations {
                assert(permutation.count == combination.count)
                var capacity = 0
                var durability = 0
                var flavor = 0
                var texture = 0

                for (ingredient, amount) in zip(permutation, combination) {
                    // print(ingredient, amount)
                    capacity += ingredients[ingredient]!.capacity * amount
                    durability += ingredients[ingredient]!.durability * amount
                    flavor += ingredients[ingredient]!.flavor * amount
                    texture += ingredients[ingredient]!.texture * amount
                }
                if capacity <= 0 || durability <= 0 || flavor <= 0 || texture <= 0 {
                    continue
                }
                best = max(capacity * durability * flavor * texture, best)
                // print(best)
            }
        }
        // print(ingredients)
        print(best)
    }

    func runPart2() throws {
        var ingredients: [Ingredient] = []
        
        for match in input.matches(of: regex) {
            // print(match.output)
            ingredients.append((match.2, match.3, match.4, match.5, match.6))
        }
        var best = 0

        for i in 0..<100 {
            print(i)
            for j in 0..<100 {
                if i + j >= 99 { continue }
                for k in 0..<100 {
                    if i + j + k >= 100 { continue }
                    for l in 0..<100 {
                        guard i + j + k + l == 100 else { continue }
                        let capacity = ingredients[0].capacity * i + ingredients[1].capacity * j + ingredients[2].capacity * k + ingredients[3].capacity * l
                        let durability = ingredients[0].durability * i + ingredients[1].durability * j + ingredients[2].durability * k + ingredients[3].durability * l
                        let flavor = ingredients[0].flavor * i + ingredients[1].flavor * j + ingredients[2].flavor * k + ingredients[3].flavor * l
                        let texture = ingredients[0].texture * i + ingredients[1].texture * j + ingredients[2].texture * k + ingredients[3].texture * l
                        let calories = ingredients[0].calories * i + ingredients[1].calories * j + ingredients[2].calories * k + ingredients[3].calories * l

                        if capacity <= 0 || durability <= 0 || flavor <= 0 || texture <= 0 {
                            continue
                        }       
                        guard calories == 500 else {
                            continue
                        }
                        
                        best = max(capacity * durability * flavor * texture, best)
                    }
                }

            }
        }
        print(best)
    }
    
}
