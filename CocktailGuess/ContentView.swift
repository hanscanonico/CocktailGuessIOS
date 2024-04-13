//
//  ContentView.swift
//  CocktailGuess
//
//  Created by Hans Canonico on 13/04/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "magnifyingglass")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Find the cocktail")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
