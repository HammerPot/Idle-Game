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

	@Published var tapStrength: Int = UserDefaults.standard.integer(forKey: "tapStrength")
	@Published var allTimeMoney: Int = UserDefaults.standard.integer(forKey: "allTimeMoney")
	// @Published var money: Int = 0
	@Published var money: Int = UserDefaults.standard.integer(forKey: "money")

	init() {
		if tapStrength == 0 {
			tapStrength = 1
			UserDefaults.standard.set(tapStrength, forKey: "tapStrength")
		}
	}

	func handlePurchasedItems(item: ShopItem) {
		if item.id == 1 {
			modifyTapStrength(amount: 2, operation: "set")
		}
		else if item.id == 2 {
			modifyTapStrength(amount: 5, operation: "set")
		}
		else if item.id == 3 {
			modifyTapStrength(amount: 10, operation: "set")
		}
	}

	func modifyTapStrength(amount: Int, operation: String) {
		if operation == "add" {
			tapStrength += amount
		} else if operation == "multiply" {
			tapStrength *= amount
		}
		else if operation == "set" {
			tapStrength = amount
		}
		UserDefaults.standard.set(tapStrength, forKey: "tapStrength")
	}

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