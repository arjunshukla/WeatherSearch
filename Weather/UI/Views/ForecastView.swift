//
//  ForecastView.swift
//  Weather
//
//  Created by Arjun Shukla on 3/18/23.
//

import CachedAsyncImage
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

//class ForecastModel: ObservableObject {
//    @Published var showForecast: Bool
//
//    @Published var weatherModel: DisplayWeatherModel
//
//    @Published var temperatureModel: DisplayTemperatureModel
//
//    init(showForecast: Bool,
//         weatherModel: DisplayWeatherModel,
//         temperatureModel: DisplayTemperatureModel) {
//        self.showForecast = showForecast
//        self.weatherModel = weatherModel
//        self.temperatureModel = temperatureModel
//    }
//}

struct ForecastModel {
    var showForecast: Bool
    var weatherModel: DisplayWeatherModel
    var temperatureModel: DisplayTemperatureModel
}


struct ForecastView: View {
    
    var model: ForecastModel

    var body: some View {
        ScrollView {
            VStack {
                if model.showForecast {
                    forecastImage
                    forecast
                    temperatureSection
                } else {
                    NoForecastView()
                }
            }
            .padding()
        }
    }
}

private extension ForecastView {
    var forecastImage: some View {
        CachedAsyncImage(url: model.weatherModel.forecastIconUrl, urlCache: .imageCache) { image in
            image
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
                .padding()
        } placeholder: {
            Image("no_forecast")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
                .padding()
        }
    }
    
    var forecast: some View {
        VStack {
            Text(model.weatherModel.cityName)
            Text(model.weatherModel.mainForecast)
            Text(model.weatherModel.forecastDescription)
        }
        .padding()
    }
    
    var temperatureSection: some View {
        VStack(alignment: .center) {
            KeyValueView(key: "Current : ", value: model.temperatureModel.temperature)
            KeyValueView(key: "Feels like : ", value: model.temperatureModel.feelLike)
            KeyValueView(key: "Max : ", value: model.temperatureModel.maxTemp)
            KeyValueView(key: "Min : ", value: model.temperatureModel.minTemp)
        }.padding()
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
