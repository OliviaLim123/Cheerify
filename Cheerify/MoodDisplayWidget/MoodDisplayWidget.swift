//  MoodDisplayWidget.swift
//  MoodDisplayWidget
//
//  Created by Hang Vu on 27/10/2024.
//

import WidgetKit
import SwiftUI
import CoreData

// MARK: - Timeline Provider
// This provider generates the timeline for the widget, pulling the latest mood data with image from Core Data.
struct Provider: TimelineProvider {
    
    // MARK: - Placeholder Entry
    // Placeholder entry for when data is not yet available
    func placeholder(in context: Context) -> MoodEntry {
        MoodEntry(date: Date(), moodName: "Happy", imageName: "happyOctopus", note: "Feeling good!", recordedDate: Date())
    }
    
    // MARK: - Snapshot Entry
    // Snapshot entry for preview
    func getSnapshot(in context: Context, completion: @escaping (MoodEntry) -> Void) {
        let entry = MoodEntry(date: Date(), moodName: "Happy", imageName: "happyOctopus", note: "Snapshot: Feeling good!", recordedDate: Date())
        completion(entry)
    }
    
    // MARK: - Timeline Generation
    // Timeline generation to fetch the latest mood data from Core Data
    func getTimeline(in context: Context, completion: @escaping (Timeline<MoodEntry>) -> Void) {
        var entries: [MoodEntry] = []
        
        // Fetch the latest mood from Core Data
        if let latestMood = PersistenceController.shared.fetchLatestMood() {
            let moodName = latestMood.mood ?? "Mood" // Set mood name
            let moodImage = latestMood.imageName ?? "happyOctopus" // Default image if none found
            let moodNote = latestMood.note ?? "No recent mood tracked"
            let moodDate = latestMood.date ?? Date()
            
            // Create an entry with fetched mood data
            let entry = MoodEntry(
                date: Date(),
                moodName: moodName, // Add mood name here
                imageName: moodImage,
                note: moodNote,
                recordedDate: moodDate
            )
            entries.append(entry)
        } else {
            // Default entry if no data is available
            let defaultEntry = MoodEntry(date: Date(), moodName: "Mood", imageName: "happyOctopus", note: "No mood data", recordedDate: Date())
            entries.append(defaultEntry)
        }
        
        // Refresh every hour to keep the data updated
        let timeline = Timeline(entries: entries, policy: .after(Date().addingTimeInterval(3600)))
        completion(timeline)
    }
}

// MARK: - Mood Entry Structure
// Defines each entry in the widget timeline with mood details
struct MoodEntry: TimelineEntry {
    let date: Date
    let moodName: String // New property for the mood name
    let imageName: String
    let note: String
    let recordedDate: Date
}

// MARK: - Mood Widget Entry View
// Defines the appearance of each widget entry
struct MoodDisplayWidgetEntryView: View {
    var entry: MoodEntry

    var body: some View {
        ZStack {
            // MARK: - Background Gradient with Container Shape
            // Container shape with custom gradient shadow
            ContainerRelativeShape()
                .inset(by: -17)
                .fill(AppColors.gradientBGM_topShadow)
                .shadow(radius: 8, x: 0, y: 4)
            
            // MARK: - Main Content Layout (Image, Mood, Note, Date)
            HStack {
                
                VStack {
                    // MARK: - Display Mood Image
                    // Displays the mood image or a placeholder icon
                        Image(entry.imageName)
                            .resizable()
                            .frame(width: 120, height: 120)
                    
                    // MARK: - Mood Name with Background
                    // Shows the mood name with a bold style and black background
                    Text(entry.moodName)
                        .font(.headline)
                        .bold()
                        .padding(.horizontal, 10)
                        .background(Color.black)
                        .foregroundColor(.brown)
                        .cornerRadius(10)
                        .offset(y: -12)
                }
                                
                VStack(alignment: .leading, spacing: 6) {
                    // MARK: - Mood Note
                    // Displays the mood note text with limited lines for a cleaner layout
                    Text(entry.note)
                        .font(.caption)
                        .bold()
                        .fontDesign(.rounded)
                        .foregroundColor(.brown)
                        .lineLimit(9)
                    
                    // MARK: - Heart Icon and Date
                    // Displays a heart icon next to the mood's recorded date for extra charm
                    HStack(spacing: 4) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                        Text(entry.recordedDate, style: .date)
                            .font(.caption)
                            .foregroundColor(.brown)
                    }
                    .padding(.bottom, 20)
                }
                .padding(.leading, 4)
                
                Spacer()
            }
            .padding()
        }
    }
}

// MARK: - Mood Widget Configuration
// Configures the widget's main properties and appearance on different iOS versions
struct MoodDisplayWidget: Widget {
    let kind: String = "MoodDisplayWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                // MARK: - iOS 17+ Background Configuration
                // Uses iOS 17 container background feature if available
                MoodDisplayWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                // MARK: - Background Fallback for iOS < 17
                // Fallback to system background for older iOS versions
                MoodDisplayWidgetEntryView(entry: entry)
                    .padding()
                    .background(Color(UIColor.systemBackground))
            }
        }
        .configurationDisplayName("Mood Tracker")
        .description("Displays your most recent mood record.")
    }
}

// MARK: - Widget Preview
#Preview(as: .systemSmall) {
    MoodDisplayWidget()
} timeline: {
    // Preview entries for different moods
    MoodEntry(date: .now, moodName: "Happy", imageName: "happyImage", note: "Feeling happy!", recordedDate: .now)
    MoodEntry(date: .now.addingTimeInterval(3600), moodName: "Sad", imageName: "sadImage", note: "Feeling a bit down.", recordedDate: .now.addingTimeInterval(-86400))
}
