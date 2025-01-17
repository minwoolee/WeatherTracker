//
//  City.swift
//  WeatherTracker
//
//  Created by Min Woo Lee on 1/15/25.
//

import Foundation

struct City: Decodable {
    var id = Int()
    let location: Location
    let current: Current
    
    private enum CodingKeys: String, CodingKey {
        case location, current
    }
}

struct Location: Decodable {
    let name: String
}

struct Current: Decodable {
    let temperature: Decimal
    let condition: Condition
    let humidity: Int
    let uv: Decimal
    let feelslike: Decimal

    private enum CodingKeys: String, CodingKey {
        case temperature = "temp_c"
        case condition
        case humidity
        case uv
        case feelslike = "feelslike_c"
    }
}

struct Condition: Decodable {
    let icon: String

    private enum CodingKeys: String, CodingKey {
        case icon
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let iconUrl = try container.decode(String.self, forKey: .icon)
        icon = "https:" + iconUrl
    }

    init(icon: String) {
        self.icon = icon
    }
}

struct SearchResult: Decodable {
    let id: Int
}
