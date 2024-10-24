////
////  MoodCaptureView.swift
////  Cheerify
////
////  Created by Hang Vu on 24/10/2024.
////
//import SwiftUI
//
//struct MoodCaptureView: View {
//    @StateObject var viewModel = MoodViewModel()
//    @State private var showImagePicker = false
//    @State private var image: UIImage? = nil
//    @State private var showResultView = false  // Controls navigation to ResultView
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                if let image = image {
//                    Image(uiImage: image)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 300, height: 300)
//                        .cornerRadius(15)
//                        .padding()
//                    
//                    Button("Classify Mood") {
//                        viewModel.selectedImage = image
//                        viewModel.classify()
//                        showResultView = true // Triggers the navigation
//                    }
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                } else {
//                    Text("Capture your face to analyze mood")
//                        .font(.headline)
//                        .padding()
//                }
//
//                Spacer()
//
//                Button(action: {
//                    showImagePicker = true
//                }) {
//                    Text("Capture Mood")
//                        .font(.title)
//                        .padding()
//                        .background(Color.green)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//                .padding()
//
//                Spacer()
//
//                // Navigation to ResultView
//                NavigationLink(destination: ResultView(viewModel: viewModel), isActive: $showResultView) {
//                    EmptyView() // Empty view as the link is programmatically triggered
//                }
//            }
//            .sheet(isPresented: $showImagePicker) {
//                CustomImagePicker(selectedImage: $image) // Use CustomImagePicker here
//            }
//        }
//    }
//}
//
//#Preview {
//    NavigationStack {
//        MoodCaptureView()
//    }
//}
