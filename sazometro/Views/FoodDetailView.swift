//
//  FoodDetailView.swift
//  sazometro
//
//  Created by Cristian Sánchez Pineda on 20/02/26.
//

import SwiftUI
import SwiftData

struct FoodDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let food: Food
    @State private var showingDeletealert = false
    
    var body: some View{
        
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                photoSection
                infoSection
                ingredientsSection
                processSection
            }
            .padding()
        }
        .navigationTitle(food.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(role: .destructive) {
                    showingDeletealert = true
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .alert("Delete \(food.name)", isPresented: $showingDeletealert) {
            Button("Delete", role: .destructive){
                deleteFood()
            }
            Button("Cancel", role: .cancel){}
        } message: {
            Text("This action cannot be undone.")
        }
    }
    
    private var photoSection: some View {
        Group {
            if let photoData = food.photoData,
               let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6))
                    .frame(height: 200)
                    .overlay(
                        Image(systemName: "fork.knife")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                    )
            }
        }
    }
    
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 4) {
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: star <= food.rating ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                        .font(.title2)
                }
                Text("(\(food.rating)/5)")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
            
            Divider()
            
            HStack(spacing: 0) {
                InfoBadge(
                    icon: "dollarsign.circle.fill",
                    label: "Cost",
                    value: String(format: "$%.0f", food.estimateCost),
                    color: .green
                )
                Spacer()
                InfoBadge(
                    icon: "clock.fill",
                    label: "Time",
                    value: food.estimateHoursMaking.formattedAsHours,
                    color: .blue
                )
                Spacer()
                InfoBadge(
                    icon:"calendar",
                    label: "Date",
                    value: food.createdAt.formatted(date: .abbreviated, time: .omitted),
                    color: .orange
                )
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 10){
            Label("Ingredients", systemImage: "list.bullet")
                .font(.title3)
                .bold()
            
            if food.ingredients.isEmpty {
                Text("No ingredients added")
                    .foregroundColor(.secondary)
                    .italic()
            } else {
                ForEach(food.ingredients, id: \.self){ ingredient in
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        
                        Text(ingredient)
                            .font(.body)
                    }
                    .padding(.vertical, 4)
                    Divider()
            
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    
    private var processSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Process", systemImage: "checklist")
                .font(.title3)
                .bold()
            
            if food.process.isEmpty {
                Text("No steps added")
                    .foregroundColor(.secondary)
                    .italic()
            } else {
                ForEach(Array(food.process.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 12) {
                        Text("\(index + 1)")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 28, height: 28)
                            .background(.orange)
                            .clipShape(Circle())
                        
                        Text(step)
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                    }
                    .padding(.vertical, 4)
                    Divider()
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func deleteFood() {
        modelContext.delete(food)
        dismiss()
    }
    
    
}


struct InfoBadge: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
            
            Text(value)
                .font(.subheadline)
                .bold()
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
