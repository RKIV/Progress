//
//  TimerHelper.swift
//  Progress
//
//  Created by Robert Keller on 7/23/18.
//  Copyright © 2018 RKIV. All rights reserved.
//

import Foundation

class TimerHelper{
    
    // MARK: Counters
    static var taskTimeCountSeconds: Double = 0
    static var taskTimerCountMinutes = 0
    static var taskTimerCountHours = 0
    
    static func updateTimerCount() -> String{
        //Advance count
        taskTimeCountSeconds += 0.1
        let flooredSeconds = Int(floor(taskTimeCountSeconds))
        if flooredSeconds == 60{
            taskTimeCountSeconds = 0
            taskTimerCountMinutes += 1
        }
        if taskTimerCountMinutes == 60{
            taskTimerCountMinutes = 0
            taskTimerCountHours += 1
        }
        //Format time
        var strFlooredSeconds = "\(flooredSeconds)"
        var strTaskTimerCountMinutes = "\(taskTimerCountMinutes)"
        var strTaskTimerCountHours = "\(taskTimerCountHours)"
        if flooredSeconds < 10{
            strFlooredSeconds = "0\(flooredSeconds)"
        }
        if taskTimerCountMinutes < 10 {
            strTaskTimerCountMinutes = "0\(taskTimerCountMinutes)"
        }
        if taskTimerCountHours < 10{
            strTaskTimerCountHours = "0\(taskTimerCountHours)"
        }
        
        return "\(strTaskTimerCountHours):\(strTaskTimerCountMinutes):\(strFlooredSeconds)"
    }
    
    static func resetTimer(){
        taskTimeCountSeconds = 0
        taskTimerCountMinutes = 0
        taskTimerCountHours = 0
    }
    
    
}
