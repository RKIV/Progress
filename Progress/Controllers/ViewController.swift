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
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet var taskPickerView: UIView!
    
    var effect: UIVisualEffect!
    
    // MARK: Timers
    var timer = Timer()

    // MARK: Booleans
    var timerIsActive = false
    var timerHasBeenReset = true
    
    // MARK: Core Data and Cloud Kit Stuff
    static var currentTimeBlock: TimeBlock?
    static var currentCKTimeBlock: CKTimeBlock?
    var model = CKTimeBlockModel()
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        taskPickerView.layer.cornerRadius = 5
        
        self.model.onError = { error in
            let alert = UIAlertController(title: "Error", message: String(describing: error), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
        
//        self.model.onChange = {
//            self.tableView.reloadData()
//            self.refreshControl!.endRefreshing()
//        }
        
        self.model.refresh()
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateTimes), userInfo: nil, repeats: true)
    }
    
    //Animation Functions
    func animatePickerIn(){
        self.view.addSubview(taskPickerView)
        taskPickerView.center = self.view.center
        taskPickerView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        taskPickerView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.taskPickerView.alpha = 1
            self.taskPickerView.transform = CGAffineTransform.identity
        }
    }
    func animatePickerOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.taskPickerView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.taskPickerView.alpha = 0
            self.visualEffectView.effect = nil
        }) { (success) in
            self.taskPickerView.removeFromSuperview()
        }
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
        
        
    }
    
    // MARK: IBActions
    @IBAction func startButtonTapped(_ sender: Any) {
        //Update end date for previous time block
        ViewController.currentTimeBlock?.endTime = Date()
        CoreDataHelper.saveTimeBlock()
        //--------------------------
        ViewController.currentCKTimeBlock?.endTime = Date()
        model.saveCK(ViewController.currentCKTimeBlock)
        
        //Create new upcomming time block
        ViewController.currentTimeBlock = CoreDataHelper.newTimeBlock()
        ViewController.currentTimeBlock?.startTime = Date()
        //--------------------------
        //Date set in intitializer for CloudKit object
        ViewController.currentCKTimeBlock = model.addTimeBlock(task: nil)
        
        //Button formatting and setting upcomming time block mode
        if timerIsActive{
            startPauseButton.setTitle("Start", for: .normal)
            
            ViewController.currentTimeBlock?.isActive = false
            //--------------------------
            ViewController.currentCKTimeBlock?.isActive = false
            
        } else {
            startPauseButton.setTitle("Pause", for: .normal)
            
            ViewController.currentTimeBlock?.isActive = true
            //--------------------------
            ViewController.currentCKTimeBlock?.isActive = true
        }
        if timerHasBeenReset{
            timerHasBeenReset = false
            
            ViewController.currentTimeBlock?.bookend = Int16(Constants.timeBlockState.Start.rawValue)
            //--------------------------
            ViewController.currentCKTimeBlock?.bookend = Constants.timeBlockState.Start.rawValue
        }
        timerIsActive = !timerIsActive
    }
    @IBAction func resetButtonTapped(_ sender: Any) {
        if !timerHasBeenReset{
            //Formatting timer and buttons
            startPauseButton.setTitle("Start", for: .normal)
            TimerHelper.resetTimer()
            taskTimerLabel.text = "00:00:00"
            timerHasBeenReset = true
            timerIsActive = false
            
            //Finalizing bookend timeblock for timezone
            ViewController.currentTimeBlock?.bookend = Int16(Constants.timeBlockState.End.rawValue)
            ViewController.currentTimeBlock?.endTime = Date()
            CoreDataHelper.saveTimeBlock()
            ViewController.currentTimeBlock = nil
            //--------------------------
            ViewController.currentCKTimeBlock?.bookend = Constants.timeBlockState.End.rawValue
            ViewController.currentCKTimeBlock?.endTime = Date()
            model.saveCK(ViewController.currentCKTimeBlock)
            ViewController.currentCKTimeBlock = nil
        }
    }
    @IBAction func testableButtonTapped(_ sender: Any) {
        model.refresh()
        for timeBlockCK in model.timeBlocks{
            print(timeBlockCK)
        }
        for timeBlock in CoreDataHelper.retrieveTimeBlocks(){
            print(timeBlock.bookend)
        }
    }
    @IBAction func testableButtonDraggedOutside(_ sender: Any) {
        model.refresh()
        model.wipeDatabase()
        print("Database wiped")
    }
    @IBAction func startButtonDraggedOutside(_ sender: Any) {
        animatePickerIn()
    }
    @IBAction func dismissPicker(_ sender: Any) {
        animatePickerOut()
    }
    
    
}

