//
//  ChuckNorris.swift
//  ChuckNorrisFacts
//
//  Created by Руслан Арыстанов on 05.02.2025.
//

import Foundation

struct ChuckNorris: Decodable {
    let iconUrl: String
    let value: String
}

struct Result: Decodable {
    let result: [ChuckNorris]
}

struct Category: Decodable {
    let categories: [String]
}
