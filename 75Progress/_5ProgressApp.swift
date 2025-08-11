//
//  _5ProgressApp.swift
//  75Progress
//
//  Created by Happiness Adeboye on 2/8/2025.
//

import SwiftUI

@main
struct _5ProgressApp: App {
    let persistenceController = CoreDataManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.context)
        }
    }
}
