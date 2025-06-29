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
}

class ShopManager: ObservableObject {
    static let shared = ShopManager()
    @ObservedObject private var gameManager = GameManager.shared
    @Published var purchasedItems: [ShopItem] = []
    @Published var items: [ShopItem] = [
        ShopItem(id: 1, name: "Item 1", price: 10, description: "Item 1 description"),
        ShopItem(id: 2, name: "Item 2", price: 20, description: "Item 2 description"),
        ShopItem(id: 3, name: "Item 3", price: 30, description: "Item 3 description")
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
    }
}


struct ShopView: View {
    @ObservedObject private var gameManager = GameManager.shared
    @ObservedObject private var shopManager = ShopManager.shared
    var body: some View {
        Text("Shop")
        List {
            ForEach(shopManager.items) { item in
                Button(item.name) {
                    shopManager.buyItem(item: item)
                }
                .disabled(gameManager.money < item.price)
            }
        }
    }
}

#Preview {
    ShopView()
}
