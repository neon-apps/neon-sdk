//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 8.04.2023.
//

import Foundation
import CoreData
import UIKit


public class CoreDataManager{


    public static func persistentContainer (entity : String) ->  NSPersistentContainer{
        let container = NSPersistentContainer(name: entity)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }
    
    public static func saveContext (entity : String) {
        let context = persistentContainer(entity: entity).viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    public static func saveData(entity : String, attributeDict : [String : Any]){
        
        let context = persistentContainer(entity: entity).viewContext
        let entity = NSEntityDescription.insertNewObject(forEntityName: entity, into: context)
        for attribute in attributeDict{
            print("\(attribute.value) - \(attribute.key)")
            entity.setValue(attribute.value, forKey: attribute.key)
        }
        do {
            try context.save()
            print("Data Saved - Entity : \(entity)")
        } catch {
            print("Can not save data")
        }
    }
    
    public static func deleteData(entity : String, keyAttribute: String, value : String) {
        let context = persistentContainer(entity: entity).viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.predicate = NSPredicate(format: "\(keyAttribute) = %@", value)
        do {
            let fetchedObjects = try context.fetch(fetchRequest) as! [NSManagedObject]
            if let objectToDelete = fetchedObjects.first {
                context.delete(objectToDelete)
                try context.save()
                print("Data Deleted - Entity : \(objectToDelete)")
            } else {
                print("Data not found with name: \(value)")
            }
        } catch {
            print("Can not delete data")
        }
    }
    
    
    public static func updateData(entity : String, keyAttribute: String, value : String, newAttributeDict : [String : Any]){
        
        let context = persistentContainer(entity: entity).viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.predicate = NSPredicate(format: "\(keyAttribute) = %@", value)
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for attribute in newAttributeDict{
                    print("\(attribute.value) - \(attribute.key)")
                    results![0].setValue(attribute.value, forKey: attribute.key)
                }
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        do {
            try context.save()
            print("Data Updated - Entity")
        } catch {
            print("Can not save data")
        }
        
        
    }
    
    public static func fetchDatas(entity : String, dataFetched : @escaping (_ data : NSManagedObject) -> ()){
        let context = persistentContainer(entity: entity).viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let datas = try context.fetch(fetchRequest)
            for data in datas as! [NSManagedObject] {
                dataFetched(data)
            }
        } catch {
          print("Error!")
        }
        
        
    }
    
    
}
