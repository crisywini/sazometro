//
//  FoodDetailView.swift
//  sazometro
//
//  Created by Cristian Sánchez Pineda on 20/02/26.
//

import SwiftUI

struct FoodDetailView: View {
    let food: Food
    var body: some View{
        Text(food.name)
    }
}
