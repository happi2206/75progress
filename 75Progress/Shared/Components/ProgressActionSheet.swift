//
//  ProgressActionSheet.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI
import PhotosUI

struct ProgressActionSheet: View {
    let progressItem: ProgressItem
    @Binding var isPresented: Bool
    let onPhoto: (ProgressItem, UIImage) -> Void
    let onNote: (ProgressItem, String) -> Void
    @State private var showingCamera = false
    @State private var showingPhotoPicker = false
    @State private var showingNoteEditor = false
    @State private var selectedImage: UIImage?
    @State private var noteText = ""
    @State private var showingSuccessAlert = false
    @State private var successMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with options
                VStack(spacing: 20) {
                    // Progress Item Info
                    VStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(progressItem.color.opacity(0.1))
                                .frame(height: 80)
                            
                            Image(systemName: progressItem.iconName)
                                .font(.system(size: 32, weight: .medium))
                                .foregroundColor(progressItem.color)
                        }
                        
                        Text(progressItem.title)
                            .font(.system(size: 18, weight: .semibold, design: .default))
                            .foregroundColor(.primary)
                    }
                    .padding(.top, 20)
                    
                    // Action Buttons
                    VStack(spacing: 16) {
                        // Camera Button (Default action)
                        Button(action: {
                            showingCamera = true
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.white)
                                
                                Text("Take Photo")
                                    .font(.system(size: 16, weight: .semibold, design: .default))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(progressItem.color)
                            )
                        }
                        
                        // Import Photo Button
                        Button(action: {
                            showingPhotoPicker = true
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "photo.fill")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.primary)
                                
                                Text("Import Photo")
                                    .font(.system(size: 16, weight: .semibold, design: .default))
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(.gray.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
                        
                        // Create Note Button
                        Button(action: {
                            showingNoteEditor = true
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "note.text")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.primary)
                                
                                Text("Create Note")
                                    .font(.system(size: 16, weight: .semibold, design: .default))
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(.gray.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
            .navigationTitle("Add Progress")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(.blue)
                }
            }
        }
        .sheet(isPresented: $showingCamera) {
            CameraView(selectedImage: $selectedImage, onImageCaptured: { image in
                savePhotoEntry(image: image)
            })
        }
        .sheet(isPresented: $showingPhotoPicker) {
            PhotoPicker(selectedImage: $selectedImage, onImageSelected: { image in
                saveImportedPhotoEntry(image: image)
            })
        }
        .sheet(isPresented: $showingNoteEditor) {
            NoteEditorView(noteText: $noteText, progressItem: progressItem, onNoteSaved: { item, note in
                saveNoteEntry(note: note)
            })
        }
        .alert("Success", isPresented: $showingSuccessAlert) {
            Button("OK") {
                if successMessage.contains("Note") || successMessage.contains("Photo") {
                    isPresented = false
                }
            }
        } message: {
            Text(successMessage)
        }
    }
    
    private func savePhotoEntry(image: UIImage) {
        onPhoto(progressItem, image)
        successMessage = "Photo saved successfully!"
        showingSuccessAlert = true
    }
    
    private func saveImportedPhotoEntry(image: UIImage) {
        onPhoto(progressItem, image)
        successMessage = "Photo imported successfully!"
        showingSuccessAlert = true
    }
    
    private func saveNoteEntry(note: String) {
        onNote(progressItem, note)
        successMessage = "Note saved successfully!"
        showingSuccessAlert = true
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    let onImageCaptured: (UIImage) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
                parent.onImageCaptured(image)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    let onImageSelected: (UIImage) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        if let image = image as? UIImage {
                            self.parent.selectedImage = image
                            self.parent.onImageSelected(image)
                        }
                    }
                }
            }
        }
    }
}

struct NoteEditorView: View {
    @Binding var noteText: String
    let progressItem: ProgressItem
    let onNoteSaved: (ProgressItem, String) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Progress Item Info
                VStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(progressItem.color.opacity(0.1))
                            .frame(height: 80)
                        
                        Image(systemName: progressItem.iconName)
                            .font(.system(size: 32, weight: .medium))
                            .foregroundColor(progressItem.color)
                    }
                    
                    Text(progressItem.title)
                        .font(.system(size: 18, weight: .semibold, design: .default))
                        .foregroundColor(.primary)
                }
                .padding(.top, 20)
                
                // Note Editor
                VStack(alignment: .leading, spacing: 12) {
                    Text("Add Note")
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .foregroundColor(.primary)
                    
                    TextField("Write your note here...", text: $noteText, axis: .vertical)
                        .font(.system(size: 16, weight: .medium, design: .default))
                        .foregroundColor(.primary)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                        )
                        .lineLimit(5...10)
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .navigationTitle("Create Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.blue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if !noteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            onNoteSaved(progressItem, noteText)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .foregroundColor(.blue)
                    .fontWeight(.semibold)
                    .disabled(noteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

#Preview {
            ProgressActionSheet(
                progressItem: ProgressItem(
                    title: "Workout",
                    iconName: "dumbbell.fill",
                    color: .orange
                ),
                isPresented: .constant(true),
                onPhoto: { _, _ in },
                onNote: { _, _ in }
            )
}
