//
//  FeedViewController.swift
//  iChallenge
//
//  Created by Admin on 6/24/16.
//  Copyright © 2016 AAkash. All rights reserved.
//

import UIKit
import SnapKit
import Parse
import Bolts
import KFSwiftImageLoader

class FeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    lazy var collectionView = UICollectionView()
    var statisticView = UIView()
    var brainView: BrainView!
    var reorderView: ReorderView!
    var topics = ["Biology", "Mathematics", "Physics", "Chemistry", "Literature", "Technology", "Geography", "Art", "Sport"]
    var colors = [UIColor.bioColor(UIColor()), UIColor.mathColor(UIColor()), UIColor.physColor(UIColor()), UIColor.litColor(UIColor()), UIColor.geoColor(UIColor()), UIColor.techColor(UIColor()), UIColor.chemColor(UIColor()), UIColor.artColor(UIColor()), UIColor.sporColor(UIColor())]
    var imagesUrls = [String]()
    var sources = [String]()
    var deadlineLabel = UILabel()
    var index: Int!
    var point = 0
    var completed = 0
    var showMenu = true
    
    var imageBackgroundView = UIImageView()
    var layerBackgroundView = UIView()
    
    let screenHeight = UIScreen.mainScreen().bounds.height
    let screenWidth = UIScreen.mainScreen().bounds.width
    
    var increment = 0
    var incrementCompleted = 0
    var incrementFailed = 0
    var timer = NSTimer()
    var timerCompleted = NSTimer()
    var timerFailed = NSTimer()
    
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        for family: String in UIFont.familyNames()
        {
            print("\(family)")
            for names: String in UIFont.fontNamesForFamilyName(family)
            {
                print("== \(names)")
            }
        }
 
        
        setup()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(FeedViewController.notLoggedIn), forControlEvents: .ValueChanged)
        collectionView.addSubview(refreshControl)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.pagingEnabled = false
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.registerClass(ChallengeCollectionViewCell.self, forCellWithReuseIdentifier: "ChallengeCell")
        collectionView.backgroundColor = UIColor.blackColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        let attributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "Pacifico-Regular", size: screenWidth*0.05)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.automaticallyAdjustsScrollViewInsets = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        notLoggedIn()
    
        self.navigationController?.navigationBarHidden = false
    }
    
    func notLoggedIn() {
        if (PFUser.currentUser() == nil) {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(viewController, animated: true, completion: nil)
            })
        } else {
            self.topics = self.reorderView.topics
            loadImages()
            loadScore()
        }
    }
    
    func loadImages() {
        self.imagesUrls.removeAll()
        self.sources.removeAll()
 
        reloadData()
    }
    
    func reloadData() {
        
        if imagesUrls.count < 9 {
        let query = PFQuery(className:"Challenge")
        query.whereKey("topic", equalTo: topics[imagesUrls.count])
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        let url = object["imageUrl"] as! String
                        self.imagesUrls.append(url)
                        let source = object["source"] as! String
                        self.sources.append(source)
                        self.reloadData()
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        } else {
            refreshControl.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    
    func loadScore() {
        self.point = 0
        self.completed = 0
        let query = PFQuery(className:"Answer")
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) answers.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        let score = object["point"] as! Int
                        self.point = self.point + score
                        self.completed = self.completed + 1
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        print("asdasda \(self.point)")
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row+1 == topics.count && showMenu == true{
            UIView.animateWithDuration(1, animations: {[weak self] in
                self!.brainView.frame = CGRectMake(0, 0, self!.screenWidth, self!.screenHeight)
                self!.collectionView.frame = CGRectMake(0, -self!.screenHeight, self!.screenWidth, self!.screenHeight)
                })
            self.changeBrainImage()
            self.startTimerPoint()
            self.startTimerCompleted()
            self.startTimerFailed()
        }
    }
    
    func changeBrainImage() {
       let change = CGFloat(Double(self.point) * 0.111)
       UIView.animateWithDuration(2, animations: {[weak self] in
            self?.brainView.statsLabelBlue.frame = CGRectMake(self!.screenWidth*0.21, self!.screenHeight*0.2, self!.screenWidth*0.58*change, self!.screenHeight*0.3)
        })
    }
    
    func showMenuChallenges() {
        if showMenu == true {
            self.collectionView.scrollEnabled = false
            UIView.animateWithDuration(0.5, animations: {[weak self] in
                self!.reorderView.frame = CGRectMake(0, 0, self!.screenWidth * 0.5, self!.screenHeight)
                self!.collectionView.frame = CGRectMake(self!.screenWidth*0.5, 0, self!.screenWidth, self!.screenHeight)
                })
            showMenu = false
        } else {
            self.collectionView.scrollEnabled = true
            UIView.animateWithDuration(0.5, animations: {[weak self] in
                self!.reorderView.frame = CGRectMake(-self!.screenWidth * 0.5, 0, self!.screenWidth * 0.5, self!.screenHeight)
                self!.collectionView.frame = CGRectMake(0, 0, self!.screenWidth, self!.screenHeight)
                })
            print("There is a bug")
            showMenu = true
        }
    }
    
    @IBAction func menuButtonPressed(sender: UIBarButtonItem) {
        showMenuChallenges()
    }
    
    @IBAction func dashboardButtonPressed(sender: UIBarButtonItem) {
        if showMenu == true {
            UIView.animateWithDuration(1, animations: {[weak self] in
                self!.brainView.frame = CGRectMake(0, 0, self!.screenWidth, self!.screenHeight)
                self!.collectionView.frame = CGRectMake(0, -self!.screenHeight, self!.screenWidth, self!.screenHeight)
                })
            self.changeBrainImage()
            self.startTimerPoint()
            self.startTimerCompleted()
            self.startTimerFailed()
        }
    }
    
    /*
    @IBAction func signOutButtonPressed(sender: UIBarButtonItem) {
        PFUser.logOut()
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
            self.presentViewController(viewController, animated: true, completion: nil)
        })
    }
    */
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if UIScreen.mainScreen().bounds.width < UIScreen.mainScreen().bounds.height {
            if let swipeGesture = gesture as? UISwipeGestureRecognizer {
                
                switch swipeGesture.direction {
                case UISwipeGestureRecognizerDirection.Down:
                    if showMenu == true {
                    UIView.animateWithDuration(1, animations: {[weak self] in
                        self!.brainView.frame = CGRectMake(0, self!.screenHeight, self!.screenWidth, self!.screenHeight)
                        self!.brainView.statsLabelBlue.frame = CGRectMake(self!.screenWidth*0.21, self!.screenHeight*0.2, 0, self!.screenHeight*0.3)
                        self!.collectionView.frame = CGRectMake(0, 0, self!.screenWidth, self!.screenHeight)
                        })
                    }
                case UISwipeGestureRecognizerDirection.Left:
                    UIView.animateWithDuration(0.5, animations: {[weak self] in
                        self!.reorderView.frame = CGRectMake(-self!.screenWidth * 0.5, 0, self!.screenWidth * 0.5, self!.screenHeight)
                        self!.collectionView.frame = CGRectMake(0, 0, self!.screenWidth, self!.screenHeight)
                        })
                    showMenu = true
                    print("There is a bug")
                default:
                    break
                }
            }
        }
    }
    
    func animateNumber() {
        increment = increment + 1
        if self.point != 0 {
            self.brainView.failedLabel.text = "\(increment)%"
        }
        if increment == self.point*10 {
            timer.invalidate()
        }
    }
    
    func startTimerPoint() {
        increment = 0
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(animateNumber), userInfo: nil, repeats: true)
    }
    
    func animateNumberCompleted() {
        incrementCompleted = incrementCompleted + 1
        if self.point != 0 {
            self.brainView.acceptedLabel.text = "\(incrementCompleted)%"
        }
        if incrementCompleted == self.completed*10 {
            timerCompleted.invalidate()
        }
    }
    
    func startTimerCompleted() {
        incrementCompleted = 0
        timerCompleted.invalidate()
        timerCompleted = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(animateNumberCompleted), userInfo: nil, repeats: true)
    }
    
    func animateNumberFailed() {
        incrementFailed = incrementFailed + 1
        if self.point != 0 {
            self.brainView.totalLabel.text = "\(incrementFailed)%"
        }
        if incrementFailed == (self.completed-self.point)*10 {
            timerFailed.invalidate()
        }
    }
    
    func startTimerFailed() {
        incrementFailed = 0
        timerFailed.invalidate()
        timerFailed = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(animateNumberFailed), userInfo: nil, repeats: true)
    }
        
    func setup() {
        
        self.view.layer.backgroundColor = UIColor.blackColor().CGColor
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipeDown)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
        imageBackgroundView = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        imageBackgroundView.image = UIImage(named: "earth")
        imageBackgroundView.contentMode = .ScaleAspectFill
        self.view.addSubview(imageBackgroundView)
        
        layerBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        layerBackgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        self.view.addSubview(layerBackgroundView)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(screenWidth, screenHeight*0.35)
        layout.minimumLineSpacing = screenWidth * 0.005
        collectionView = UICollectionView(frame: CGRect(x: screenWidth * 0.05, y: 0.0, width: screenWidth*0.9, height: screenHeight), collectionViewLayout: layout)
        self.collectionView.contentInset = UIEdgeInsetsZero
        self.view.addSubview(collectionView)
        
        brainView = BrainView(frame: CGRect(x: 0, y: screenHeight, width: screenWidth, height: screenHeight))
        self.view.addSubview(brainView)
        
        reorderView = ReorderView(frame: CGRect(x: -screenWidth*0.5, y: 0, width: screenWidth*0.5, height: screenHeight))
        self.view.addSubview(reorderView)
        
        statisticView = UIView(frame: CGRect(x: 0, y: screenHeight, width: screenWidth, height: screenHeight))
        statisticView.layer.backgroundColor = UIColor.blackColor().CGColor
        self.view.addSubview(statisticView)
        
        updateViewConstraints()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        let screenHeight = UIScreen.mainScreen().bounds.height
        let screenWidth = UIScreen.mainScreen().bounds.width
        
        collectionView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(screenWidth * 0.005)
            make.width.equalTo(screenWidth * 0.99)
            make.height.equalTo(screenHeight)
            make.centerX.equalTo(self.view.snp_centerX)
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ChallengeCell", forIndexPath: indexPath) as! ChallengeCollectionViewCell
        if imagesUrls.count > 0 {
            if let imageUrl = self.imagesUrls[indexPath.row] as? String {
                cell.imageView.loadImageFromURLString(imageUrl, placeholderImage: UIImage(named: ""), completion: nil)
            }
            cell.sourceLabel.text = sources[indexPath.row]
            
        }
        cell.circleView.layer.backgroundColor = colors[indexPath.row]().CGColor
        cell.textView.text = topics[indexPath.row].uppercaseString
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        index = indexPath.row
        self.performSegueWithIdentifier("SegueChallenge", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueChallenge" {
            
            let challengeViewController = segue.destinationViewController as! ChallengeViewController
            
            challengeViewController.color = colors[index]()
            challengeViewController.topic = topics[index]
            UIView.animateWithDuration(0.5, animations: {[weak self] in
                self!.reorderView.frame = CGRectMake(-self!.screenWidth * 0.5, 0, self!.screenWidth * 0.5, self!.screenHeight)
                self!.collectionView.frame = CGRectMake(0, 0, self!.screenWidth, self!.screenHeight)
                })
        }
    }

}
