//
//  CoreDataService.swift
//  Mars_APIAPp
//
//  Created by Rania Arbash on 2022-03-31.
//

import Foundation
import CoreData

class CoreDataService {
    
    static var Shared = CoreDataService()
    
    func insertPhotoIntoStorage(id: Int, roverName: String, date: String, url: String){
            
        let newPhoto = MarsPhoto(context: persistentContainer.viewContext)
        newPhoto.id = Int32(id)
        newPhoto.date = date
        newPhoto.rover = roverName
        newPhoto.src = url
        saveContext()
    }
    
    func getAllImagesFromStorage() -> [MarsPhoto] {
        
        var result = [MarsPhoto]()
        let photoFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "MarsPhoto")
        do {
            result = try (persistentContainer.viewContext.fetch(photoFetch) as? [MarsPhoto])!
            
          print( result.count)
        }catch {
            print (error)
            
        }
        return result
        
    }
    
    
    lazy var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "photoDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
             
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
               
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    
}
