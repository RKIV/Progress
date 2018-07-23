//
//  ViewController.swift
//  Progress
//
//  Created by Robert Keller on 7/23/18.
//  Copyright © 2018 RKIV. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var clock: UILabel!
    @IBOutlet weak var startPauseButton: UIButton!
    @IBOutlet weak var taskTimerLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    
    // MARK: Timers
    var timer = Timer()

    // MARK: Booleans
    var timerIsActive = false
    var timerHasBeenReset = true
    
    // MARK: Core Data Stuff
    static var currentTimeBlock: TimeBlock?
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateTimes), userInfo: nil, repeats: true)
    }
    
    // MARK: IBActions
    @IBAction func startButtonTapped(_ sender: Any) {
        //Update end date for previous time block
        ViewController.currentTimeBlock?.endTime = Date()
        CoreDataHelper.saveTimeBlock()
        //Create new upcomming time block
        ViewController.currentTimeBlock = CoreDataHelper.newTimeBlock()
        ViewController.currentTimeBlock?.startTime = Date()
        //Button formatting and setting upcomming time block mode
        if timerIsActive{
            ViewController.currentTimeBlock?.isActive = false
            startPauseButton.setTitle("Start", for: .normal)
        } else {
            ViewController.currentTimeBlock?.isActive = true
            startPauseButton.setTitle("Pause", for: .normal)
        }
        if timerHasBeenReset{
            ViewController.currentTimeBlock?.bookend = Int16(Constants.timeBlockState.Start.rawValue)
            timerHasBeenReset = false
        }
        timerIsActive = !timerIsActive
    }
    @IBAction func resetButtonTapped(_ sender: Any) {
        if !timerHasBeenReset{
            //Formatting timer and buttons
            startPauseButton.setTitle("Start", for: .normal)
            TimerHelper.resetTimer()
            taskTimerLabel.text = "00:00:00"
            //Finalizing bookend timeblock for timezone
            ViewController.currentTimeBlock?.bookend = Int16(Constants.timeBlockState.End.rawValue)
            ViewController.currentTimeBlock?.endTime = Date()
            timerHasBeenReset = true
            timerIsActive = false
        }
    }
    @IBAction func testableButtonTapped(_ sender: Any) {
        //Debugging coredata
        let tradeBlocks = CoreDataHelper.retrieveTimeBlocks()
        for block in tradeBlocks.sorted(by: { $0.startTime! < $1.startTime! }){
            print(block.isActive, Constants.timeBlockState(rawValue: Int(block.bookend))!)
        }
        print("----------------------------------------")
    }
    
    // MARK: @Objc Timer selectors
    @objc func updateTimes(){
        //Updating clock
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss a"
        clock.text = formatter.string(from: Date())
        //Updating timer
        if timerIsActive{
            taskTimerLabel.text = TimerHelper.updateTimerCount()
        }
        
        ViewController.currentTimeBlock = nil
    }
    
}

