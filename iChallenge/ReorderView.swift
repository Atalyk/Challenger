//
//  ReorderView.swift
//  iChallenge
//
//  Created by Admin on 8/7/16.
//  Copyright © 2016 AAkash. All rights reserved.
//

import UIKit
import SnapKit
import Parse

class ReorderView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    var tableView = UITableView()
    
    var layerView = UIView()
    var logOutButton = UIButton()
    
    lazy var tipTextView = UITextView()
    
    let screenHeight = UIScreen.mainScreen().bounds.height
    let screenWidth = UIScreen.mainScreen().bounds.width
    
    var topics = ["Biology", "Mathematics", "Physics", "Chemistry", "Literature", "Technology", "Geography", "Art & Culture", "Sport", "Economics"]
    var colors = [UIColor.bioColor(UIColor()), UIColor.mathColor(UIColor()), UIColor.physColor(UIColor()), UIColor.litColor(UIColor()), UIColor.geoColor(UIColor()), UIColor.techColor(UIColor()), UIColor.chemColor(UIColor()), UIColor.artColor(UIColor()), UIColor.sporColor(UIColor()), UIColor.econColor(UIColor())]

    override init(frame: CGRect){
        super.init(frame: frame)
        setup()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.registerClass(ReorderTableViewCell.self, forCellReuseIdentifier: "cell")
        
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(ReorderView.longPressGestureRecognized(_:)))
        tableView.addGestureRecognizer(longpress)
    }
    
    func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.locationInView(tableView)
        let indexPath = tableView.indexPathForRowAtPoint(locationInView)
        
        struct My {
            static var cellSnapshot : UIView? = nil
            static var cellIsAnimating : Bool = false
            static var cellNeedToShow : Bool = false
        }
        struct Path {
            static var initialIndexPath : NSIndexPath? = nil
        }
        
        switch state {
        case UIGestureRecognizerState.Began:
            if indexPath != nil {
                Path.initialIndexPath = indexPath
                let cell = tableView.cellForRowAtIndexPath(indexPath!) as! ReorderTableViewCell!
                cell.highlighted = false
                My.cellSnapshot  = snapshotOfCell(cell)

                var center = cell.center
                My.cellSnapshot!.center = center
                My.cellSnapshot!.alpha = 0.0

                tableView.addSubview(My.cellSnapshot!)
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    center.y = locationInView.y
                    My.cellIsAnimating = true
                    My.cellSnapshot!.center = center
                    My.cellSnapshot!.transform = CGAffineTransformMakeScale(1.1, 1.1)
                    My.cellSnapshot!.alpha = 0.98
                    cell.alpha = 0.0
                    }, completion: { (finished) -> Void in
                        if finished {
                            My.cellIsAnimating = false
                            if My.cellNeedToShow {
                                My.cellNeedToShow = false
                                UIView.animateWithDuration(0.25, animations: { () -> Void in
                                    cell.alpha = 1
                                })
                            } else {
                                cell.hidden = true
                            }
                        }
                })
            }
            
        case UIGestureRecognizerState.Changed:
            if My.cellSnapshot != nil {
                var center = My.cellSnapshot!.center
                center.y = locationInView.y
                My.cellSnapshot!.center = center
                if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                    topics.insert(topics.removeAtIndex(Path.initialIndexPath!.row), atIndex: indexPath!.row)
                    tableView.moveRowAtIndexPath(Path.initialIndexPath!, toIndexPath: indexPath!)
                    Path.initialIndexPath = indexPath
                }
            }
        default:
            if Path.initialIndexPath != nil {
                let cell = tableView.cellForRowAtIndexPath(Path.initialIndexPath!) as UITableViewCell!
                if My.cellIsAnimating {
                    My.cellNeedToShow = true
                } else {
                    cell.hidden = false
                    cell.alpha = 0.0
                }
                
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    My.cellSnapshot!.center = cell.center
                    My.cellSnapshot!.transform = CGAffineTransformIdentity
                    My.cellSnapshot!.alpha = 0.0
                    cell.alpha = 1.0
                    
                    }, completion: { (finished) -> Void in
                        if finished {
                            Path.initialIndexPath = nil
                            My.cellSnapshot!.removeFromSuperview()
                            My.cellSnapshot = nil
                        }
                })
            }
        }
    }
    
    func snapshotOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        return cellSnapshot
    }
    
    func logOut()  {
        
        print("test")
        
        PFUser.logOut()
        
        let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
        let vc: UIViewController = storyboard.instantiateViewControllerWithIdentifier("Login")
        let currentController = self.getCurrentViewController()
        currentController?.presentViewController(vc, animated: false, completion: nil)
        
    }
    
    func getCurrentViewController() -> UIViewController? {
        
        if let rootController = UIApplication.sharedApplication().keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
        
    }
    
    func setup() {
    
        self.backgroundColor = UIColor.clearColor()
        
        tipTextView = UITextView(frame: CGRect(x: 0, y: screenHeight*0.65, width: screenWidth*0.5, height: screenHeight*0.1))
        tipTextView.text = ""
        tipTextView.textAlignment = .Center
        tipTextView.backgroundColor = UIColor.clearColor()
        tipTextView.textColor = UIColor.whiteColor()
        tipTextView.font = UIFont(name: "Helvetica-Light", size: screenWidth*0.04)
        self.addSubview(tipTextView)
        
        tableView = UITableView(frame: CGRect(x: 0, y: screenHeight*0.01, width: screenWidth*0.5, height: screenHeight))
        tableView.backgroundColor = UIColor.clearColor()
        self.addSubview(tableView)
        
        logOutButton = UIButton(frame: CGRect(x: self.bounds.width*0.1, y: screenHeight*0.8, width: self.bounds.width*0.8, height: screenHeight*0.1))
        logOutButton.setImage(UIImage(named: "exitButton"), forState: .Normal)
        logOutButton.contentMode = .Center
        logOutButton.addTarget(self, action: #selector(ReorderView.logOut), forControlEvents: .TouchUpInside)
        self.addSubview(logOutButton)
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ReorderTableViewCell
        cell.backgroundColor = UIColor.clearColor()
        cell.challengeLabel.textColor = UIColor.whiteColor()
        cell.challengeLabel.text = topics[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.circleView.backgroundColor = colors[indexPath.row]()
        
        return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
