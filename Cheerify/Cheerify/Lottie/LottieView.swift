//
//  LottieView.swift
//  Cheerify
//
//  Created by Olivia Gita Amanda Lim on 24/10/2024.
//

import SwiftUI
import Lottie

// MARK: - Lottie View
struct LottieView: UIViewRepresentable {
    
    // Propertoes of LottieView
    let name: String
    let loopMode: LottieLoopMode
    let animationSpeed: CGFloat
    let contentMode: UIView.ContentMode = .scaleAspectFit
    
    // MARK: - Make UI View Function
    // Construct the underlying 'UIView' with the Lottie animation
    func makeUIView(context: Context) -> some UIView {
        // Create the empty 'UIView'
        let view = UIView(frame: .zero)
        // Initialise a LottieAnimationView
        let animationView = LottieAnimationView()
        // Load the animation from the specified file name
        let animation = LottieAnimation.named(name)
        
        // Configure the animation, loopMode, speed of the Lottie
        animationView.animation = animation
        animationView.contentMode = contentMode
        animationView.loopMode = loopMode
        animationView.animationSpeed = animationSpeed
        
        // Start playing the animation
        animationView.play()
        
        // Disable autoresizing mask to use Auto Layout constraints
        animationView.translatesAutoresizingMaskIntoConstraints = false
        // Add the animation view to the subView
        view.addSubview(animationView)
        
        // Set the hight and width of the animation view
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        return view
    }
    
    // MARK: - Update UI View Function
    // The animation is static in this case, so it has an empty code
    func updateUIView(_ uiView: UIViewType, context: Context) { }
}
