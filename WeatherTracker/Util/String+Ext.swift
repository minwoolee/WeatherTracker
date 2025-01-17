//
//  String+Ext.swift
//  WeatherTracker
//
//  Created by Min Woo Lee on 1/15/25.
//

import Foundation

extension String: @retroactive Error {
    public var errorDescription: String? { return self }
}
