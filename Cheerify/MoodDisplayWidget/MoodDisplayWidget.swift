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
    
    // Placeholder entry for when data is not yet available
    func placeholder(in context: Context) -> MoodEntry {
        MoodEntry(date: Date(), moodName: "Happy", imageName: "happyOctopus", note: "Feeling good!", recordedDate: Date())
    }

    // Snapshot entry for preview
    func getSnapshot(in context: Context, completion: @escaping (MoodEntry) -> Void) {
        let entry = MoodEntry(date: Date(), moodName: "Happy", imageName: "happyOctopus", note: "Snapshot: Feeling good!", recordedDate: Date())
        completion(entry)
    }

    // Timeline generation
    func getTimeline(in context: Context, completion: @escaping (Timeline<MoodEntry>) -> Void) {
        var entries: [MoodEntry] = []
        
        // Fetch the latest mood from Core Data
        if let latestMood = PersistenceController.shared.fetchLatestMood() {
            let moodName = latestMood.mood ?? "Mood" // Set mood name
            let moodImage = latestMood.imageName ?? "happyOctopus" // Default image if none found
            let moodNote = latestMood.note ?? "No recent mood tracked"
            let moodDate = latestMood.date ?? Date()
            
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
        
        // Refresh every hour
        let timeline = Timeline(entries: entries, policy: .after(Date().addingTimeInterval(3600)))
        completion(timeline)
    }
}

// MARK: - Mood Entry Structure
// Defines each entry in the widget timeline
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
        VStack {
            Text("Mood:")
                .font(.headline)
            Text(entry.moodName) // Display the mood name
                .font(.title2)
                .bold()
                .padding(.bottom, 4)
            Image(entry.imageName) // Display the image corresponding to the mood
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .padding(.bottom, 8)
            Text(entry.note)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Text("Recorded on:")
            Text(entry.recordedDate, style: .date)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
    }
}

// MARK: - Mood Widget Configuration
struct MoodDisplayWidget: Widget {
    let kind: String = "MoodDisplayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                MoodDisplayWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget) // iOS 17+ container background
            } else {
                MoodDisplayWidgetEntryView(entry: entry)
                    .padding()
                    .background(Color(UIColor.systemBackground)) // Fallback background for iOS < 17
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
    MoodEntry(date: .now, moodName: "Happy", imageName: "happyImage", note: "Feeling happy!", recordedDate: .now)
    MoodEntry(date: .now.addingTimeInterval(3600), moodName: "Sad", imageName: "sadImage", note: "Feeling a bit down.", recordedDate: .now.addingTimeInterval(-86400))
}
