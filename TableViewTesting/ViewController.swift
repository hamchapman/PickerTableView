//
//  ViewController.swift
//  TableViewTesting
//
//  Created by Hamilton Chapman on 30/03/2015.
//  Copyright (c) 2015 hc.gg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var c1: IntervalPickerController!
    var c2: IntervalPickerController!
    
    @IBOutlet weak var MinutesTableView: UITableView!
    @IBOutlet weak var SecondsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var intervalDictionaryData: Array<Dictionary<String, String>> = []
        
        for i in [Int](0...60) {
            intervalDictionaryData.append(["index": String(i), "text": String(i)])
        }
        
        c1 = IntervalPickerController(tableData: intervalDictionaryData, tableView: &MinutesTableView)
        c2 = IntervalPickerController(tableData: intervalDictionaryData, tableView: &SecondsTableView)
        
        MinutesTableView.dataSource = c1
        MinutesTableView.delegate = c1
        SecondsTableView.dataSource = c2
        SecondsTableView.delegate = c2
        
        MinutesTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        SecondsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


class IntervalPickerController: NSObject, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate  {
    let tableData: Array<Dictionary<String, String>>!
    let tableView: UITableView!
    
    init(tableData: Array<Dictionary<String, String>>, inout tableView: UITableView!) {
        self.tableData = tableData
        self.tableView = tableView
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        println("Decelerating beginning")
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        println("Ending decelrating")
//        setTextOfMiddleElement(scrollView)
        scrollToCellTop(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        println("Well hello there")
        setTextOfMiddleElement(scrollView)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        println("did end dragging")
        if !decelerate {
            scrollToCellTop(scrollView)
        }
    }
    
    func scrollToCellTop(scrollView: UIScrollView) {
        var cellHeight = Int(tableView.rectForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)).height)
        if (Int(scrollView.contentOffset.y) % cellHeight) == 0 {
            setTextOfMiddleElement(scrollView)
        } else if ((Int(scrollView.contentOffset.y) % cellHeight) < (cellHeight / 2)) {
            scrollView.setContentOffset(CGPointMake(0, CGFloat(Int(scrollView.contentOffset.y) - (Int(scrollView.contentOffset.y) % cellHeight))), animated: true)
        } else {
            scrollView.setContentOffset(CGPointMake(0, CGFloat(Int(scrollView.contentOffset.y) + cellHeight - (Int(scrollView.contentOffset.y) % cellHeight))), animated: true)
        }
    }
    
    func setTextOfMiddleElement(scrollView: UIScrollView) {
        var tableViewOffset = Int(scrollView.contentOffset.y) // x
        var totalTableViewHeight = scrollView.contentSize.height // 2684
        var visibleTableViewHeight = Int(scrollView.frame.height) //541
        var cellHeight = Int(tableView.rectForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)).height) // cellHeight = 44
        var cellsOnScreen = Int(visibleTableViewHeight / cellHeight)
        
        var middleRowIndex = (cellsOnScreen / 2) + (tableViewOffset / cellHeight)
        tableView.cellForRowAtIndexPath(NSIndexPath(forRow: middleRowIndex, inSection: 0))?.textLabel?.text = "Middle man"
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        for e in tableData {
            tableView.cellForRowAtIndexPath(NSIndexPath(forRow: e["index"]!.toInt()!, inSection: 0))?.textLabel?.text = e["index"]!
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        let item = tableData[indexPath.row]
    
        cell.textLabel?.text = String(stringInterpolationSegment: item["text"]!)
        return cell
    }
}