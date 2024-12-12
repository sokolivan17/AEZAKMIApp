//
//  CoreDataManager.swift
//  AEZAKMIApp
//
//  Created by Ваня Сокол on 11.12.2024.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AEZAKMIApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    private init() { }

    public func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError.localizedDescription), \(nsError.userInfo)")
            }
        }
    }
    
    public func createItem(with model: CountryModel, completion: @escaping (String) -> Void) {
        
        if getAllItems().isEmpty {
            saveNewItem(with: model)
        } else if !getAllItems().contains(where: { $0.officialName == model.officialName }) {
            saveNewItem(with: model)
        } else {
            completion(NSLocalizedString("Already in the favorites", comment: ""))
        }

        do {
            try context.save()
            completion(NSLocalizedString("Saved successfully", comment: ""))
        } catch {
            print("Create error", error)
            completion(NSLocalizedString("Could not save", comment: ""))
        }
    }
    
    private func saveNewItem(with model: CountryModel) {
        let newItem = DBCountryModel(context: context)
        newItem.area = model.area
        newItem.capital = model.capital
        newItem.continents = model.continents
        newItem.currencies = model.currencies
        newItem.flag = model.flag
        newItem.flagsUrlString = model.flagsUrlString
        newItem.languages = model.languages
        newItem.latitude = model.latitude
        newItem.longitude = model.longitude
        newItem.officialName = model.officialName
        newItem.population = Int64(model.population)
        newItem.timezones = model.timezones
    }
    
    public func getAllItems() -> [DBCountryModel] {
        do {
            return (try? context.fetch(DBCountryModel.fetchRequest()) as? [DBCountryModel]) ?? []
        }
    }
    
    public func deleteItem(at index: Int) {
        let items = getAllItems()
        context.delete(items[index])

        do {
            try context.save()
        } catch {
            print("Delete item error", error)
        }
    }
}
