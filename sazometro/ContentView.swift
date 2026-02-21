//
//  ContentView.swift
//  sazometro
//
//  Created by Cristian Sánchez Pineda on 20/02/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var foods: [Food]
    @State private var showingAddFood = false
    
    var averageRating: Double {
            guard !foods.isEmpty else { return 0 }
            let total = foods.reduce(0) { $0 + $1.rating }
            return Double(total) / Double(foods.count)
        }
        
    var averageCost: Double {
            guard !foods.isEmpty else { return 0 }
            let total = foods.reduce(0) { $0 + $1.estimateCost }
            return total / Double(foods.count)
        }
   
    var body: some View{
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    HStack(spacing: 12) {
                        StatCard(
                            title: "Total", value: "\(foods.count)", icon: "fork.knife", color: .orange
                        )
                        StatCard(title: "AVG Rating", value: String(format: "%.1f ⭐",averageRating), icon: "star.fill", color: .yellow)
                        StatCard(title: "AVG Cost", value: String(format: "%.0f ",averageCost), icon: "dollarsign.circle", color: .yellow)
                    }.padding(.horizontal)
                    
                    if foods.isEmpty {
                        EmptyStateView()
                        
                    }else{
                        LazyVStack(spacing: 12)
                        {
                            ForEach(foods) { food in NavigationLink(destination: FoodDetailView(food: food)){
                                    FoodCardView(food: food)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }
                }.padding(.top)
            }
            .navigationTitle("Sazometro")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {showingAddFood = true}) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.orange)
                    }
                }
            }
            .sheet(isPresented: $showingAddFood){
                AddFoodView()
            }
        }
    }
}


struct StatCard: View {
    
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6){
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            Text(value)
                .font(.headline)
                .bold()
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Food.self, inMemory: true)
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "fork.knife.circle")
                .font(.system(size: 60))
                .foregroundColor(.orange.opacity(0.6))
            Text("No foods yet")
                .font(.title2)
                .bold()
            Text("Tap + to add your first dish")
                .foregroundColor(.secondary)
            
        }
        .padding(.top, 60)
    }
}


struct FoodCardView: View {
    let food: Food
    
    var body: some View {
        HStack(spacing: 12) {
            if let photoData = food.photoData, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }else{
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray5))
                    .frame(width: 70, height: 70)
                    .overlay(Image(systemName: "fork.knife")
                        .foregroundColor(.gray))
            }
            VStack(alignment: .leading, spacing: 4){
                Text(food.name)
                    .font(.headline)
                
                Text("\(food.ingredients.count) Ingredients")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack(spacing:2){
                    ForEach(1...5, id: \.self){
                        star in Image(systemName: star <= food.rating ? "star.fill" : "star")
                            .font(.caption)
                            .foregroundColor(.yellow)
                    }
                }
                
            }
        }
    }
}
