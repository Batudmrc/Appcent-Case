//
//  Genre.swift
//  Appcent-Case
//
//  Created by Batuhan Demircioğlu on 8.05.2023.
//
import Foundation

// MARK: - Genre
struct Genre: Codable {
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let id: Int
    let name: String
    let picture: String
    let picture_big: String

    enum CodingKeys: String, CodingKey {
        case id, name, picture,picture_big
    }
}

