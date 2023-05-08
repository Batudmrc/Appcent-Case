//
//  Album.swift
//  Appcent-Case
//
//  Created by Batuhan Demircioğlu on 8.05.2023.
//

import Foundation

// MARK: - Album
struct Album: Codable {
    let data: [AlbumData]
}

// MARK: - Datum
struct AlbumData: Codable {
    let id: Int
    let title: String
    let link, cover: String
    let coverSmall, coverMedium, coverBig, coverXl: String
    let genreID, fans: Int
    let releaseDate: String
    let recordType: RecordTypeEnum
    let tracklist: String
    let type: RecordTypeEnum

    enum CodingKeys: String, CodingKey {
        case id, title, link, cover
        case coverSmall = "cover_small"
        case coverMedium = "cover_medium"
        case coverBig = "cover_big"
        case coverXl = "cover_xl"
        case genreID = "genre_id"
        case fans
        case releaseDate = "release_date"
        case recordType = "record_type"
        case tracklist
        case type
    }
}

enum RecordTypeEnum: String, Codable {
    case album = "album"
    case single = "single"
}
