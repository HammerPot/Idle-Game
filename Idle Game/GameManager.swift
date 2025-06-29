//
//  GameManager.swift
//  Idle Game
//
//  Created by Potter on 6/25/25.
//

import Foundation
import SwiftUI
import Combine


class GameManager: ObservableObject {
	static let shared = GameManager()
	@Published var allTimeMoney: Int = UserDefaults.standard.integer(forKey: "allTimeMoney")
	// @Published var money: Int = 0
	@Published var money: Int = UserDefaults.standard.integer(forKey: "money")

    func addMoney(amount: Int) {
        money += amount
		allTimeMoney += amount
		UserDefaults.standard.set(money, forKey: "money")
		UserDefaults.standard.set(allTimeMoney, forKey: "allTimeMoney")
    }

	func resetMoney() {
		money = 0
		allTimeMoney = 0
		UserDefaults.standard.set(money, forKey: "money")
		UserDefaults.standard.set(allTimeMoney, forKey: "allTimeMoney")
	}

	func removeMoney(amount: Int) {
		if money >= amount {
			money -= amount
			UserDefaults.standard.set(money, forKey: "money")
		}
		else {
			print("Not enough money")
		}
	}
}