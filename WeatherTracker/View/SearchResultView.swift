//
//  SearchView.swift
//  WeatherTracker
//
//  Created by Min Woo Lee on 1/16/25.
//
import SwiftUI

struct SearchResultView: View {
    @State var viewModel: ViewModel
    var query: String
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.searchResult, id: \.id) { result in
                    SearchResultRowView(city: result)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .padding(.top)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.currentId = result.id
                        }
                }
            }
            .listStyle(.plain)
        }
        .task {
            do {
                try await viewModel.search(query: query)
            } catch {
                // do nothing
            }
        }
    }
}
