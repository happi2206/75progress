//
//  ContentView.swift
//  75Progress
//
//  Created by Happiness Adeboye on 2/8/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var onboardingCoordinator: OnboardingCoordinator
    
    var body: some View {
        TabBarView()
            .toast()
    }
}

#Preview {
    ContentView()
        .environmentObject(OnboardingCoordinator())
}
