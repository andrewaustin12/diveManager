//
//  InvoiceItem.swift
//  diveManager
//
//  Created by andrew austin on 5/28/24.
//

import Foundation
import SwiftData


@Model
final class InvoiceItem: Identifiable, Codable {
    var id: UUID
    var itemDescription: String
    var amount: Double
    var category: RevenueStream
    
    @Relationship(inverse: \Invoice.items)
    var invoice: Invoice?

    init(id: UUID = UUID(), itemDescription: String, amount: Double, category: RevenueStream) {
        self.id = id
        self.itemDescription = itemDescription
        self.amount = amount
        self.category = category
    }

    enum CodingKeys: String, CodingKey {
        case id, itemDescription, amount, category
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        itemDescription = try container.decode(String.self, forKey: .itemDescription)
        amount = try container.decode(Double.self, forKey: .amount)
        category = try container.decode(RevenueStream.self, forKey: .category)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(itemDescription, forKey: .itemDescription)
        try container.encode(amount, forKey: .amount)
        try container.encode(category, forKey: .category)
    }
}
