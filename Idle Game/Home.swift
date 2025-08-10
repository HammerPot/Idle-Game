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
        if gameManager.colorMode == 0 {
            HStack {
                VStack {
                    ForEach(gameManager.buttons) { button in
                        Button(button.name) {
                            print("Button \(button.name) Tapped")
                            gameManager.buttons[button.id].current += 1
                            print("Count: \(gameManager.buttons[button.id].current)")
                            print("\(gameManager.buttons)")
                            gameManager.addMoney(amount: button.value * gameManager.tapStrength)
                            print("Money: \(gameManager.money)")
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        .controlSize(.large)
                        .sensoryFeedback(.impact, trigger: gameManager.buttons[button.id].current)
                        .sensoryFeedback(.success, trigger: gameManager.allTimeMoney == 10)
                    }
                }
                VStack {
                    ForEach(gameManager.buttonsA) { button in
                        Button(button.name) {
                            print("Button \(button.name) Tapped")
                            // gameManager.addMoney(amount: button.value * gameManager.tapStrength)
                            gameManager.incrementAutoButton(button: button.id)
                            print("Count: \(gameManager.buttonsA[button.id].current)")
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        .controlSize(.large)
                        .sensoryFeedback(.impact, trigger: gameManager.buttonsA[button.id].current)
                        .sensoryFeedback(.success, trigger: gameManager.buttonsA[button.id].current == 0)
                    }
                }
            }
        }
        if gameManager.colorMode == 1 {
            HStack {
                VStack {
                    ForEach(gameManager.buttons) { button in
                        Button(button.name) {
                            print("Button \(button.name) Tapped")
                            gameManager.buttons[button.id].current += 1
                            print("Count: \(gameManager.buttons[button.id].current)")
                            print("\(gameManager.buttons)")
                            gameManager.addMoney(amount: button.value * gameManager.tapStrength)
                            print("Money: \(gameManager.money)")
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        .controlSize(.large)
                        .sensoryFeedback(.impact, trigger: gameManager.buttons[button.id].current)
                        .sensoryFeedback(.success, trigger: gameManager.allTimeMoney == 10)
                        .tint(Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), opacity: 1))
                    }
                }
                VStack {
                    ForEach(gameManager.buttonsA) { button in
                        Button(button.name) {
                            print("Button \(button.name) Tapped")
                            // gameManager.addMoney(amount: button.value * gameManager.tapStrength)
                            gameManager.incrementAutoButton(button: button.id)
                            print("Count: \(gameManager.buttonsA[button.id].current)")
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        .controlSize(.large)
                        .sensoryFeedback(.impact, trigger: gameManager.buttonsA[button.id].current)
                        .sensoryFeedback(.success, trigger: gameManager.buttonsA[button.id].current == 0)
                        .tint(Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), opacity: 1))
                    }
                }
            }
        }
        if gameManager.colorMode == 2 {
            let random: Double = Double.random(in: 0...1)
            var randResult: Int = random < 0.9 ? 0 : 1

            HStack {
                VStack {
                    ForEach(gameManager.buttons) { button in
                        Button(button.name) {
                            print("Button \(button.name) Tapped")
                            gameManager.buttons[button.id].current += 1
                            print("Count: \(gameManager.buttons[button.id].current)")
                            print("\(gameManager.buttons)")
                            if randResult == 1 {
                                gameManager.addMoney(amount: button.value * gameManager.tapStrength * 10)
                                print("HIT x10")
                            }
                            else {
                                gameManager.addMoney(amount: button.value * gameManager.tapStrength)
                            }
                            print("Money: \(gameManager.money)")
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        .controlSize(.large)
                        .sensoryFeedback(randResult == 1 ? .warning : .impact, trigger: gameManager.buttons[button.id].current)
                        .sensoryFeedback(.success, trigger: gameManager.allTimeMoney == 10)
                        .tint(Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), opacity: 1))
                    }
                }
                VStack {
                    ForEach(gameManager.buttonsA) { button in
                        Button(button.name) {
                            print("Button \(button.name) Tapped")
                            // gameManager.addMoney(amount: button.value * gameManager.tapStrength)
                            if randResult == 1 {
                                gameManager.incrementAutoButton(button: button.id, amount: 10)
                                print("HIT x10")

                            }
                            else {
                                gameManager.incrementAutoButton(button: button.id)
                            }
                            print("Count: \(gameManager.buttonsA[button.id].current)")
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        .controlSize(.large)
                        .sensoryFeedback(randResult == 1 ? .warning : .impact, trigger: gameManager.buttonsA[button.id].current)
                        .sensoryFeedback(.success, trigger: gameManager.buttonsA[button.id].current == 0)
                        .tint(Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), opacity: 1))
                    }
                }
            }
        }   
    }
}

#Preview {
    HomeView()
}
