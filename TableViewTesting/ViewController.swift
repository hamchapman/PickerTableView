//
//  ViewController.swift
//  TableViewTesting
//
//  Created by Hamilton Chapman on 30/03/2015.
//  Copyright (c) 2015 hc.gg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var c1: IntervalPickerController<Dictionary<String, String>>!
    var c2: IntervalPickerController<Dictionary<String, String>>!
    
    @IBOutlet weak var MinutesTableView: UITableView!
    @IBOutlet weak var SecondsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var timeUnits: Array<Dictionary<String, String>> = []
        
        for i in [Int](0...60) {
            timeUnits.append(["index": String(i), "text": String(i)])
        }
        
        let numberOfRows: Int = 8
        
        c1 = IntervalPickerController(tableData: timeUnits, tableView: &MinutesTableView, numberOfRows: numberOfRows)
        c2 = IntervalPickerController(tableData: timeUnits, tableView: &SecondsTableView, numberOfRows: numberOfRows)
        
        MinutesTableView.dataSource = c1
        MinutesTableView.delegate = c1
        SecondsTableView.dataSource = c2
        SecondsTableView.delegate = c2
        
        MinutesTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        MinutesTableView.backgroundColor = UIColor.redColor()
        
        MinutesTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        SecondsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let rowHeight = Float(MinutesTableView.frame.height) / Float(numberOfRows)

        MinutesTableView.rowHeight = CGFloat(rowHeight)
        SecondsTableView.rowHeight = CGFloat(rowHeight)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

class IntervalPickerController<T>: NSObject, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate  {
//    let tableData: Array<Dictionary<String, String>>!
    let tableData: [T]!
    let tableView: UITableView!
    let numberOfRows: Int!
    
    init(tableData: [T], inout tableView: UITableView!, numberOfRows: Int) {
//    init(tableData: Array<Dictionary<String, String>>, inout tableView: UITableView!, numberOfRows: Int) {
        
//        var loopedData: Array<Dictionary<String, String>> = []
        var loopedData: [T] = []

        for i in 1...50 {
            loopedData += tableData
        }
        
        self.tableData = tableData
        self.tableView = tableView
        self.numberOfRows = numberOfRows
    
//        self.tableView.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollToCellTop(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        setTextOfMiddleElement(scrollView)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollToCellTop(scrollView)
        }
    }
    
    func scrollToCellTop(scrollView: UIScrollView) {
        let tableViewOffset = scrollView.contentOffset.y
        let visibleTableViewHeight = scrollView.frame.height
        let cellHeight = tableView.rectForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)).height
        
        let heightOfFullHiddenCellsAbove = tableViewOffset - (tableViewOffset % cellHeight)
        let halfViewMinusMiddleCell = (visibleTableViewHeight - cellHeight) / 2
        let offsetAdjustment = cellHeight - (halfViewMinusMiddleCell % cellHeight)
        
        if self.numberOfRows % 2 == 1 {
            if ((tableViewOffset % cellHeight) < (cellHeight / 2)) {
                scrollView.setContentOffset(CGPointMake(0, CGFloat(tableViewOffset - (tableViewOffset % cellHeight))), animated: true)
            } else {
                scrollView.setContentOffset(CGPointMake(0, CGFloat(tableViewOffset + cellHeight - (tableViewOffset % cellHeight))), animated: true)
            }
        } else {
            scrollView.setContentOffset(CGPointMake(0, CGFloat(tableViewOffset + (cellHeight / 2) - (tableViewOffset % cellHeight))), animated: true)
        }
        
//        if (tableViewOffset % cellHeight) == 0.0 {
//            setTextOfMiddleElement(scrollView)
//        } else if ((tableViewOffset % cellHeight) < (cellHeight / 2)) {
//            scrollView.setContentOffset(CGPointMake(0, CGFloat(tableViewOffset - (tableViewOffset % cellHeight))), animated: true)
//        } else {
//            scrollView.setContentOffset(CGPointMake(0, CGFloat(tableViewOffset + cellHeight - (tableViewOffset % cellHeight))), animated: true)
//        }
        
//        scrollView.setContentOffset(CGPointMake(0, heightOfFullHiddenCellsAbove + offsetAdjustment), animated: true)
    }
    
    func setTextOfMiddleElement(scrollView: UIScrollView) {
        // TODO: Get rid of constant casting to Int (only need to in forRow: call)
        let tableViewOffset = scrollView.contentOffset.y
        let totalTableViewHeight = scrollView.contentSize.height
        let visibleTableViewHeight = scrollView.frame.height
        let cellHeight = tableView.rectForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)).height
        let cellsOnScreen = visibleTableViewHeight / cellHeight
        
        let middleRowIndex = (cellsOnScreen / 2) + (tableViewOffset / cellHeight)
        tableView.cellForRowAtIndexPath(NSIndexPath(forRow: Int(middleRowIndex), inSection: 0))?.textLabel?.text = "Middle"
        tableView.cellForRowAtIndexPath(NSIndexPath(forRow: Int(middleRowIndex), inSection: 0))?.backgroundColor = UIColor.blueColor()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // TODO: Make this only run once after scrolling / dragging has begun
        for e in tableData {
            tableView.cellForRowAtIndexPath(NSIndexPath(forRow: e["index"]!.toInt()!, inSection: 0))?.textLabel?.text = e["index"]!
        }
    }
    
    subscript(input: T) -> String {
        get {
            return "test"
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        let item = tableData[indexPath.row]
        
        cell.backgroundColor = UIColor.clearColor()
        
        cell.textLabel?.text = String(stringInterpolationSegment: item["text"]!)
        let myFont = UIFont(name: "Arial", size: 40.0);
        cell.textLabel!.font  = myFont;
        return cell
    }
    
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        println(tableView.cellForRowAtIndexPath(indexPath)?.frame.size.height)
//    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        println(tableView.cellForRowAtIndexPath(indexPath)!.frame.size.height)
//        return CGFloat(50.0)
//    }
    
}