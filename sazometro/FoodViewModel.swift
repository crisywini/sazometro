//
//  FoodViewModel.swift
//  sazometro
//
//  Created by Cristian Sánchez Pineda on 20/02/26.
//

import Foundation

@Observable
class FoodViewModel {
    var foods: [Food] = []
    var showingAddFood = false
    
    
    var averageRating: Double {
        guard !foods.isEmpty else {return 0}
        let total = foods.reduce(0) {
            $0 + $1.rating
        }
        return Double(total) / Double(foods.count)
    }
    
    var totalFoods: Int {
        foods.count
    }
    
    var topRatedFood: Food? {
        foods.max(by: {$0.rating < $1.rating})
    }
    
    var averageCost: Double {
        guard !foods.isEmpty else {return 0}
        let total = foods.reduce(0){$0+$1.estimateCost}
        return total/Double(foods.count)
    }
    
    var averageTime: Double {
        guard !foods.isEmpty else {return 0}
        let total = foods.reduce(0) {$0 + $1.estimateHoursMaking}
        return total/Double(foods.count)
    }
    
    var mostExpensiveFood: Food? {
        foods.max(by: {$0.estimateCost < $1.estimateCost})
    }
}
