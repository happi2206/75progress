//
//  SavedCelebration.swift
//  75Progress
//
//

import SwiftUI

struct SavedCelebration: View {
    @ObservedObject var viewModel: HomeViewModel
    var onShare: () -> Void
    @Environment(\.dismiss) private var dismiss

    private var daysLogged: Int {
        max(viewModel.dayNumber, viewModel.currentStreak)
    }

    private var daysLeft: Int {
        max(0, 75 - daysLogged)
    }
    
    private var streakText: String {
        let suffix = viewModel.currentStreak == 1 ? "day" : "days"
        return "\(viewModel.currentStreak) \(suffix)"
    }

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "party.popper.fill")
                .font(.system(size: 44))
                .symbolRenderingMode(.multicolor)

            Text("Woohoo!")
                .font(.title2)
                .bold()

            Text("🔥 \(streakText) streak — keep going!")
                .font(.headline)
                .multilineTextAlignment(.center)

            Text("You have \(daysLeft) day\(daysLeft == 1 ? "" : "s") left to complete the challenge.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            HStack(spacing: 12) {
                Button("Continue logging") {
                    dismiss()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .foregroundStyle(Color.primary)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                Button {
                    dismiss()
                    onShare()
                } label: {
                    Label("Share", systemImage: "square.and.arrow.up")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .background(Color.accentColor)
                .foregroundStyle(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            .padding(.top, 4)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .presentationDetents([.fraction(0.35), .medium])
    }
}

#Preview {
    SavedCelebration(viewModel: HomeViewModel(), onShare: {})
}
