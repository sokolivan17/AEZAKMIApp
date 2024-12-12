//
//  Country.swift
//  AEZAKMIApp
//
//  Created by Ваня Сокол on 05.12.2024.
//

import Foundation

struct Translations: Codable {
    let bre: Name
    let rus: Name
}

struct Name: Codable {
    let common: String
    let official: String
}

struct Country: Codable {
    let flag: String
    let continents: [String]
    let currencies: [String: Currency]?
    let languages: [String: String]?
    let translations: [String: Name]
    let latlng: [Double]
    let area: Double
    let population: Int
    let timezones: [String]
    let flags: Flags
    let capital: [String]?
}

struct Flags: Codable {
    let png: String
    let svg: String
}

struct Currency: Codable {
    let name: String
    let symbol: String
}

