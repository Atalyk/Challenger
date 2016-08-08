//
//  ChallengeViewController.swift
//  iChallenge
//
//  Created by Admin on 6/25/16.
//  Copyright © 2016 AAkash. All rights reserved.
//

import UIKit
import SnapKit
import Parse
import NVActivityIndicatorView

class ChallengeViewController: UIViewController {
    
    var topic: String!
    var color: UIColor!
    var answerText: String!
    var checked = false
    var source: String!
    var article: String!
    var challengeTextView = UITextView()
    var answerButtonOne = UIButton()
    var answerButtonTwo = UIButton()
    var answerButtonThree = UIButton()
    var answerButtonFour = UIButton()
    var discoverButton = UIButton()
    var circleView = UIView()
    var titleTextView = UITextView()
    var imageBrainView = UIImageView()
    var challenge: PFObject!
    
    var layerView: UIView!
    var imageView: UIImageView!
    var visualEffectView: UIVisualEffectView!
    
    let screenHeight = UIScreen.mainScreen().bounds.height
    let screenWidth = UIScreen.mainScreen().bounds.width

    var point = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        self.edgesForExtendedLayout = UIRectEdge.None
        setup()
        queryChallenge(topic)

    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.title = topic
    
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        let attributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "Pacifico-Regular", size: screenWidth*0.05)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes

    }
    
    func queryChallenge(topic: String) {
        let query = PFQuery(className:"Challenge")
        query.whereKey("topic", equalTo: topic)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        self.challenge = object 
                        self.challengeTextView.text = object["challenge"] as! String
                        self.answerText = object["answer"] as! String
                        if let imageUrl = object["imageUrl"] as? String {
                            self.imageView.loadImageFromURLString(imageUrl)
                        }
                        self.article = object["source"] as! String
                        self.titleTextView.text = self.article
                        self.source = object["url"] as! String
                        
                        let answer1 = object["answer1"] as! String
                        self.answerButtonOne.setTitle(answer1, forState: .Normal)
                        let answer2 = object["answer2"] as! String
                        self.answerButtonTwo.setTitle(answer2, forState: .Normal)
                        let answer3 = object["answer3"] as! String
                        self.answerButtonThree.setTitle(answer3, forState: .Normal)
                        let answer4 = object["answer4"] as! String
                        self.answerButtonFour.setTitle(answer4, forState: .Normal)
                    }
                }
                self.acceptanceChallenge()
                self.checkChallengeAnswered()
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }

    }
    
    func acceptanceChallenge() {
        let query = PFQuery(className:"Answer")
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.whereKey("challenge", equalTo: self.challenge)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        self.checked = object["checked"] as! Bool
                    }
                }
                self.checkChallengeAnswered()
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }

    
    func updateChallenge() {
        let answer = PFObject(className: "Answer")
        answer["user"] = PFUser.currentUser()
        answer["challenge"] = self.challenge
        answer["point"] = point
        answer["checked"] = NSNumber(bool: true)
        answer.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }
    }
    
    func checkChallengeAnswered() {
        if self.checked == true {
            
            if answerButtonOne.titleLabel?.text == answerText {
                answerButtonOne.layer.backgroundColor = UIColor.mathColor(UIColor())().CGColor
            } else {
                answerButtonOne.layer.backgroundColor = UIColor.lightGrayColor().CGColor
            }
            
            answerButtonOne.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                
            if answerButtonTwo.titleLabel?.text == answerText {
                answerButtonTwo.layer.backgroundColor = UIColor.mathColor(UIColor())().CGColor
            } else {
                answerButtonTwo.layer.backgroundColor = UIColor.lightGrayColor().CGColor
            }
            
            answerButtonTwo.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            
            if answerButtonThree.titleLabel?.text == answerText {
                answerButtonThree.layer.backgroundColor = UIColor.mathColor(UIColor())().CGColor
            } else {
                answerButtonThree.layer.backgroundColor = UIColor.lightGrayColor().CGColor
            }
            
            answerButtonThree.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            
            if answerButtonFour.titleLabel?.text == answerText {
                answerButtonFour.layer.backgroundColor = UIColor.mathColor(UIColor())().CGColor
            } else {
                answerButtonFour.layer.backgroundColor = UIColor.lightGrayColor().CGColor
            }
            
            answerButtonFour.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            
            toggleButtons(false)
        }
    }
    
    func answerChallenge(button: UIButton) {
        if button.titleLabel?.text == answerText {
            button.layer.backgroundColor = UIColor.mathColor(UIColor())().CGColor
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            point = 1
        } else {
            button.layer.backgroundColor = UIColor.bioColor(UIColor())().CGColor
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            point = 0
        }
        updateChallenge()
    }
    
    func toggleButtons(toggle: Bool) {
        answerButtonOne.userInteractionEnabled = toggle
        answerButtonTwo.userInteractionEnabled = toggle
        answerButtonThree.userInteractionEnabled = toggle
        answerButtonFour.userInteractionEnabled = toggle
    }
    
    func goToSourceSite() {
        self.performSegueWithIdentifier("SegueArticle", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueArticle" {
            let articleViewController = segue.destinationViewController as! ArticleViewController
            
            articleViewController.urlString  = source
        }
    }

    func setup() {
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        let screenHeight = UIScreen.mainScreen().bounds.height
        
       
        
        imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: screenHeight))
        imageView.image = UIImage(named: "background")
        imageView.contentMode = .ScaleAspectFill
        self.view.addSubview(imageView)
        
        visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        visualEffectView.frame = imageView.bounds
        imageView.addSubview(visualEffectView)
        
        challengeTextView.textColor = UIColor.whiteColor()
        challengeTextView.scrollEnabled = false
        challengeTextView.backgroundColor = UIColor.clearColor()
        challengeTextView.textAlignment = .Center
        challengeTextView.font = UIFont(name: "Helvetica-Light", size: screenWidth * 0.05)
        challengeTextView.sizeToFit()
  
        challengeTextView.editable = false
        self.view.addSubview(challengeTextView)
        
        answerButtonOne.backgroundColor = UIColor.whiteColor()
        answerButtonOne.layer.cornerRadius = 10
        answerButtonOne.setTitleColor(UIColor.blackColor(), forState: .Normal)
        answerButtonOne.addTarget(self, action: #selector(answerChallenge(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(answerButtonOne)
        
        answerButtonTwo.backgroundColor = UIColor.whiteColor()
        answerButtonTwo.layer.cornerRadius = 10
        answerButtonTwo.setTitleColor(UIColor.blackColor(), forState: .Normal)
        answerButtonTwo.addTarget(self, action: #selector(answerChallenge(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(answerButtonTwo)
        
        answerButtonThree.backgroundColor = UIColor.whiteColor()
        answerButtonThree.layer.cornerRadius = 10
        answerButtonThree.setTitleColor(UIColor.blackColor(), forState: .Normal)
        answerButtonThree.addTarget(self, action: #selector(answerChallenge(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(answerButtonThree)
        
        answerButtonFour.backgroundColor = UIColor.whiteColor()
        answerButtonFour.layer.cornerRadius = 10
        answerButtonFour.setTitleColor(UIColor.blackColor(), forState: .Normal)
        answerButtonFour.addTarget(self, action: #selector(answerChallenge(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(answerButtonFour)
        
        discoverButton.setTitle("Article", forState: .Normal)
        discoverButton.layer.borderColor = UIColor.whiteColor().CGColor
        discoverButton.layer.borderWidth = 0.5
        discoverButton.layer.cornerRadius = 10
        discoverButton.layer.backgroundColor = UIColor.clearColor().CGColor
        discoverButton.titleLabel?.font = UIFont(name: "Pacifico-Regular", size: screenWidth * 0.05)
        discoverButton.addTarget(self, action: #selector(goToSourceSite), forControlEvents: .TouchUpInside)
        self.view.addSubview(discoverButton)
        
        circleView = UIView(frame: CGRect(x: screenWidth*0.05, y: screenWidth*0.05, width: screenWidth*0.05, height: screenWidth*0.05))
        circleView.layer.backgroundColor = color.CGColor
        circleView.layer.cornerRadius = screenWidth*0.025
        self.view.addSubview(circleView)
        
        titleTextView = UITextView(frame: CGRect(x: screenWidth*0.11, y: screenWidth*0.025, width: screenWidth*0.4, height: screenWidth*0.1))
        titleTextView.text = "Source"
        titleTextView.font = UIFont(name: "Pacifico-Regular", size: screenWidth * 0.035)
        titleTextView.textColor = UIColor.whiteColor()
        titleTextView.layer.backgroundColor = UIColor.clearColor().CGColor
        self.view.addSubview(titleTextView)
        
        updateViewConstraints()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        let screenHeight = UIScreen.mainScreen().bounds.height
        let screenWidth = UIScreen.mainScreen().bounds.width
        
        challengeTextView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(screenHeight * 0.07)
            make.width.equalTo(screenWidth * 0.8)
            make.centerX.equalTo(self.view.snp_centerX)
        }
        
        answerButtonOne.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(44)
            make.width.equalTo(screenWidth * 0.6)
            make.top.equalTo(self.challengeTextView.snp_bottom).offset(10)
            make.centerX.equalTo(self.view.snp_centerX)
        }
        
        answerButtonTwo.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(44)
            make.width.equalTo(screenWidth * 0.6)
            make.top.equalTo(self.answerButtonOne.snp_bottom).offset(10)
            make.centerX.equalTo(self.view.snp_centerX)
        }
        
        answerButtonThree.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(44)
            make.width.equalTo(screenWidth * 0.6)
            make.top.equalTo(self.answerButtonTwo.snp_bottom).offset(10)
            make.centerX.equalTo(self.view.snp_centerX)
        }
        
        answerButtonFour.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(44)
            make.width.equalTo(screenWidth * 0.6)
            make.top.equalTo(self.answerButtonThree.snp_bottom).offset(10)
            make.centerX.equalTo(self.view.snp_centerX)
        }
        
        discoverButton.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(44)
            make.width.equalTo(screenWidth * 0.6)
            make.top.equalTo(self.answerButtonFour.snp_bottom).offset(20)
            make.centerX.equalTo(challengeTextView.snp_centerX)
        }
    }
  
    

}
