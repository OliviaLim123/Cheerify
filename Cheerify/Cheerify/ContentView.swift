//
//  ContentView.swift
//  Cheerify
//
//  Created by Olivia Gita Amanda Lim on 16/10/2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = MoodViewModel()
    @State private var isShowingImagePicker = false

    var body: some View {
        VStack {
            // if there is a selected image, display it
            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }

            Text(viewModel.resultText)
                .padding()

            Button("Pick an Image") {
                isShowingImagePicker = true
            }
        }
        .sheet(isPresented: $isShowingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$viewModel.selectedImage)
        }
    }

    func loadImage() {
        viewModel.classify()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
