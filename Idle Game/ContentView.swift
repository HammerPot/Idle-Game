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
        Text("Money: \(gameManager.money)")
        Text("All Time Money: \(gameManager.allTimeMoney)")
        Button("Reset Money") {
            gameManager.resetMoney()
        }
        Button("Reset Purchased Items") {
            ShopManager.shared.resetPurchasedItems()
        }
        if gameManager.allTimeMoney >= 10 {
            TabView {
                Tab("Home", systemImage: "house") {
                    HomeView()
                }
                Tab("Shop", systemImage: "cart") {
                    ShopView()
                }
                // Tab("Whiskers", systemImage: "face.smiling") {
                //     Whiskers()
                // }
                // Tab("Whiskers2", systemImage: "face.smiling.fill") {
                //     🌟WhiskersFinder300()
                // }
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
