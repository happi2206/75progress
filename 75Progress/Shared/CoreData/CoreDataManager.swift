//
//  CoreDataManager.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import CoreData
import Foundation

class CoreDataManager: ObservableObject {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "75Progress")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data store failed to load: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    // MARK: - DayEntry Operations
    
    func saveDayEntry(_ dayEntry: DayEntry) {
        let entity = DayEntryEntity(context: context)
        entity.id = dayEntry.id
        entity.date = dayEntry.date
        entity.isComplete = dayEntry.isComplete
        entity.summary = dayEntry.summary
        // Convert UUID keys to String keys for Core Data compatibility
        let notesDict = Dictionary(uniqueKeysWithValues: dayEntry.notes.map { (key, value) in
            (key.uuidString, value)
        })
        entity.notes = notesDict as NSDictionary
        
        // Save photos
        for photo in dayEntry.photos {
            let photoEntity = PhotoEntity(context: context)
            photoEntity.id = photo.id
            photoEntity.url = photo.url
            photoEntity.label = photo.label
            photoEntity.dayEntry = entity
        }
        
        save()
    }
    
    func fetchDayEntry(for date: Date) -> DayEntry? {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let request: NSFetchRequest<DayEntryEntity> = DayEntryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        request.fetchLimit = 1
        
        do {
            let results = try context.fetch(request)
            guard let entity = results.first else { return nil }
            return mapToDayEntry(entity)
        } catch {
            print("Error fetching day entry: \(error)")
            return nil
        }
    }
    
    func fetchDayEntries(from startDate: Date, to endDate: Date) -> [DayEntry] {
        // Safety check to ensure Core Data is ready
        guard persistentContainer.persistentStoreCoordinator.persistentStores.count > 0 else {
            print("Core Data stores not ready")
            return []
        }
        
        let request: NSFetchRequest<DayEntryEntity> = DayEntryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        do {
            let entities = try context.fetch(request)
            return entities.map { mapToDayEntry($0) }
        } catch {
            print("Error fetching day entries: \(error)")
            return []
        }
    }
    
    func deleteDayEntry(for date: Date) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let request: NSFetchRequest<DayEntryEntity> = DayEntryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        
        do {
            let results = try context.fetch(request)
            for entity in results {
                context.delete(entity)
            }
            save()
        } catch {
            print("Error deleting day entry: \(error)")
        }
    }
    
    // MARK: - Mapping
    
    private func mapToDayEntry(_ entity: DayEntryEntity) -> DayEntry {
        let photos: [PhotoItem] = (entity.photos?.allObjects as? [PhotoEntity])?.compactMap { photoEntity in
            guard let id = photoEntity.id,
                  let url = photoEntity.url,
                  let label = photoEntity.label else { return nil }
            return PhotoItem(id: id, url: url, label: label)
        } ?? []
        
        // Convert String keys back to UUID keys
        let notesNSDict = entity.notes as? [String: String] ?? [:]
        let notesDict: [UUID: String] = Dictionary(uniqueKeysWithValues: notesNSDict.compactMap { (key, value) in
            guard let uuid = UUID(uuidString: key) else { return nil }
            return (uuid, value)
        })
        
        return DayEntry(
            id: entity.id ?? UUID(),
            date: entity.date ?? Date(),
            photos: photos,
            notes: notesDict,
            summary: entity.summary,
            isComplete: entity.isComplete
        )
    }
} 
