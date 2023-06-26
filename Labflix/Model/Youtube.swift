//
//  Youtube.swift
//  Labflix
//
//  Created by Glenn Ludszuweit on 25/06/2023.
//

import Foundation

struct Youtube: Codable {
    let items: [YoutubeVideo]
}

struct YoutubeVideo: Codable {
    let id: VideoID
}

struct VideoID: Codable {
    let kind: String
    let videoId: String
}
