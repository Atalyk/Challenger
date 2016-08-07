//
//  ChallengeCollectionViewCell.swift
//  iChallenge
//
//  Created by Admin on 6/24/16.
//  Copyright © 2016 AAkash. All rights reserved.
//

import UIKit
import SnapKit

class ChallengeCollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var sourceLabel: UILabel!
    var challengeLabel: UILabel!
    var shareButton: UIButton!
    var likeButton: UIButton!
    var layerView: UIView!
    var textView: UITextView!
    var circleView: UIView!
    var challengeBackgroundView = UIView()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        let screenWidth = self.contentView.bounds.width
        let screenHeight = self.contentView.bounds.height
        
        let buttonColor = UIColor(red: 0/255, green: 166/255, blue: 227/255, alpha: 1.0)
        
        imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: self.contentView.bounds.width, height: self.contentView.bounds.height))
        imageView.contentMode = UIViewContentMode.ScaleToFill
        contentView.addSubview(imageView)
        
        layerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.imageView.bounds.width, height: self.imageView.bounds.height))
        layerView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        contentView.addSubview(layerView)
        
        textView = UITextView(frame: CGRect(x: 0, y: screenHeight * 0.3, width: screenWidth, height: screenHeight * 0.3))
        textView.text = "Literature"
        textView.textColor = UIColor.whiteColor()
        textView.layer.backgroundColor = UIColor.clearColor().CGColor
        textView.textAlignment = NSTextAlignment.Center
        textView.font = UIFont(name: "AvenirNext-Bold", size: self.contentView.bounds.width * 0.1)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.editable = false
        contentView.addSubview(textView)
        
        challengeBackgroundView = UILabel(frame: CGRect(x: screenWidth * 0.33, y: screenHeight * 0.6, width: screenWidth * 0.3, height: screenHeight * 0.09))
        challengeBackgroundView.layer.backgroundColor = buttonColor.CGColor
        contentView.addSubview(challengeBackgroundView)
        
        challengeLabel = UILabel(frame: CGRect(x: screenWidth * 0.33, y: screenHeight * 0.6, width: screenWidth * 0.3, height: screenHeight * 0.09))
        challengeLabel.text = "CHALLENGED"
        challengeLabel.font = UIFont(name: "Helvetica-Light", size: self.contentView.bounds.width * 0.035)
        challengeLabel.textAlignment = .Center
        challengeLabel.textColor = UIColor.whiteColor()
        contentView.addSubview(challengeLabel)
        
        circleView = UIView(frame: CGRect(x: screenWidth*0.05, y: screenWidth*0.05, width: screenWidth*0.05, height: screenWidth*0.05))
        circleView.layer.backgroundColor = UIColor.greenColor().CGColor
        circleView.layer.cornerRadius = screenWidth*0.025
        contentView.addSubview(circleView)
        
        sourceLabel = UILabel(frame: CGRect(x: screenWidth*0.12, y: screenWidth*0.05, width: screenWidth*0.5, height: screenWidth*0.05))
        sourceLabel.font = UIFont(name: "Pacifico-Regular", size: self.contentView.bounds.width * 0.035)
        sourceLabel.textColor = UIColor.whiteColor()
        contentView.addSubview(sourceLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
