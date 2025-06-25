//
//  Home.swift
//  Idle Game
//
//  Created by Potter on 6/25/25.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var gameManager = GameManager.shared

    var body: some View {
        VStack {
            Button("Tap Me") {
                print("Button Tapped")
                gameManager.addMoney(amount: 1)
                print(gameManager.money)
            }
            // .buttonRepeatBehavior(.enabled)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
            .sensoryFeedback(.impact, trigger: gameManager.money)
            .sensoryFeedback(.success, trigger: gameManager.money == 10)

            // .tint(.red)
            // .background(.red)
        }
    }
}

#Preview {
    HomeView()
}
