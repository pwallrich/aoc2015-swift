import Foundation
import RegexBuilder
class Day21: Day {
    var day: Int { 21 }
    
    let boss: Player

    let itemRegex = Regex {
        Capture {
            OneOrMore(.word)
        }
        OneOrMore(.whitespace)
        TryCapture {
            OneOrMore(.digit)
        } transform: { Int($0)}
        OneOrMore(.whitespace)
        TryCapture {
            OneOrMore(.digit)
        } transform: { Int($0)}
        OneOrMore(.whitespace)
        TryCapture {
            OneOrMore(.digit)
        } transform: { Int($0)}
    }
    struct Player {
        var health: Int
        var damage: Int
        let armor: Int

        let items: [Item]
    }

    struct Item {
        let name: String
        let cost: Int
        let damage: Int
        let armor: Int
        let type: ItemType

        enum ItemType: Hashable {
            case armor, weapon, ring
        }
    }

    let shop: [Item.ItemType: [Item]]

    init(testInput: Bool) throws {
        if testInput {
            boss = Player(health: 104, damage: 8, armor: 1, items: [])
        } else {
            boss = Player(health: 104, damage: 8, armor: 1, items: [])
        }
        var shop: [Item.ItemType: [Item]] = [:]
        let splitShop = shopString.split(separator: "\n\n")
        for itemString in splitShop {
            let type: Item.ItemType
            if itemString.starts(with: "Weapons") {
                type = .weapon
            } else if itemString.starts(with: "Armor") {
                type = .armor
            } else if itemString.starts(with: "Rings") {
                type = .ring
            } else {
                fatalError("Unkown Item Type")
            }
            var itemsOfType: [Item] = []
            for match in itemString.matches(of: itemRegex) {
                let item = Item(name: String(match.output.1), cost: match.output.2, damage: match.output.3, armor: match.output.4, type: type)
                itemsOfType.append(item)
            }
            shop[type] = itemsOfType

        }
        self.shop = shop
    }

    func runPart1() throws {
        // 0-2 rings
        // 1 weapon
        // 0 or 1 armor
        let initialHealth = 100
        
        let armorPermutations = shop[.armor]! + [.init(name: "None", cost: 0, damage: 0, armor: 0, type: .armor)]
        let ringPermutations = shop[.ring]!.permutations(ofCount: 1...2) + [[.init(name: "None", cost: 0, damage: 0, armor: 0, type: .ring)]]
        let weapons = shop[.weapon]!

        var best: Int = .max
        for armor in armorPermutations {
            for rings in ringPermutations {
                for weapon in weapons {
                    print("running with armor: \(armor.name), weapon: \(weapon), rings: \(rings.map { $0.name }.joined(separator: ", "))")
                    let cost = weapon.cost + rings.reduce(0) { $0 + $1.cost } + armor.cost
                    let health = 100
                    let damage = weapon.damage + rings.reduce(0) { $0 + $1.damage}
                    let armorValue = armor.armor + rings.reduce(0) { $0 + $1.armor}
                    if simulateFight(player: .init(health: health, damage: damage, armor: armorValue, items: [armor, weapon] + rings)) {
                        print("won: \(cost)")
                        best = min(best, cost)
                    }
                }
            }
        }
        print(best)
    }

    func runPart2() throws {
        // 0-2 rings
        // 1 weapon
        // 0 or 1 armor
        let initialHealth = 100
        
        let armorPermutations = shop[.armor]! + [.init(name: "None", cost: 0, damage: 0, armor: 0, type: .armor)]
        let ringPermutations = shop[.ring]!.permutations(ofCount: 1...2) + [[.init(name: "None", cost: 0, damage: 0, armor: 0, type: .ring)]]
        let weapons = shop[.weapon]!

        var worst: Int = .min
        for armor in armorPermutations {
            for rings in ringPermutations {
                for weapon in weapons {
                    print("running with armor: \(armor.name), weapon: \(weapon), rings: \(rings.map { $0.name }.joined(separator: ", "))")
                    let cost = weapon.cost + rings.reduce(0) { $0 + $1.cost } + armor.cost
                    let health = 100
                    let damage = weapon.damage + rings.reduce(0) { $0 + $1.damage}
                    let armorValue = armor.armor + rings.reduce(0) { $0 + $1.armor}
                    if !simulateFight(player: .init(health: health, damage: damage, armor: armorValue, items: [armor, weapon] + rings)) {
                        print("lost: \(cost)")
                        worst = max(worst, cost)
                    }
                }
            }
        }
        print(worst)
    }

    func simulateFight(player: Player) -> Bool {
        var turn = 0
        var boss = boss
        var player = player
        while player.health > 0 && boss.health > 0 {
            if turn % 2 == 0 {
                let damage = max(1, player.damage - boss.armor)
                boss.health -= damage
            } else {
                let damage = max(1, boss.damage - player.armor)
                player.health -= damage
            }
            turn += 1
        }
        return player.health > 0
    }
}

fileprivate let shopString = """
Weapons:    Cost  Damage  Armor
Dagger        8     4       0
Shortsword   10     5       0
Warhammer    25     6       0
Longsword    40     7       0
Greataxe     74     8       0

Armor:      Cost  Damage  Armor
Leather      13     0       1
Chainmail    31     0       2
Splintmail   53     0       3
Bandedmail   75     0       4
Platemail   102     0       5

Rings:      Cost  Damage  Armor
DamageOne    25     1       0
DamageTwo    50     2       0
DamageThree 100     3       0
DefenseOne   20     0       1
DefenseTwo   40     0       2
DefenseThree 80     0       3
"""
