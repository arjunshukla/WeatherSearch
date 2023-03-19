//
//  NoForecastView.swift
//  Weather
//
//  Created by Arjun Shukla on 3/19/23.
//

import SwiftUI

struct NoForecastView: View {
    var body: some View {
        VStack {
            Image("no_forecast")
            Text("Nothing to display at this time, please search for a location.")
        }
    }
}

struct NoForecastView_Previews: PreviewProvider {
    static var previews: some View {
        NoForecastView()
    }
}
