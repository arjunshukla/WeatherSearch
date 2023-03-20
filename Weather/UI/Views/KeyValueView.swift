//
//  KeyValueView.swift
//  Weather
//
//  Created by Arjun Shukla on 3/19/23.
//

import SwiftUI

struct KeyValueView: View {
    let key: String
    let value: String

    var body: some View {
        HStack {
            Text(key)
            Spacer()
            Text(value)
        }
        .padding()
    }
}

struct ListItemView_Previews: PreviewProvider {
    static var previews: some View {
        KeyValueView(key: "Current Temperature", value: "73")
    }
}
