//
//  ToastCenter.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI
import Combine

class ToastCenter: ObservableObject {
    static let shared = ToastCenter()
    
    @Published var currentToast: ToastMessage?
    private var cancellables = Set<AnyCancellable>()
    
    private init() {}
    
    func show(_ message: String, type: ToastType = .info, duration: TimeInterval = 3.0) {
        let toast = ToastMessage(
            message: message,
            type: type,
            duration: duration
        )
        
        currentToast = toast
        
        // Auto-dismiss after duration
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            if self.currentToast?.id == toast.id {
                self.currentToast = nil
            }
        }
    }
    
    func showError(_ error: AppError) {
        show(error.userFriendlyMessage, type: .error)
    }
    
    func dismiss() {
        currentToast = nil
    }
}

struct ToastMessage: Identifiable {
    let id = UUID()
    let message: String
    let type: ToastType
    let duration: TimeInterval
    let timestamp = Date()
}

enum ToastType {
    case success
    case error
    case warning
    case info
    
    var color: Color {
        switch self {
        case .success:
            return .green
        case .error:
            return .red
        case .warning:
            return .orange
        case .info:
            return .blue
        }
    }
    
    var icon: String {
        switch self {
        case .success:
            return "checkmark.circle.fill"
        case .error:
            return "xmark.circle.fill"
        case .warning:
            return "exclamationmark.triangle.fill"
        case .info:
            return "info.circle.fill"
        }
    }
}

struct ToastView: View {
    let toast: ToastMessage
    let onDismiss: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: toast.type.icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(toast.type.color)
            
            Text(toast.message)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(toast.type.color.opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 20)
        .transition(.asymmetric(
            insertion: .move(edge: .top).combined(with: .opacity),
            removal: .move(edge: .top).combined(with: .opacity)
        ))
    }
}

struct ToastModifier: ViewModifier {
    @ObservedObject var toastCenter: ToastCenter
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if let toast = toastCenter.currentToast {
                VStack {
                    ToastView(toast: toast) {
                        toastCenter.dismiss()
                    }
                    Spacer()
                }
                .zIndex(1000)
            }
        }
    }
}

extension View {
    func toast(center: ToastCenter = ToastCenter.shared) -> some View {
        modifier(ToastModifier(toastCenter: center))
    }
}
