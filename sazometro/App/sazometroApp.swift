//
//  sazometroApp.swift
//  sazometro
//
//  Created by Cristian Sánchez Pineda on 20/02/26.
//

import SwiftUI
import SwiftData

@main
struct sazometroApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Food.self)
    }
}
