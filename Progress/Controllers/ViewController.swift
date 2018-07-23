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
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateClock), userInfo: nil, repeats: true)
    }
    
    // MARK: IBActions
    @IBAction func startButtonTapped(_ sender: Any) {
        if timerHasBeenReset{
            timerHasBeenReset = false
        }
        timerIsActive = !timerIsActive
        
        if timerIsActive{
            startPauseButton.setTitle("Stop", for: .normal)
        } else {
            startPauseButton.setTitle("Start", for: .normal)
        }
        print(startPauseButton.state)
    }
    @IBAction func resetButtonTapped(_ sender: Any) {
        startPauseButton.setTitle("Start", for: .normal)
        timerIsActive = false
        if !timerHasBeenReset{
            TimerHelper.resetTimer()
            taskTimerLabel.text = "00:00:00"
            timerHasBeenReset = true
        }
    }
    
    
    // MARK: @Objc Timer selectors
    @objc func updateClock(){
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss a"
        clock.text = formatter.string(from: Date())
        if timerIsActive{
            taskTimerLabel.text = TimerHelper.updateTimerCount()
        }
    }
    
}

