//
//  Channels.swift
//  Limex_testApp
//
//  Created by Никита Горбунов on 30.06.2022.
//

import Foundation


struct Channels: Decodable {
    let channels: [Channel]
}

struct Channel: Decodable {
    let nameRu: String
    let url: String?
    let image: String?
    let current: Current?
}

struct Current: Decodable {
    let title: String
}

enum Link: String {
    case ChannelApi = "https://limehd.online/playlist/"
}
