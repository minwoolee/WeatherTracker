//
//  SearchContext.swift
//  WeatherTracker
//
//  Created by Min Woo Lee on 1/15/25.
//

import Foundation

class SearchContext: ObservableObject {

    @Published var query = ""
    @Published var debouncedQuery = ""

    init() {
        $query
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .assign(to: &$debouncedQuery)
    }
}
