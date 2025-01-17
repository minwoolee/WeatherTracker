//
//  ContentView.swift
//  WeatherTracker
//
//  Created by Min Woo Lee on 1/15/25.
//

import SwiftUI

struct HomeView: View {

    @State var viewModel = ViewModel()
    @StateObject var searchContext = SearchContext()

    var body: some View {
        VStack {
            SearchField()
            Spacer()
            if let id = viewModel.currentId {
                CityView(id: id)
            } else if searchContext.debouncedQuery.isEmpty {
                ContentUnavailableView {
                    Text("No City Selected").font(.system(size: 30))
                } description: {
                    Text("Please Search For A City").font(.system(size: 15))
                }
            } else {
                SearchResultView(viewModel: viewModel, query: searchContext.debouncedQuery)
            }
        }
        .padding()
    }

    fileprivate func SearchField() -> some View {
        return TextField("Search Location", text: $searchContext.query)
            .padding(.leading)
            .frame(height: 46)
            .background(Color("background"))
            .cornerRadius(16)
            .foregroundStyle(Color("foregroundLight"))
            .overlay(alignment: .trailing) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color("foregroundLight"))
                    .padding(.trailing)
            }
            .onChange(of: searchContext.query) {
                viewModel.clear()
            }
    }
}



#Preview {
    let previewUserDefaults: UserDefaults = {
        let d = UserDefaults(suiteName: "preview_user_defaults")!
        d.set(2549438, forKey: "currentId")
        return d
    }()
    HomeView(viewModel: ViewModel(userDefaults: previewUserDefaults))

}
