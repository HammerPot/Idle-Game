//
//  Shop.swift
//  Idle Game
//
//  Created by Potter on 6/25/25.
//

import SwiftUI
import Combine


struct ShopItem: Identifiable, Codable {
    let id: Int
    let name: String
    let price: Int
    let description: String
    let requirement: Int?
}

class ShopManager: ObservableObject {
    static let shared = ShopManager()
    @ObservedObject private var gameManager = GameManager.shared
    @Published var purchasedItems: [ShopItem] = []
    @Published var items: [ShopItem] = [
        ShopItem(id: 1, name: "Tap Power-Up", price: 10, description: "Make taps worth 2 money", requirement: nil),
        ShopItem(id: 2, name: "Tap Power-Up 2", price: 50, description: "Make taps worth 5 money", requirement: 1),
        ShopItem(id: 3, name: "Tap Power-Up 3", price: 150, description: "Make taps worth 10 money", requirement: 2)
    ]

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


    init() {
        if let data = UserDefaults.standard.data(forKey: "purchasedItems"),
           let decoded = try? JSONDecoder().decode([ShopItem].self, from: data) {
            purchasedItems = decoded
        }
        removePurchasedItem()
    }

    func resetPurchasedItems() {
        purchasedItems = []
        UserDefaults.standard.set(purchasedItems, forKey: "purchasedItems")
        gameManager.modifyTapStrength(amount: 1, operation: "set")
    }
}


struct ShopView: View {
    @ObservedObject private var gameManager = GameManager.shared
    @ObservedObject private var shopManager = ShopManager.shared
    var body: some View {
        Text("Shop")
        List {
            Section(header: Text("Items")) {
                
                if shopManager.items.isEmpty {
                    Text("No items available to buy")
                } else {
                    ForEach(shopManager.items) { item in
                        let isAllowed = item.requirement == nil || 
                            shopManager.purchasedItems.contains { $0.id == item.requirement }
                        if isAllowed {
                            Button(action: {
                                shopManager.buyItem(item: item)
                            }) {
                                HStack {
                                    VStack {
                                        Text(item.name)
                                        // .foregroundColor(.primary)
                                        Text(item.description)
                                        // .foregroundColor(.secondary)
                                        .font(.caption)
                                    }
                                    Spacer()
                                    Text("\(item.price)")
                                }
                            }
                            .disabled(gameManager.money < item.price)
                            // .listRowBackground(Color.clear)
                        }
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
