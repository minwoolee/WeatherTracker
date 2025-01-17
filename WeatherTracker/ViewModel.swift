//
//  ViewModel.swift
//  WeatherTracker
//
//  Created by Min Woo Lee on 1/15/25.
//

import Foundation
import SwiftUI

@Observable class ViewModel {

    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }

    init() {
        userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: "currentId") != nil {
            currentId = userDefaults.integer(forKey: "currentId")
        }
    }

    let userDefaults: UserDefaults

    var searchResult: [City] = []

    var currentId: Int? {
        didSet {
            userDefaults.set(currentId, forKey: "currentId")
        }
    }

    func clear() {
        currentId = nil
        searchResult = []
    }

    func search(query: String) async throws {
        let url = URL(string: "https://api.weatherapi.com/v1/search.json")!
            .appending(
                queryItems: [
                    URLQueryItem(
                        name: "key",
                        value: "a71cb59c193a4731b30194505251501"
                    ),
                    URLQueryItem(name: "q", value:"\(query)")
                ]
            )
        print(url)
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw "Invalid response code"
            }
            let results = try JSONDecoder().decode([SearchResult].self, from: data)
            try await withThrowingTaskGroup(of: City.self) { group in
                for result in results {
                    group.addTask {
                        var city = try await Self.fetchWeather(id: result.id)
                        city.id = result.id
                        return city
                    }
                    for try await city in group {
                        searchResult.append(city)
                    }
                }
            }
        }
        catch {
            print(error)
        }
    }

    static func fetchWeather(id: Int) async throws -> City {
        let url = URL(string: "https://api.weatherapi.com/v1/forecast.json")!
            .appending(
                queryItems: [
                    URLQueryItem(
                        name: "key",
                        value: "a71cb59c193a4731b30194505251501"
                    ),
                    URLQueryItem(name: "q", value:"id:\(id)")
                ]
            )
        print(url)
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw "Invalid response code"
        }
        return try JSONDecoder().decode(City.self, from: data)
    }
}
