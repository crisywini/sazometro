//
//  AddFoodView.swift
//  sazometro
//
//  Created by Cristian Sánchez Pineda on 20/02/26.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddFoodView: View{
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    
    @State private var name = ""
    @State private var rating = 3
    @State private var estimateCost = ""
    @State private var estimateHours = ""
    @State private var newIngredient = ""
    @State private var ingredients: [String] = []
    @State private var newStep = ""
    @State private var process: [String] = []
    
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var photoData: Data?
    
    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                photoSection
                basicInfoSection
                ingredientsSection
                processSection
            }
            .navigationTitle("New Dish")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveFood() }
                        .disabled(!isFormValid)
                        .bold()
                }
            }
            .onChange(of: selectedPhoto) { _, newValue in
                Task {
                    photoData = try? await newValue?.loadTransferable(type: Data.self)
                }
            }
        }
    }
    
    private var photoSection: some View {
        Section("Photo") {
            HStack {
                Spacer()
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    if let photoData, let uiImage = UIImage(data: photoData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "camera.fill")
                                .font(.largeTitle)
                                .foregroundColor(.orange)
                            Text("Add Photo")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(width: 120, height: 120)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                Spacer()
            }
            .padding(.vertical, 8)
        }
    }
    

    private var basicInfoSection: some View {
        Section("Basic Info") {
            TextField("Dish name", text: $name)
            
            HStack {
                Text("Rating")
                Spacer()
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: star <= rating ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                        .font(.title3)
                        .onTapGesture { rating = star }
                }
            }
            
            HStack {
                Image(systemName: "dollarsign.circle").foregroundColor(.green)
                TextField("Estimated cost", text: $estimateCost)
                    .keyboardType(.decimalPad)
            }
            
            HStack {
                Image(systemName: "clock").foregroundColor(.blue)
                TextField("Estimated hours", text: $estimateHours)
                    .keyboardType(.decimalPad)
            }
        }
    }

    private var ingredientsSection: some View {
        Section("Ingredients") {
            ForEach(ingredients, id: \.self) { ingredient in
                HStack {
                    Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                    Text(ingredient)
                }
            }
            .onDelete { ingredients.remove(atOffsets: $0) }
            
            HStack {
                TextField("Add ingredient", text: $newIngredient)
                Button(action: addIngredient) {
                    Image(systemName: "plus.circle.fill").foregroundColor(.orange)
                }
                .disabled(newIngredient.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
    }

    private var processSection: some View {
        Section("Process") {
            ForEach(Array(process.enumerated()), id: \.offset) { index, step in
                HStack(alignment: .top, spacing: 10) {
                    Text("\(index + 1).").bold().foregroundColor(.orange)
                    Text(step)
                }
            }
            .onDelete { process.remove(atOffsets: $0) }
            
            HStack {
                TextField("Add step", text: $newStep)
                Button(action: addStep) {
                    Image(systemName: "plus.circle.fill").foregroundColor(.orange)
                }
                .disabled(newStep.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
    }
    
    private func addIngredient() {
        let trimmed = newIngredient.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        ingredients.append(trimmed)
        newIngredient = ""
    }
    
    private func addStep() {
        let trimmed = newStep.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        process.append(trimmed)
        newStep = ""
    }
    
    
    private func saveFood() {
        let food = Food(
            name: name,
            ingredients: ingredients,
            rating: rating,
            process: process,
            estimateHoursMaking: Double(estimateHours) ?? 0.0,
            estimateCost: Double(estimateCost) ?? 0.0,
            photoData: photoData
        )
        modelContext.insert(food)
        dismiss()
    }

    
}
