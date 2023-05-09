//
//  Track.swift
//  Appcent-Case
//
//  Created by Batuhan Demircioğlu on 9.05.2023.
//

import Foundation

// MARK: - Welcome
struct Track: Codable {
    let data: [TrackData]
    let total: Int
}

// MARK: - Datum
struct TrackData: Codable {
    let id: Int
    let title, titleShort, titleVersion: String
    let link: String
    let duration, rank: Int
    let preview: String

    enum CodingKeys: String, CodingKey {
        case id, title
        case titleShort = "title_short"
        case titleVersion = "title_version"
        case link, duration
        case rank
        case preview
    }
}

