//
//  SearchResultView.swift
//  WeatherTracker
//
//  Created by Min Woo Lee on 1/15/25.
//

import SwiftUI

struct SearchResultRowView: View {
    @State var city: City
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(city.location.name)
                    .font(.system(size: 20))
                    .fontWeight(.heavy)
                Text("\(city.current.temperature)°")
                    .font(.system(size: 60))
                    .fontWeight(.bold)
            }
            .padding(.leading, 30)
            Spacer()
            AsyncImage(url: URL(string: city.current.condition.icon)!) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 83)
                    .padding(.trailing, 30)
            } placeholder: {
                ProgressView()
            }
        }
        .frame(height: 117)
        .background(Color("background"))
        .cornerRadius(16)
    }
}

#Preview {
    let city: City = {
        let location = Location(name: "Hyderabad")
        let current = Current(
            temperature: 31,
            condition: Condition(icon: "https://cdn.weatherapi.com/weather/64x64/day/113.png"),
            humidity: 20,
            uv: 4,
            feelslike: 38
        )
        let city = City(location: location, current: current)
        return city
    }()
    SearchResultRowView(city: city)
}
