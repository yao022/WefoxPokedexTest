//
//  Pokemon.swift
//  WefoxPokedex
//
//  Created by Jordi Ferrer Pedrol on 07/04/2019.
//  Copyright © 2019 Jordi Ferrer Pedrol. All rights reserved.
//


import Foundation
import MapKit
import CoreLocation


struct PokemonResponse: Codable {
    let abilities: [Ability]
    let baseExperience: Int
    let forms: [Species]
    let gameIndices: [GameIndex]
    let height: Int
    let heldItems: [HeldItem]
    let id: Int
    let isDefault: Bool
    let locationAreaEncounters: String
    let moves: [Move]
    let name: String
    let order: Int
    let species: Species
    let sprites: Sprites
    let stats: [Stat]
    let types: [TypeElement]
    let weight: Int
    var tsCatched: Date?
    
    enum CodingKeys: String, CodingKey {
        case abilities
        case baseExperience = "base_experience"
        case forms
        case gameIndices = "game_indices"
        case height
        case heldItems = "held_items"
        case id
        case tsCatched
        case isDefault = "is_default"
        case locationAreaEncounters = "location_area_encounters"
        case moves, name, order, species, sprites, stats, types, weight
    }
    
    
    static var backPack: [PokemonResponse] {
        
        if let objects = UserDefaults.standard.value(forKey: "backpack") as? Data {
            let decoder = JSONDecoder()
            if let objectsDecoded = try? decoder.decode(Array.self, from: objects) as [PokemonResponse] {
                return objectsDecoded.sorted(by: { $0.order > $1.order })
            } else {
                return  [PokemonResponse]()
            }
        } else {
            return [PokemonResponse]()
        }
    }
    
    static func getBackPack()-> [PokemonResponse] {
        
        if let objects = UserDefaults.standard.value(forKey: "backpack") as? Data {
            let decoder = JSONDecoder()
            if let objectsDecoded = try? decoder.decode(Array.self, from: objects) as [PokemonResponse] {
                return objectsDecoded
            } else {
                return  [PokemonResponse]()
            }
        } else {
            return [PokemonResponse]()
        }
    }
    
    static func saveBackpack(backpack: [PokemonResponse]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(backpack){
            UserDefaults.standard.set(encoded, forKey: "backpack")
        }
    }
    
   

}

struct Ability: Codable {
    let ability: Species
    let isHidden: Bool
    let slot: Int
    
    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
        case slot
    }
}

struct Species: Codable {
    let name: String
    let url: String
}

struct GameIndex: Codable {
    let gameIndex: Int
    let version: Species
    
    enum CodingKeys: String, CodingKey {
        case gameIndex = "game_index"
        case version
    }
}

struct HeldItem: Codable {
    let item: Species
    let versionDetails: [VersionDetail]
    
    enum CodingKeys: String, CodingKey {
        case item
        case versionDetails = "version_details"
    }
}

struct VersionDetail: Codable {
    let rarity: Int
    let version: Species
}

struct Move: Codable {
    let move: Species
    let versionGroupDetails: [VersionGroupDetail]
    
    enum CodingKeys: String, CodingKey {
        case move
        case versionGroupDetails = "version_group_details"
    }
}

struct VersionGroupDetail: Codable {
    let levelLearnedAt: Int
    let moveLearnMethod, versionGroup: Species
    
    enum CodingKeys: String, CodingKey {
        case levelLearnedAt = "level_learned_at"
        case moveLearnMethod = "move_learn_method"
        case versionGroup = "version_group"
    }
}

struct Sprites: Codable {
    let backDefault: String?
    let backFemale: String?
    let backShiny: String?
    let backShinyFemale: String?
    let frontDefault: String?
    let frontFemale: String?
    let frontShiny: String?
    let frontShinyFemale: String?
    
    enum CodingKeys: String, CodingKey {
        case backDefault = "back_default"
        case backFemale = "back_female"
        case backShiny = "back_shiny"
        case backShinyFemale = "back_shiny_female"
        case frontDefault = "front_default"
        case frontFemale = "front_female"
        case frontShiny = "front_shiny"
        case frontShinyFemale = "front_shiny_female"
    }
}

struct Stat: Codable {
    let baseStat, effort: Int
    let stat: Species
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort, stat
    }
}

struct TypeElement: Codable {
    let slot: Int
    let type: Species
}

