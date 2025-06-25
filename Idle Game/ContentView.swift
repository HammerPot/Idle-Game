//
//  ContentView.swift
//  Idle Game
//
//  Created by Potter on 6/24/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var gameManager = GameManager.shared
    var body: some View {
        if gameManager.money >= 10 {
            TabView {
                Tab("Home", systemImage: "house") {
                    HomeView()
                }
                Tab("Shop", systemImage: "cart") {
                    ShopView()
                }
            }
        }
        else {
            TabView {
                Tab("Home", systemImage: "house") {
                    HomeView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
