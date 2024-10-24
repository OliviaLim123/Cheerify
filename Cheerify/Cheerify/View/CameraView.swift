import SwiftUI
import AVFoundation

import SwiftUI
import AVFoundation

struct CameraView: View {
    @StateObject private var cameraModel = CameraModel()
    @State private var showCapturedImage = false
    
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
                
                // Camera flip button at the top
                HStack {
                    Spacer()
                    
                    // Capture photo button
                    Button(action: {
                        cameraModel.capturePhoto()
                    }) {
                        Image("cameraButton") // Your custom camera button image
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
        .onAppear {
            cameraModel.checkCameraPermission()
        }
        .sheet(isPresented: $cameraModel.showCapturedImage) {
            if let image = cameraModel.capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Text("No Image Captured")
            }
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
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error.localizedDescription)")
            return
        }
        
        if let imageData = photo.fileDataRepresentation() {
            self.capturedImage = UIImage(data: imageData)
            self.showCapturedImage = true
            print("Photo captured successfully!")
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
