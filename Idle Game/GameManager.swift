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
	// @Published var money: Int = 0
	@Published var money: Int = UserDefaults.standard.integer(forKey: "money")

    func addMoney(amount: Int) {
        money += amount
		UserDefaults.standard.set(money, forKey: "money")
    }
}