//
//  Persistence.swift
//  Cheerify
//
//  Created by Olivia Gita Amanda Lim on 26/10/2024.
//

import CoreData
import WidgetKit

// MARK: - PersistenceController
// Handles the CoreData operations for both app and widget, sharing data via an App Group
class PersistenceController {
    
    // Singleton instance to use across the app
    static let shared = PersistenceController()
    
    // Container to manage the CoreData stack
    let container: NSPersistentContainer

    // MARK: - Initializer
    // Initializes the Core Data stack and loads the persistent store
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MoodCoreData")
        
        // Check if we are using an App Group path
        // Leonie's app group: group.au.edu.utss.Cheerify
        // Olivia's app group: group.au.edu.uts.Cheerify
        if !inMemory, let appGroupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.au.edu.utss.Cheerify") {
            // Set the Core Data store location to the shared App Group container
            let storeURL = appGroupURL.appendingPathComponent("MoodCoreData.sqlite")
            let description = NSPersistentStoreDescription(url: storeURL)
            container.persistentStoreDescriptions = [description]
        } else if inMemory {
            // Use an in-memory store if testing or for widget previews
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        // Load the persistent store
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    // MARK: - Widget-Specific Preview Context
    // Provides a read-only context for the widget to access CoreData in preview mode
    static var preview: NSManagedObjectContext = {
        let controller = PersistenceController(inMemory: true)
        return controller.container.viewContext
    }()
    
    // MARK: - Save Mood Function
    // Saves a mood record with mood description, note, image name, and date to CoreData
    func saveMood(mood: String, note: String, imageName: String, date: Date) {
        let context = container.viewContext
        let moodRecord = MoodRecord(context: context)
        moodRecord.id = UUID()
        moodRecord.mood = mood
        moodRecord.note = note
        moodRecord.imageName = imageName
        moodRecord.date = date
        
        do {
            try context.save()
            // Trigger widget reload to reflect new data
            WidgetCenter.shared.reloadTimelines(ofKind: "MoodDisplayWidget")
        } catch {
            print("Failed to save mood: \(error)")
        }
    }

    // MARK: - Fetch All Moods Function
    // Fetches all mood records from Core Data, sorted by date in descending order (newest first)
    func fetchMoods() -> [MoodRecord] {
        let request: NSFetchRequest<MoodRecord> = MoodRecord.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \MoodRecord.date, ascending: false)]

        let context = container.viewContext
        do {
            return try context.fetch(request)
        } catch {
            // Error handling
            print("Failed to fetch moods: \(error)")
            return []
        }
    }
    
    // MARK: - Fetch Latest Mood Function
    // Fetches the most recent mood record from Core Data
    func fetchLatestMood() -> MoodRecord? {
        let request: NSFetchRequest<MoodRecord> = MoodRecord.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \MoodRecord.date, ascending: false)]
        request.fetchLimit = 1
        
        let context = container.viewContext
        do {
            return try context.fetch(request).first
        } catch {
            // Error handling
            print("Failed to fetch the latest mood: \(error)")
            return nil
        }
    }
    
    // MARK: Fetch Mood for Specific Date
    // Fetches a mood record for specific date
    func fetchMood(for date: Date) -> MoodRecord? {
        let request: NSFetchRequest<MoodRecord> = MoodRecord.fetchRequest()
        
        // Set up date bounds for the query (start and end of the selected day)
        let calendar = Calendar.current
        // Midnight of the selected day
        let startOfDay = calendar.startOfDay(for: date)
        var components = DateComponents()
        components.day = 1
        // End of the day
        let endOfDay = calendar.date(byAdding: components, to: startOfDay)
        
        // Predicate to fetch records for the selected date
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay! as NSDate)
        
        // Sort records by date in descending order (most recent first)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \MoodRecord.date, ascending: false)]
        
        // Limit the fetch to one record (the most recent one)
        request.fetchLimit = 1
        
        let context = container.viewContext
        do {
            // Return the first (and only) mood record for the day
            return try context.fetch(request).first
        } catch {
            // Error handling
            print("Failed to fetch mood for date \(date): \(error)")
            return nil
        }
    }
    
    // MARK: - Delete Mood Function
    // Deletes a mood record from Core Data
    func deleteMood(_ mood: MoodRecord) {
        let context = container.viewContext
        // Mark the mood for deletion
        context.delete(mood)

        do {
            // Save changes to apply the deletion
            try context.save()
            print("Mood deleted successfully.")
            // Trigger widget reload to reflect new data
            WidgetCenter.shared.reloadTimelines(ofKind: "MoodDisplayWidget")
        } catch {
            // Error handling
            print("Failed to delete mood: \(error)")
        }
    }

}
