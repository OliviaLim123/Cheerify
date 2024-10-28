import SwiftUI
import AVFoundation

import SwiftUI
import AVFoundation

struct CameraView: View {
    @StateObject private var cameraModel = CameraModel()
    @State private var showCapturedImage = false
    @State private var isClassifying = false // this state to track classification
    @State private var showResultView = false // this state to navigate to ResultView
    
    // Add a reference to the MoodViewModel
    var viewModel: MoodViewModel
    
    var body: some View {
        ZStack {
            if cameraModel.isCameraAccessGranted {
                CameraPreview(camera: cameraModel)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("Camera access denied or not available.")
                    .font(.headline)
                    .foregroundColor(.red)
            }
            
            VStack {
                Spacer()
                
                if let capturedImage = cameraModel.capturedImage {
                    // Display the captured image
                    Image(uiImage: capturedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .cornerRadius(15)
                        .padding()
                    
                    // Display the "Classify Mood" button after photo is taken
                    if isClassifying {
                        // Show progress text while classifying
                        Text("Analyzing your mood... Please wait!")
                            .font(.headline)
                            .fontDesign(.rounded)
                            .foregroundStyle(AppColors.fierySunsetGradient)
                            .padding()
                        
                    } else {
                        Button("Classify Mood") {
                            // Set image for classification
                            viewModel.selectedImage = capturedImage
                            isClassifying = true // Set state to show progress
                            
                            // Start classification
                            viewModel.classify()
                            
                            // Simulate a delay (for classification processing)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                isClassifying = false // Stop showing progress
                                showResultView = true // Navigate to ResultView
                            }
                        }
                        .font(.headline)
                        .fontDesign(.rounded)
                        .padding()
                        .background(Color.black.opacity(0.5))
//                        .foregroundColor(.white.opacity(0.7))
                        .foregroundStyle(AppColors.fierySunsetGradient)
                        .cornerRadius(10)
                        
                        //  Wrapped line around button
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(AppColors.fierySunsetGradient, lineWidth: 3)
                        )
                        
                        //  Shadowing
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }
                } else {
                    // Show camera buttons when no image is captured
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            cameraModel.capturePhoto()
                        }) {
                            Image("cameraButton")
                                .resizable()
                                .frame(width: 110, height: 110)
                                .shadow(radius: 10)
                        }
                        .padding(.trailing, -90)
                        
                        Spacer()
                        
                        Button(action: {
                            cameraModel.flipCamera()
                        }) {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                                .shadow(radius: 10)
                        }
                        .padding(.trailing, 30)
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            cameraModel.checkCameraPermission()
            cameraModel.parentViewModel = viewModel // Assign MoodViewModel to CameraModel
        }
        // Navigation to ResultView when mood is classified
        .sheet(isPresented: $showResultView) {
            ResultView(viewModel: viewModel)
        }
    }
}

class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var isCameraAccessGranted = false
    @Published var session = AVCaptureSession()
    @Published var capturedImage: UIImage?
    @Published var showCapturedImage = false
    private var output = AVCapturePhotoOutput()
    private var currentCameraPosition: AVCaptureDevice.Position = .back
    
    // Add a reference to MoodViewModel
    var parentViewModel: MoodViewModel?
    
    
    func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isCameraAccessGranted = true
            setupCamera(position: currentCameraPosition)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    self.isCameraAccessGranted = granted
                    if granted {
                        self.setupCamera(position: self.currentCameraPosition)
                    }
                }
            }
        default:
            isCameraAccessGranted = false
        }
    }
    
    func setupCamera(position: AVCaptureDevice.Position) {
        session.beginConfiguration()
        
        // Remove existing inputs
        if let currentInput = session.inputs.first {
            session.removeInput(currentInput)
        }
        
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position) else {
            print("No camera found!")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            if session.canAddInput(input) {
                session.addInput(input)
            }
            
            if session.canAddOutput(output) {
                session.addOutput(output)
            }
            
            session.commitConfiguration()
            
            // Start the session on a background thread to avoid UI blocking
            DispatchQueue.global(qos: .userInitiated).async {
                self.session.startRunning()
            }
        } catch {
            print("Error setting up camera: \(error.localizedDescription)")
        }
    }
    
    // Function to flip between front and back cameras
    func flipCamera() {
        currentCameraPosition = currentCameraPosition == .back ? .front : .back
        setupCamera(position: currentCameraPosition)
    }
    
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }
    
    // Delegate method that processes the captured image
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error.localizedDescription)")
            return
        }
        
        if let imageData = photo.fileDataRepresentation() {
            self.capturedImage = UIImage(data: imageData)
            self.showCapturedImage = true
            print("Photo captured successfully!")
            
            // Pass the image to the MoodViewModel and classify it
            parentViewModel?.selectedImage = UIImage(data: imageData) // Assign image to the ViewModel
            parentViewModel?.classify() // Call the classify function
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    class VideoPreview: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }
        
        var previewLayer: AVCaptureVideoPreviewLayer {
            layer as! AVCaptureVideoPreviewLayer
        }
    }
    
    var camera: CameraModel
    
    func makeUIView(context: Context) -> VideoPreview {
        let view = VideoPreview()
        view.previewLayer.session = camera.session
        view.previewLayer.videoGravity = .resizeAspectFill
        return view
    }
    
    func updateUIView(_ uiView: VideoPreview, context: Context) {}
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        // Show a mock view when previewing in Xcode
        ZStack {
            Color.gray.edgesIgnoringSafeArea(.all)
            VStack {
                Text("Camera View Preview")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                Image(systemName: "camera.circle")
                    .font(.system(size: 70))
                    .foregroundColor(.white)
                    .shadow(radius: 10)
            }
        }
    }
}
