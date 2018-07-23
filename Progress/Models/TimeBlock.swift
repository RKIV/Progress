//
//  TimeBlock.swift
//  Progress
//
//  Created by Robert Keller on 7/23/18.
//  Copyright © 2018 RKIV. All rights reserved.
//

import Foundation

struct TimeBlock{
    let startTime: Date
    var endTime: Date?
    let task: String
    
    init(task: String){
        startTime = Date()
        self.task = task
    }
}
