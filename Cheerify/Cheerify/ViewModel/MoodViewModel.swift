//
//  MoodViewModel.swift
//  Cheerify
//
//  Created by Hang Vu on 19/10/2024.
//
import SwiftUI
import CoreML
import Vision

// A ViewModel class that will handle image classification
class MoodViewModel: ObservableObject {
    // Published property to store the result text of the classification
    @Published var resultText = ""
    // Published property to store the selected image to be classified
    @Published var selectedImage: UIImage?
    // A variable to store the CoreML request for classification
    var classificationRequest: VNCoreMLRequest?
    
    // Holds the mood prediction
    @Published var predictedMood: String = ""

    // Initializer for the ViewModel
    init() {
        // Attempt to load and configure the ML model for use
        do {
            let configuration = MLModelConfiguration()
            if let model = try? MoodClassification(configuration: configuration) {
                let model = try VNCoreMLModel(for: model.model)
                // Create a classification request with the loaded model, and provide a completion handler
                self.classificationRequest = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                    self?.processClassifications(for: request, error: error)
                })
                // Set the image cropping and scaling option for the request
                self.classificationRequest?.imageCropAndScaleOption = .centerCrop
            }
        } catch {
            // Print an error message if the model fails to load
            print("Failed to load Vision ML model: \(error)")
        }
    }
    
    // Function to process the results of the classification request
//    func processClassifications(for request: VNRequest, error: Error?) {
//        DispatchQueue.main.async {
//            // Check if the request returned results
//            guard let results = request.results else {
//                self.resultText = "Unable to classify image.\n\(error!.localizedDescription)"
//                return
//            }
//            let classifications = results as! [VNClassificationObservation]
//
//            // Check if the classification process recognized anything
//            if classifications.isEmpty {
//                self.resultText = "Nothing recognized."
//            } else {
//                // Display the top 2 classifications
//                let topClassifications = classifications.prefix(2)
//                let descriptions = topClassifications.map { classification in
//                    // Format the classification confidence and identifier for display
//                    return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
//                }
//                self.resultText = "Classification:\n" + descriptions.joined(separator: "\n")
//            }
//        }
//    }
    
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                self.resultText = "Unable to classify image.\n\(error!.localizedDescription)"
                return
            }
            let classifications = results as! [VNClassificationObservation]

            if classifications.isEmpty {
                self.resultText = "Nothing recognized."
            } else {
                let topClassification = classifications.first!.identifier
                self.predictedMood = topClassification // Save the top prediction
                self.resultText = "Classification: \(topClassification)"
            }
        }
    }

    // Function to initiate the classification process
    func classify() {
        // Check if an image has been selected for classification
        guard let selectedImage = selectedImage else {
            return
        }

        // Set the result text to indicate that classification is in progress
        resultText = "Classifying..."

        // Convert the UIImage orientation to CGImage orientation
        let orientation = cgImageOrientation(from: selectedImage.imageOrientation)
        // Convert the UIImage to CIImage for the classification request
        guard let ciImage = CIImage(image: selectedImage) else {
            print("Unable to create \(CIImage.self) from \(selectedImage).")
            return
        }

        // Perform the classification request asynchronously
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest!])
            } catch {
                // Print an error message if the classification request fails
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    // Function to convert UIImage orientation to CGImage orientation
    func cgImageOrientation(from uiImageOrientation: UIImage.Orientation) -> CGImagePropertyOrientation {
        switch uiImageOrientation {
        case .up: return .up
        case .down: return .down
        case .left: return .left
        case .right: return .right
        case .upMirrored: return .upMirrored
        case .downMirrored: return .downMirrored
        case .leftMirrored: return .leftMirrored
        case .rightMirrored: return .rightMirrored
        @unknown default: fatalError("Unknown image orientation")
        }
    }
}
