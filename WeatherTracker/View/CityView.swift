//
//  CityView.swift
//  WeatherTracker
//
//  Created by Min Woo Lee on 1/15/25.
//
import SwiftUI

struct CityView: View {

    var id: Int
    @State var city: City?

    var body: some View {
        VStack {
            if let city {
                AsyncImage(
                    url: URL(string: city.current.condition.icon)!
                ) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 123, height: 123)
                } placeholder: {
                    ProgressView()
                }
                CityNameView(city)
                TemperatureView(city)
                AdditionalMeasuresView(city)
            }
            Spacer()
        }
        .offset(y: 80)
        .task {
            do {
                print("loading city with id \(id)")
                self.city = try await ViewModel.fetchWeather(id: id)
            } catch {
                // do nothing per spec
            }
        }

    }

    fileprivate func CityNameView(_ city: City) -> HStack<TupleView<(Text, Image)>> {
        return HStack {
            Text(city.location.name)
                .font(.system(size: 30))
                .fontWeight(.bold)
            Image(systemName: "location.fill")
        }
    }

    fileprivate func TemperatureView(_ city: City) -> HStack<TupleView<(Text, Text)>> {
        return HStack {
            Text("\(city.current.temperature)")
                .font(.system(size: 70))
                .fontWeight(.bold)
            Text("°")
                .font(.system(size: 70))
        }
    }

    fileprivate func AdditionalMeasuresView(_ city: City) -> some View {
        return HStack {
            VStack {
                Text("Humidity")
                    .font(.system(size: 12))
                    .foregroundStyle(Color("foregroundLight"))
                    .frame(height: 18)
                Text("\(city.current.humidity)%")
                    .font(.system(size: 15))
                    .fontWeight(.medium)
                    .foregroundStyle(Color("foregroundDark"))
                    .frame(height: 23)
            }
            .padding()
            Spacer()
            VStack {
                Text("UV")
                    .font(.system(size: 12))
                    .foregroundStyle(Color("foregroundLight"))
                    .frame(height: 18)
                Text("\(city.current.uv)")
                    .font(.system(size: 15))
                    .fontWeight(.medium)
                    .foregroundStyle(Color("foregroundDark"))
                    .frame(height: 23)
            }
            Spacer()
            VStack {
                Text("Feels Like")
                    .font(.system(size: 12))
                    .foregroundStyle(Color("foregroundLight"))
                    .frame(height: 18)
                Text("\(city.current.feelslike)°")
                    .font(.system(size: 15))
                    .fontWeight(.medium)
                    .foregroundStyle(Color("foregroundDark"))
                    .frame(height: 23)
            }
            .padding()
        }
        .frame(width: 274, height: 75)
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
    CityView(id: 123, city: city)
}
