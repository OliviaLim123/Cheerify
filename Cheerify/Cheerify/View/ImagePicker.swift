//
//  ImagePicker.swift
//  Cheerify
//
//  Created by Hang Vu on 23/10/2024.
//

import Foundation
import SwiftUI

// Define a struct that will represent the ImagePicker
struct ImagePicker: UIViewControllerRepresentable {
    // Declare an environment variable to manage the presentation mode
    @Environment(\.presentationMode) var presentationMode
    // Declare a binding variable to store the selected image
    @Binding var image: UIImage?

    // Define a Coordinator class to manage image picking
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        // Declare a parent variable to reference the ImagePicker
        let parent: ImagePicker

        // Initialize the Coordinator with a reference to its parent
        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        // Define a function to handle the image picking process
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // Check if an original image was selected, and store it in the parent's image property
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }

            // Dismiss the image picker
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    // Define a function to create a Coordinator
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // Define a function to create a UIImagePickerController
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    // Define a function to update the UIImagePickerController
    // (no updates are made in this case)
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
}


