//
//  GameManager.swift
//  Idle Game
//
//  Created by Potter on 6/25/25.
//

import Foundation
import SwiftUI
import Combine
import SwiftUISnackbar

struct TapButton: Identifiable, Codable {
	var id: Int
	var name: String
	var value: Int
	var current: Int = 0
}

struct AutoButton: Identifiable, Codable {
	var id: Int
	var name: String
	var goal: Int
	var value: Int
	var current: Int = 0
	var multiplier: Int = 1
}

class GameManager: ObservableObject {
	static let shared = GameManager()

	@Published var tapStrength: Int = UserDefaults.standard.integer(forKey: "tapStrength")
	@Published var allTimeMoney: Int = UserDefaults.standard.integer(forKey: "allTimeMoney")
	// @Published var money: Int = 0
	@Published var money: Int = UserDefaults.standard.integer(forKey: "money")
	@Published var snackbar: Snackbar?
	@Published var buttons: [TapButton] = {
		if let data = UserDefaults.standard.data(forKey: "buttons"),
		   let decoded = try? JSONDecoder().decode([TapButton].self, from: data) {
			return decoded
		}
		return [TapButton(id: 0, name: "Tap Me", value: 1)]
	}()
	@Published var buttonsA: [AutoButton] = {
		if let data = UserDefaults.standard.data(forKey: "buttonsA"),
		   let decoded = try? JSONDecoder().decode([AutoButton].self, from: data) {
			return decoded
		}
		return []
	}()
	// NEW: Auto income properties
	@Published var autoIncomeRate: Int = UserDefaults.standard.integer(forKey: "autoIncomeRate")
	@Published var isShopOpen: Bool = UserDefaults.standard.bool(forKey: "isShopOpen")
	@Published var colorMode: Int = UserDefaults.standard.integer(forKey: "colorMode")
	private var autoTimer: Timer?
	private var backgroundTimestamp: Date?

	init() {
		if tapStrength == 0 {
			tapStrength = 1
			UserDefaults.standard.set(tapStrength, forKey: "tapStrength")
		}
		
		// // NEW: Setup auto income and lifecycle
		// if autoIncomeRate == 0 {
		// 	autoIncomeRate = 1 // Default: 1 money per second
		// 	UserDefaults.standard.set(autoIncomeRate, forKey: "autoIncomeRate")
		// }
		
		setupAppLifecycleNotifications()
		startAutoIncome() // Start generating money immediately
	}
	
	// NEW: App lifecycle handling
	private func setupAppLifecycleNotifications() {
		// App going to background
		NotificationCenter.default.addObserver(
			forName: UIApplication.willResignActiveNotification,
			object: nil,
			queue: .main
		) { _ in
			self.handleAppGoingToBackground()
		}
		
		// App returning to foreground
		NotificationCenter.default.addObserver(
			forName: UIApplication.didBecomeActiveNotification,
			object: nil,
			queue: .main
		) { _ in
			self.handleAppReturningToForeground()
		}
	}
	
	// NEW: Auto income timer
	func startAutoIncome() {
		print("Starting auto income")
		stopAutoIncome()
		guard autoIncomeRate >= 0 else { return }
		stopAutoIncome()
		
		autoTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
			self.addMoney(amount: self.autoIncomeRate)
		}
	}
	
	func stopAutoIncome() {
		autoTimer?.invalidate()
		autoTimer = nil
	}
	
	// NEW: Background handling
	private func handleAppGoingToBackground() {
		backgroundTimestamp = Date()
		UserDefaults.standard.set(backgroundTimestamp, forKey: "backgroundTime")
		stopAutoIncome() // Save battery
		print("App going to background - timer stopped")
	}
	
	private func handleAppReturningToForeground() {
		// Calculate offline earnings
		if let backgroundTime = backgroundTimestamp ?? UserDefaults.standard.object(forKey: "backgroundTime") as? Date {
			let timeAway = Date().timeIntervalSince(backgroundTime)
			let offlineCap = 2
			let cappedTimeAway = min(timeAway, TimeInterval(offlineCap * 60 * 60)) // 2 hours cap
			let offlineEarnings = Int(cappedTimeAway) * autoIncomeRate
			
			if offlineEarnings > 0 {
				addMoney(amount: offlineEarnings)
				print("Welcome back! You earned \(offlineEarnings) money while away")
				snackbar = Snackbar(title: "Welcome Back!", message: "You earned \(offlineEarnings) money while away")
				// TODO: Show a popup to the user about offline earnings

			}
		}
		
		// Restart auto income
		startAutoIncome()
	}
	
	// NEW: Modify auto income rate
	func setAutoIncomeRate(_ rate: Int, _ operation: String) {
		if operation == "add" {
			autoIncomeRate += rate
		} else if operation == "set" {
			autoIncomeRate = rate
		} else if operation == "multiply" {
			autoIncomeRate *= rate
		}
		UserDefaults.standard.set(autoIncomeRate, forKey: "autoIncomeRate")
		
		// Restart timer with new rate
		stopAutoIncome()
		startAutoIncome()
	}

	func persistButtons() {
		if let encoded = try? JSONEncoder().encode(buttons) {
			UserDefaults.standard.set(encoded, forKey: "buttons")
		}
		if let encodedA = try? JSONEncoder().encode(buttonsA) {
			UserDefaults.standard.set(encodedA, forKey: "buttonsA")
		}
	}

	func handlePurchasedItems(item: ShopItem) {
		if item.type == "tap" {
			modifyTapStrength(amount: item.value, operation: "set")
		}
		else if item.type == "auto" {
			setAutoIncomeRate(item.value, "set")
		}
		else if item.type == "both" {
			modifyTapStrength(amount: item.value, operation: "multiply")
			setAutoIncomeRate(item.value, "multiply")
		}
		else if item.type == "sacrifice" {
			modifyTapStrength(amount: -item.value, operation: "add")
			setAutoIncomeRate(item.value, "add")
		}
		else if item.type == "button" {
			buttons.append(TapButton(id: buttons.count, name: item.buttonName ?? "Button \(buttons.count + 1)", value: 2))
			persistButtons()
		}
		else if item.type == "buttonAuto" {
			buttonsA.append(AutoButton(id: buttonsA.count, name: item.buttonName ?? "Button \(buttons.count + 1)", goal: item.value, value: 1, multiplier: item.multiplier ?? 1))
			persistButtons()
		}
		else if item.type == "colorful" {
			setColorMode(value: item.value)
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
		isShopOpen = false
		UserDefaults.standard.set(money, forKey: "money")
		UserDefaults.standard.set(allTimeMoney, forKey: "allTimeMoney")
		UserDefaults.standard.set(isShopOpen, forKey: "isShopOpen")
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

	func openShop() {
		isShopOpen = true
		UserDefaults.standard.set(isShopOpen, forKey: "isShopOpen")
		print("Shop is open")
		snackbar = Snackbar(
			title: "Shop is open",
			message: "You can now buy items"

		)
	}

	func incrementAutoButton(button: Int, amount: Int? = 1) {
		print(buttonsA)
		buttonsA[button].current += 1
		if buttonsA[button].current >= buttonsA[button].goal {
			// addMoney(amount: buttonsA[button].value * buttonsA[button].multiplier)
			setAutoIncomeRate(buttonsA[button].value * buttonsA[button].multiplier, "add")
			buttonsA[button].current = 0
		}
		persistButtons()
	}

	func setColorMode(value: Int) {
		if value == 1 {
			colorMode = 1
			UserDefaults.standard.set(colorMode, forKey: "colorMode")
		}
		else if value == 2 {
			colorMode = 2
			UserDefaults.standard.set(colorMode, forKey: "colorMode")
		}
	}
}