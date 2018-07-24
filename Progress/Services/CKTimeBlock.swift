//
//  CloudKitService.swift
//  Progress
//
//  Created by Robert Keller on 7/24/18.
//  Copyright © 2018 RKIV. All rights reserved.
//

import CloudKit
import UIKit

struct CKTimeBlock{
    fileprivate static let recordType = "TimeBlock"
    fileprivate static let keys = (name : "name", startTime : "startTime", endTime : "endTime", isActive : "isActive", task : "task", bookend : "bookend")
    
    var record : CKRecord
    
    init(record : CKRecord) {
        self.record = record
    }
    
    init() {
        self.record = CKRecord(recordType: CKTimeBlock.recordType)
    }
    
    var name : String {
        get {
            return self.record.value(forKey: CKTimeBlock.keys.name) as! String
        }
        set {
            self.record.setValue(newValue, forKey: CKTimeBlock.keys.name)
        }
    }
    
    var startTime : Date {
        get {
            return self.record.value(forKey: CKTimeBlock.keys.startTime) as! Date
        }
        set {
            self.record.setValue(newValue, forKey: CKTimeBlock.keys.startTime)
        }
    }
    
    var endTime : Date {
        get {
            return self.record.value(forKey: CKTimeBlock.keys.endTime) as! Date
        }
        set {
            self.record.setValue(newValue, forKey: CKTimeBlock.keys.endTime)
        }
    }
    
    var isActive : Bool {
        get {
            return self.record.value(forKey: CKTimeBlock.keys.isActive) as! Bool
        }
        set {
            self.record.setValue(newValue, forKey: CKTimeBlock.keys.isActive)
        }
    }
    
    var task : String {
        get {
            return self.record.value(forKey: CKTimeBlock.keys.task) as! String
        }
        set {
            self.record.setValue(newValue, forKey: CKTimeBlock.keys.task)
        }
    }
    
    var bookend : Int{
        get {
            return self.record.value(forKey: CKTimeBlock.keys.bookend) as! Int
        }
        set {
            self.record.setValue(newValue, forKey: CKTimeBlock.keys.bookend)
        }
    }
}

class CKTimeBlockModel{
    private let database = CKContainer.default().privateCloudDatabase
    
    var timeBlocks = [CKTimeBlock]() {
        didSet {
            self.notificationQueue.addOperation {
                self.onChange?()
            }
        }
    }
    
    var onChange : (() -> Void)?
    var onError : ((Error) -> Void)?
    var notificationQueue = OperationQueue.main
    
    private func handle(error: Error) {
        self.notificationQueue.addOperation {
            self.onError?(error)
        }
    }
    
    @objc func refresh() {
        let query = CKQuery(recordType: CKTimeBlock.recordType, predicate: NSPredicate(value: true))
        
        database.perform(query, inZoneWith: nil) { records, error in
            guard let records = records, error == nil else {
                self.handle(error: error!)
                return
            }
            
            self.timeBlocks = records.map { record in CKTimeBlock(record: record) }
        }
    }
    
    func addTimeBlock(task: String?) -> CKTimeBlock{
        
        var timeBlock = CKTimeBlock()
        if let task = task{
            timeBlock.task = task
        }
        timeBlock.startTime = Date()
        return timeBlock
    }
    
    func delete(at index : Int) {
        let recordId = self.timeBlocks[index].record.recordID
        database.delete(withRecordID: recordId) { _, error in
            guard error == nil else {
                self.handle(error: error!)
                return
            }
        }
    }
    
    func saveCK(_ timeBlock: CKTimeBlock?){
        if let timeBlock = timeBlock{
            database.save(timeBlock.record){ _, error in
                guard error == nil else {
                    self.handle(error: error!)
                    return
                }
            }
        }
    }
    
    func wipeDatabase(){
        for (index, _) in timeBlocks.enumerated(){
            delete(at: index)
        }
    }
}

