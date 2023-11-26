import Foundation

fileprivate let boss: Day22.Player = .init(health: 51, damage: 9)

class Day22: Day {
    var day: Int { 22 }
        
    let boss: Player

    struct Player {
        var health: Int
        var damage: Int
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

    struct Spell: Hashable {
        let name: String
        let cost: Int
        let damage: Int
        let health: Int
        let effect: Effect?

        static let spells: [Spell] = [
            .init(name: "Magic Missile", cost: 53, damage: 4, health: 0, effect: nil),
            .init(name: "Drain", cost: 73, damage: 2, health: 2, effect: nil),
            .init(name: "shield", cost: 113, damage: 0, health: 0, effect: .init(name: "armor", turns: 6, damage: 0, armor: 7, mana: 0)),
            .init(name: "Poison", cost: 173, damage: 0, health: 0, effect: .init(name: "damage", turns: 6, damage: 3, armor: 0, mana: 0)),
            .init(name: "Recharge", cost: 229, damage: 0, health: 0, effect: .init(name: "mana", turns: 5, damage: 0, armor: 0, mana: 101)),
        ]
    }

    struct Effect: Hashable {
        let name: String
        var turns: Int
        let damage: Int
        let armor: Int
        let mana: Int
    }

    init(testInput: Bool) throws {
        if testInput {
            boss = Player(health: 51, damage: 9)
        } else {
            boss = Player(health: 51, damage: 9)
        }
        
    }

    func runPart1() throws {
        // 0-2 rings
        // 1 weapon
        // 0 or 1 armor
        let initialHealth = 50
        let initialMana = 500

        let best = getBest(gameStep: .init(mana: initialMana, health: initialHealth, effects: [], bossHealth: boss.health, turn: true, spellsBought: [], spent: 0, isHard: false))

        print(best)
    }

    func runPart2() throws {
        let initialHealth = 50
        let initialMana = 500

        let best = getBest(gameStep: .init(mana: initialMana, health: initialHealth, effects: [], bossHealth: boss.health, turn: true, spellsBought: [], spent: 0, isHard: true))

        print(best)
    }

    struct GameStep: Hashable {
        private(set) var mana: Int
        private(set) var health: Int
        private(set) var effects: [Effect]
        private(set) var bossHealth: Int
        private(set) var turn: Bool
        private(set) var spellsBought: [Spell]
        private(set) var spent: Int

        let isHard: Bool
    }

    func getBest(gameStep: GameStep) -> (Int, Bool) {
        if let res = gameStep.isGameOver() {
            return res
        }

        guard gameStep.turn else {
            let nextStep = gameStep.takeBossStep()
            return getBest(gameStep: nextStep)
        }

        var best: Int?
        for nextStep in gameStep.takePlayerTurn() {
            let res = getBest(gameStep: nextStep)
            if res.1 {
                best = min(best ?? .max, res.0)
            }
        }

        if let best {
            return (best, true)
        } else {
            return (-1, false)
        }
    }
}

extension Day22.GameStep {
    func isGameOver() -> (Int, Bool)? {
        guard health > 0 && mana >= 53 else {
            return (.max, false)
        }
        guard bossHealth > 0 else {
            return (spent, true)
        }
        return nil
    }

    func takeBossStep() -> Self {
        var nextStep = self

        let armor = nextStep.applyEffects()

        guard nextStep.bossHealth > 0 else {
            return nextStep
        }

        nextStep.health -= max(1, boss.damage - armor)
        nextStep.turn.toggle()
        return nextStep
    }

    func takePlayerTurn() -> [Self] {
        var nextStep = self

        if isHard {
            nextStep.health -= 1

            guard nextStep.health > 0 else {
                return [nextStep]
            }
        }

        let _ = nextStep.applyEffects()

        guard nextStep.bossHealth > 0 else {
            return [nextStep]
        }

        return nextStep.nextPossibleSpells().map { next in
            var nextStep = nextStep
            nextStep.bossHealth -= next.damage
            nextStep.mana -= next.cost
            nextStep.health += next.health
            nextStep.effects += [next.effect].compactMap { $0 }
            nextStep.turn.toggle()
            nextStep.spellsBought.append(next)
            nextStep.spent += next.cost
            return nextStep
        }
    }

    func nextPossibleSpells() -> [Day22.Spell] {
        Day22.Spell.spells
            .filter { $0.cost <= mana}
            .filter { spell in
                guard let effect = spell.effect else { return true }
                return !effects.contains { effect.name == $0.name }
            }
    }

    private mutating func applyEffects() -> Int {
        var armor = 0
        for effect in effects {
            armor += effect.armor
            self.bossHealth -= effect.damage
            self.mana += effect.mana
        }

        self.effects = effects.compactMap {
            var effect = $0
            effect.turns -= 1
            return effect.turns > 0 ? effect : nil
        }

        return armor
    }
}
