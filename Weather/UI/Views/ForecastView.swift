//
//  ForecastView.swift
//  Weather
//
//  Created by Arjun Shukla on 3/18/23.
//

import SwiftUI

struct DisplayTemperatureModel {
    let temperature: String
    let feelLike: String
    let minTemp: String
    let maxTemp: String
}

struct DisplayWeatherModel {
    let cityName: String
    let mainForecast: String
    let forecastDescription: String
    var forecastIconUrl: URL?
}

class ForecastModel: ObservableObject {
    @Published var showForecast: Bool
    
    @Published var weatherModel: DisplayWeatherModel
    
    @Published var temperatureModel: DisplayTemperatureModel
    
    init(showForecast: Bool,
         weatherModel: DisplayWeatherModel,
         temperatureModel: DisplayTemperatureModel) {
        self.showForecast = showForecast
        self.weatherModel = weatherModel
        self.temperatureModel = temperatureModel
    }
}

struct ForecastView: View {
    @ObservedObject var model: ForecastModel

    var body: some View {
        ScrollView {
            VStack {
                if model.showForecast {
                    forecastImage
                    forecast
                } else {
                    NoForecastView()
                }
            }
        }
    }
}

private extension ForecastView {
    var forecastImage: some View {
        AsyncImage(url: model.weatherModel.forecastIconUrl) { image in
            image
        } placeholder: {
            Image("placeholder_forecast")
        }
    }
    
    var forecast: some View {
        VStack {
            Text(model.weatherModel.cityName)
            Text(model.weatherModel.mainForecast)
            Text(model.weatherModel.forecastDescription)
            Text(model.temperatureModel.temperature)
            Text(model.temperatureModel.feelLike)
            Text(model.temperatureModel.maxTemp)
            Text(model.temperatureModel.minTemp)
        }
    }
}

//struct ForecastView_Previews: PreviewProvider {
//    static var previews: some View {
//        let weatherModel = DisplayWeatherModel(cityName: "Fremont",
//                                               mainForecast: "Clouds",
//                                               forecastDescription: "Overcast clouds",
//                                               forecastIconUrl: URL(string: "https://openweathermap.org/img/wn/10d@2x.png")!)
//
//        let temperatureModel = DisplayTemperatureModel(temperature: "15", feelLike: "12", minTemp: "5", maxTemp: "17")
//
//        var model = ForecastModel(showForecast: true, weatherModel: weatherModel, temperatureModel: temperatureModel)
//
//        ForecastView(model: Binding<ForecastModel> (
//            get: { model },
//            set: { model = $0 }))
//    }
//}
