//
//  TimerViewController.swift
//  TableViewTesting
//
//  Created by Hamilton Chapman on 13/04/2015.
//  Copyright (c) 2015 hc.gg. All rights reserved.
//

import UIKit
import AVFoundation

class TimerViewController: UIViewController {
    @IBOutlet weak var PauseButton: UIButton!
    @IBOutlet weak var EndButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBAction func endTimer(sender: AnyObject) {
        if(self.presentingViewController != nil){
            speakTimer.invalidate()
            speakCatchupTimer.invalidate()
            labelTimer.invalidate()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func toggleTimer(sender: AnyObject) {
        if !timerRunning {
            speakCatchupTimerRunning = true
            timerRunning = true
            let updateSelector: Selector = "updateTime"
            let speakCatchupSelector: Selector = "speakCatchupTimeAloud"
            labelTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: updateSelector, userInfo: nil, repeats: true)
            
            sender.setTitle("Pause", forState: .Normal)
            
            var currentTime = NSDate.timeIntervalSinceReferenceDate()
            elapsedPausedTimeTotal += elapsedPausedTime
            var elapsedTime: NSTimeInterval = currentTime - startTime - elapsedPausedTimeTotal
            let catchupInterval = Double(speakInterval) - (Double(elapsedTime) % Double(speakInterval))
            speakCatchupTimer = NSTimer.scheduledTimerWithTimeInterval(catchupInterval, target: self, selector: speakCatchupSelector, userInfo: nil, repeats: false)
        } else {
            timerRunning = false
            pausedTime = NSDate()
            sender.setTitle("Resume", forState: .Normal)
            speakTimer.invalidate()
        }
    }
    
    var startTime: NSTimeInterval!
    var labelTimer: NSTimer = NSTimer()
    var speakTimer: NSTimer = NSTimer()
    var speakCatchupTimer: NSTimer = NSTimer()
    var timerRunning = true
    var speakCatchupTimerRunning = false
    var pausedTime: NSDate!
    var elapsedPausedTime: NSTimeInterval = 0.0
    var elapsedPausedTimeTotal: NSTimeInterval = 0.0
    var speakInterval: Int!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if (!labelTimer.valid) {
            startTime = NSDate.timeIntervalSinceReferenceDate()
            let updateSelector: Selector = "updateTime"
            let speakSelector: Selector = "speakTimeAloud"
            labelTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: updateSelector, userInfo: nil, repeats: true)
            speakTimer = NSTimer.scheduledTimerWithTimeInterval(Double(speakInterval), target: self, selector: speakSelector, userInfo: nil, repeats: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTime() {
        if timerRunning {
            var currentTime = NSDate.timeIntervalSinceReferenceDate()
            var elapsedTime: NSTimeInterval = currentTime - startTime - elapsedPausedTimeTotal
            
            let minutes = UInt8(elapsedTime / 60.0)
            elapsedTime -= (NSTimeInterval(minutes) * 60)
            
            let seconds = UInt8(elapsedTime)
            elapsedTime -= NSTimeInterval(seconds)
            
            let fraction = UInt8(elapsedTime * 100)
            
            let strMinutes = minutes > 9 ? String(minutes): "0" + String(minutes)
            let strSeconds = seconds > 9 ? String(seconds): "0" + String(seconds)
            let strFraction = fraction > 9 ? String(fraction): "0" + String(fraction)
            
            timerLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
        } else {
            let elapsedPausedTimeCalculator = NSDate.timeIntervalSinceDate(NSDate())
            elapsedPausedTime = elapsedPausedTimeCalculator(pausedTime)
        }
    }
    
    func speakTimeAloud() {
        var audioSession = AVAudioSession.sharedInstance()
        var success = audioSession.setCategory(AVAudioSessionCategoryPlayback, withOptions: .MixWithOthers, error: nil)
        audioSession.setActive(true, error: nil)
        
        let synth = AVSpeechSynthesizer()
        var myUtterance = AVSpeechUtterance(string: timerLabel.text!.componentsSeparatedByString(":")[1] + " seconds")
        myUtterance.rate = 0.2
        synth.speakUtterance(myUtterance)
    }
    
    func speakCatchupTimeAloud() {
        speakCatchupTimer.invalidate()
        let speakSelector: Selector = "speakTimeAloud"
        speakTimer = NSTimer.scheduledTimerWithTimeInterval(Double(speakInterval), target: self, selector: speakSelector, userInfo: nil, repeats: true)
        speakTimeAloud()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
