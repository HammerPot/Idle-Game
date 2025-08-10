//
//  Shop.swift
//  Idle Game
//
//  Created by Potter on 6/25/25.
//

import SwiftUI
import Combine
import SwiftyJSON


struct ShopItem: Identifiable, Codable {
    let id: Int
    let name: String
    let price: Int
    let description: String
    let requirement: Int?
    let netRequirement: Int?
    let type: String
    let value: Int
    let buttonName: String?
    let multiplier: Int?
}

class ShopManager: ObservableObject {
    static let shared = ShopManager()
    @ObservedObject private var gameManager = GameManager.shared
    @Published var purchasedItems: [ShopItem] = []
    // @Published var items: [ShopItem] = [
    //     ShopItem(id: 1, name: "Tap Power-Up", price: 10, description: "Make taps worth 2 money", requirement: nil, netRequirement: nil, type: "tap", value: 2),
    //     ShopItem(id: 2, name: "Tap Power-Up 2", price: 50, description: "Make taps worth 5 money", requirement: 1, netRequirement: nil, type: "tap", value: 5),
    //     ShopItem(id: 3, name: "Tap Power-Up 3", price: 150, description: "Make taps worth 10 money", requirement: 2, netRequirement: nil, type: "tap", value: 10),
    //     ShopItem(id: 4, name: "Auto Income", price: 750, description: "Make money automatically", requirement: nil, netRequirement: 1000, type: "auto", value: 1),
    // ]
    @Published var items: [ShopItem] = []


    init() {
        loadJSON()
        // print(items)
        if let data = UserDefaults.standard.data(forKey: "purchasedItems"),
           let decoded = try? JSONDecoder().decode([ShopItem].self, from: data) {
            purchasedItems = decoded
        }
        removePurchasedItem()
    }

    func loadJSON() {
        guard let url = Bundle.main.url(forResource: "shopItems", withExtension: "json") else {
            print("Could not find shopItems.json")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            items = try decoder.decode([ShopItem].self, from: data)
            print("Loaded \(items.count) items")
            // print(items)
        } catch {
            print("Error loading shop items: \(error)")
        }
    }


    func removePurchasedItem() {
        for item in purchasedItems {
            for item2 in items {
                if item.id == item2.id {
                    items.removeAll { $0.id == item2.id }
                }
            }
        }
    }
    

    func buyItem(item: ShopItem) {
        gameManager.removeMoney(amount: item.price)
        purchasedItems.append(item)
        if let encoded = try? JSONEncoder().encode(purchasedItems) {
            UserDefaults.standard.set(encoded, forKey: "purchasedItems")
        }
        gameManager.handlePurchasedItems(item: item)
        items.removeAll { $0.id == item.id }
    }



    func resetPurchasedItems() {
        purchasedItems = []
        gameManager.buttonsA = []
        gameManager.buttons = [TapButton(id: 0, name: "Tap Me", value: 1)]
        if let encoded = try? JSONEncoder().encode(purchasedItems) {
            UserDefaults.standard.set(encoded, forKey: "purchasedItems")
        }
        gameManager.persistButtons()
        gameManager.modifyTapStrength(amount: 1, operation: "set")
        gameManager.setAutoIncomeRate(0, "set")
    }
}


struct ShopView: View {
    @ObservedObject private var gameManager = GameManager.shared
    @ObservedObject private var shopManager = ShopManager.shared
    var body: some View {
        Text("Shop")
        List {
            Section(header: Text("Items")) {
                let allowedItems = shopManager.items.filter { item in
                    let reqMet = item.requirement.map { req in
                        shopManager.purchasedItems.contains { $0.id == req }
                    } ?? true
                    let netReqMet = item.netRequirement.map { req in
                        gameManager.allTimeMoney >= req
                    } ?? true
                    return reqMet && netReqMet
                }

                if allowedItems.isEmpty {
                    Text("There is nothing to buy right now. Try earning more money to unlock more items")
                } else {
                    ForEach(allowedItems) { item in
                        Button(action: {
                            shopManager.buyItem(item: item)
                        }) {
                            HStack {
                                VStack {
                                    Text(item.name)
                                    Text(item.description)
                                        .font(.caption)
                                }
                                Spacer()
                                Text("\(item.price)")
                            }
                        }
                        .disabled(gameManager.money < item.price)
                    }
                }
            }
            // Spacer()
            Section(header: Text("Purchased Items")) {
                if shopManager.purchasedItems.isEmpty {
                    Text("No items purchased")
                } else {
                    ForEach(shopManager.purchasedItems.sorted { $0.id < $1.id }) { item in
                        HStack {
                            VStack {
                                Text(item.name)
                                .foregroundColor(.primary)
                                Text(item.description)
                                .foregroundColor(.secondary)
                                .font(.caption)
                            }
                            
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ShopView()
}
