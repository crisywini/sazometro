//
//  Item.swift
//  sazometro
//
//  Created by Cristian Sánchez Pineda on 20/02/26.
//

import Foundation
import SwiftData

@Model
class Food {
    
    var id: UUID
    var name: String
    var ingredients: [String]
    var rating: Int
    var process: [String]
    var estimateHoursMaking: Double
    var estimateCost: Double
    var createdAt: Date
    var photoData: Data?
    
    init(
        name: String,
        ingredients: [String] = [],
        rating: Int = 0,
        process: [String] = [],
        estimateHoursMaking: Double = 0.0,
        estimateCost: Double = 0.0,
        photoData: Data? = nil
    ) {
        self.id = UUID()
        self.name = name
        self.ingredients = ingredients
        self.rating = rating
        self.process = process
        self.estimateHoursMaking = estimateHoursMaking
        self.estimateCost = estimateCost
        self.createdAt = Date()
        self.photoData = photoData
    }
}
