//
//  CoreDataHelper.swift
//  Progress
//
//  Created by Robert Keller on 7/23/18.
//  Copyright © 2018 RKIV. All rights reserved.
//


import UIKit
import CoreData

struct CoreDataHelper {
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        return context
    }()
    
    static func newTimeBlock() -> TimeBlock {
        let TimeBlock = NSEntityDescription.insertNewObject(forEntityName: "TimeBlock", into: context) as! TimeBlock
        return TimeBlock
    }
    
    static func saveTimeBlock() {
        do {
            try context.save()
        } catch let error {
            print ("Could not save \(error.localizedDescription)")
        }
    }
    
    static func delete(TimeBlock: TimeBlock) {
        context.delete(TimeBlock)
        saveTimeBlock()
    }
    
    static func retrieveTimeBlocks() -> [TimeBlock] {
        do {
            let fetchRequest = NSFetchRequest<TimeBlock>(entityName: "TimeBlock")
            let results = try context.fetch(fetchRequest)
            
            return results
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")
            
            return []
        }
    }
    
}
