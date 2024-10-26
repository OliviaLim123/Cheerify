//
//  Persistence.swift
//  Cheerify
//
//  Created by Olivia Gita Amanda Lim on 26/10/2024.
//

import CoreData

class PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "MoodCoreData")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
    }
    
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
        } catch {
            print("Failed to save mood: \(error)")
        }
    }
    
    func fetchMoods() -> [MoodRecord] {
        let request: NSFetchRequest<MoodRecord> = MoodRecord.fetchRequest()
        let context = container.viewContext
        
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch moods: \(error)")
            return []
        }
    }
    
    func fetchLatestMood() -> MoodRecord? {
        let request: NSFetchRequest<MoodRecord> = MoodRecord.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \MoodRecord.date, ascending: false)]
        request.fetchLimit = 1
        
        let context = container.viewContext
        do {
            return try context.fetch(request).first
        } catch {
            print("Failed to fetch the latest mood: \(error)")
            return nil
        }
    }
    
    func fetchMood(for date: Date) -> MoodRecord? {
        let request: NSFetchRequest<MoodRecord> = MoodRecord.fetchRequest()
        
        // Set up date bounds for the query (start and end of the selected day)
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date) // midnight of the selected day
        var components = DateComponents()
        components.day = 1
        let endOfDay = calendar.date(byAdding: components, to: startOfDay) // end of the day
        
        // Predicate to fetch records for the selected date
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay! as NSDate)
        
        // Sort records by date in descending order (most recent first)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \MoodRecord.date, ascending: false)]
        
        // Limit the fetch to one record (the most recent one)
        request.fetchLimit = 1
        
        let context = container.viewContext
        do {
            return try context.fetch(request).first // Return the first (and only) mood record for the day
        } catch {
            print("Failed to fetch mood for date \(date): \(error)")
            return nil
        }
    }

}
