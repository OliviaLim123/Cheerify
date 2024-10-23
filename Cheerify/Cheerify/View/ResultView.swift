//import SwiftUI
//
//struct ResultView: View {
//    
//    @State private var userInput: Image? = nil
//    @State private var moodImage: Image? = nil // Add a state variable to hold the mood image
//    
//    var body: some View {
//        ZStack {
//            //  BGM
//            AppColors.gradientBGM_bottomShadow
//                .ignoresSafeArea(.all)
//            
//            //  TITLE
//            VStack {
//                Text("Your mood today")
//                    .font(.title)
//                    .bold()
//                    .foregroundColor(.black)
//                    .padding()
//                
//                // Display the mood image
//                if let moodImage = moodImage {
//                    moodImage
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 150, height: 150)
//                        .padding()
//                } else {
//                    Text("No mood detected")
//                        .font(.headline)
//                        .foregroundColor(.gray)
//                        .padding()
//                }
//                
//                Button("Analyze Mood") {
//                    analyzeButtonMood()
//                }
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//            }
//        }
//    }
//    
//    private func analyzeButtonMood() {
//        guard let userImage = userInput else { return } // Make sure userInput is not nil
//        let model = try! MoodClassification()
//        
//        guard let pixelBuffer = userImage.toCVPixelBuffer() else { return } // Convert Image to CVPixelBuffer
//        let input = MoodClassificationInput(image: pixelBuffer)
//        
//        guard let output = try? model.prediction(input: input) else { return }
//        
//        // Update the moodImage based on the model's prediction
//        switch output.label {
//        case "angry":
//            moodImage = Image("MadRoboo")
//        case "happy":
//            moodImage = Image("happyOctopus")
//        case "sad":
//            moodImage = Image("sadApple")
//        case "neutral":
//            moodImage = Image("neutralHuman")
//        case "fear":
//            moodImage = Image("fearCow")
//        default:
//            moodImage = Image(systemName: "suit.heart.fill")
//        }
//    }
//}
//
//#Preview {
//    ResultView()
//}
//
//// Helper extension to convert Image to CVPixelBuffer
//extension Image {
//    func toCVPixelBuffer() -> CVPixelBuffer? {
//        // Conversion logic here
//        // This is where you'd convert the Image to a CVPixelBuffer
//        return nil
//    }
//}
