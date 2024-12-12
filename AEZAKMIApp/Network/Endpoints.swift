//
//  Endpoints.swift
//  AEZAKMIApp
//
//  Created by Ваня Сокол on 12.12.2024.
//

import Foundation

enum Endpoints {
    private static var baseURL: URL {
        return try! URL(string: "https://" + Configuration.value(for: "API_BASE_URL"))!
    }
    static let all = "\(baseURL)/v3.1/all"
}
