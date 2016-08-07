//
//  BrainView.swift
//  iChallenge
//
//  Created by Admin on 7/29/16.
//  Copyright © 2016 AAkash. All rights reserved.
//

import UIKit
import Parse

class BrainView: UIView {
    
    var brainImage = UIImageView()
    var earthImage = UIImageView()
    var earthView = UIView()
    var brainImageFill = UIImageView()
    var backView = UIView()
    var profileNameLabel = UILabel()
    var acceptedLabel = UILabel()
    var failedLabel = UILabel()
    var totalLabel = UILabel()
    var acceptedTextLabel = UILabel()
    var successTextLabel = UILabel()
    var failTextLabel = UILabel()
    var statsLabel = UILabel()
    var statsLabelBlue = UILabel()
    
    let screenHeight = UIScreen.mainScreen().bounds.height
    let screenWidth = UIScreen.mainScreen().bounds.width
    var score = 0
    
    var cir1 = UIView()
    var cir2 = UIView()
    var cir3 = UIView()

    var timer = NSTimer()
    var increment = 0
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        setup()
    }
    
    func setup() {
        
        self.backgroundColor = UIColor.clearColor()
        
        statsLabel = UILabel(frame: CGRect(x: screenWidth*0.21, y: screenHeight*0.2, width: screenWidth*0.58, height: screenHeight*0.3))
        statsLabel.text = "Challenger"
        statsLabel.lineBreakMode = .ByClipping
        statsLabel.textColor = UIColor.whiteColor()
        statsLabel.font = UIFont(name: "Pacifico-Regular", size: screenWidth * 0.13)
        self.addSubview(statsLabel)
        
        statsLabelBlue = UILabel(frame: CGRect(x: screenWidth*0.21, y: screenHeight*0.2, width: 0, height: screenHeight*0.3))
        statsLabelBlue.text = "Challenger"
        statsLabelBlue.lineBreakMode = .ByClipping
        statsLabelBlue.textColor = UIColor(red: 0/255, green: 166/255, blue: 227/255, alpha: 1.0)
        statsLabelBlue.font = UIFont(name: "Pacifico-Regular", size: screenWidth * 0.13)
        self.addSubview(statsLabelBlue)
        
        acceptedLabel = UILabel(frame: CGRect(x: screenWidth*0.025, y: screenHeight*0.45, width: screenWidth*0.3, height: screenHeight*0.1))
        acceptedLabel.text = "0%"
        acceptedLabel.textAlignment = .Center
        acceptedLabel.textColor = UIColor.whiteColor()
        acceptedLabel.font = UIFont(name: "Pacifico-Regular", size: screenWidth * 0.07)
        self.addSubview(acceptedLabel)
        
        acceptedTextLabel = UILabel(frame: CGRect(x: screenWidth*0.025, y: screenHeight*0.5, width: screenWidth*0.3, height: screenHeight*0.1))
        acceptedTextLabel.text = "Completed"
        acceptedTextLabel.textAlignment = .Center
        acceptedTextLabel.textColor = UIColor.whiteColor()
        acceptedTextLabel.font = UIFont(name: "Pacifico-Regular", size: screenWidth * 0.04)
        self.addSubview(acceptedTextLabel)
        
        failedLabel = UILabel(frame: CGRect(x: screenWidth*0.35, y: screenHeight*0.45, width: screenWidth*0.3, height: screenHeight*0.1))
        failedLabel.text = "0%"
        failedLabel.textAlignment = .Center
        failedLabel.textColor = UIColor.whiteColor()
        failedLabel.font = UIFont(name: "Pacifico-Regular", size: screenWidth * 0.07)
        self.addSubview(failedLabel)
        
        successTextLabel = UILabel(frame: CGRect(x: screenWidth*0.35, y: screenHeight*0.5, width: screenWidth*0.3, height: screenHeight*0.1))
        successTextLabel.text = "Succeeded"
        successTextLabel.textAlignment = .Center
        successTextLabel.textColor = UIColor.whiteColor()
        successTextLabel.font = UIFont(name: "Pacifico-Regular", size: screenWidth * 0.04)
        self.addSubview(successTextLabel)
        
        totalLabel = UILabel(frame: CGRect(x: screenWidth*0.675, y: screenHeight*0.45, width: screenWidth*0.3, height: screenHeight*0.1))
        totalLabel.text = "0%"
        totalLabel.textAlignment = .Center
        totalLabel.textColor = UIColor.whiteColor()
        totalLabel.font = UIFont(name: "Pacifico-Regular", size: screenWidth * 0.07)
        self.addSubview(totalLabel)
        
        failTextLabel = UILabel(frame: CGRect(x: screenWidth*0.675, y: screenHeight*0.5, width: screenWidth*0.3, height: screenHeight*0.1))
        failTextLabel.text = "Failed"
        failTextLabel.textAlignment = .Center
        failTextLabel.textColor = UIColor.whiteColor()
        failTextLabel.font = UIFont(name: "Pacifico-Regular", size: screenWidth * 0.04)
        self.addSubview(failTextLabel)
        
        /*
 
        brainImageFill = UIImageView(frame: CGRect(x: screenWidth*0.3, y: screenHeight*0.15, width: screenWidth*0.5, height: screenHeight*0.4))
        brainImageFill.image = UIImage(named: "brainfill")
        brainImageFill.contentMode = .ScaleAspectFit
        self.addSubview(brainImageFill)
        
        backView = UIImageView(frame: CGRect(x: screenWidth*0.3, y: screenHeight*0.15, width: screenWidth*0.4, height: screenHeight*0.4))
        backView.backgroundColor = UIColor.blackColor()
        self.addSubview(backView)
        
        brainImage = UIImageView(frame: CGRect(x: screenWidth*0.25, y: screenHeight*0.15, width: screenWidth*0.5, height: screenHeight*0.4))
        brainImage.image = UIImage(named: "brain")
        brainImage.contentMode = .ScaleAspectFit
        self.addSubview(brainImage)
        
        */

    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
