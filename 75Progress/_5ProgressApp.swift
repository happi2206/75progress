//
//  _5ProgressApp.swift
//  75Progress
//
//  Created by Happiness Adeboye on 2/8/2025.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct _5ProgressApp: App {
    let persistenceController = CoreDataManager.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var onboardingCoordinator = OnboardingCoordinator()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.context)
                .environmentObject(onboardingCoordinator)
                .fullScreenCover(isPresented: $onboardingCoordinator.showOnboarding) {
                    OnboardingContainerView(coordinator: onboardingCoordinator)
                }
        }
    }
}
