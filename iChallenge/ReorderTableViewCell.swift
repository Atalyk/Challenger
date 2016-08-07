//
//  ReorderTableViewCell.swift
//  iChallenge
//
//  Created by Admin on 8/7/16.
//  Copyright © 2016 AAkash. All rights reserved.
//

import UIKit
import SnapKit

class ReorderTableViewCell: UITableViewCell {
        
        lazy var challengeLabel = UILabel()
        lazy var circleView = UIView()
    
        let screenWidth = UIScreen.mainScreen().bounds.width
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setup() {
            
            self.layer.backgroundColor = UIColor.grayColor().CGColor
            
            circleView.layer.cornerRadius = screenWidth*0.02
            self.contentView.addSubview(circleView)
            
            challengeLabel.text = "Hello"
            self.contentView.addSubview(challengeLabel)
            updateConstraints()
        }
        
        override func updateConstraints() {
            super.updateConstraints()
            
            challengeLabel.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(0)
                make.left.equalTo(screenWidth*0.1)
                make.bottom.equalTo(self.contentView.snp_bottom)
                make.width.equalTo(self.contentView.snp_width)
                make.height.equalTo(self.contentView.bounds.height)
            }
            
            circleView.snp_makeConstraints { (make) in
                make.left.equalTo(5)
                make.width.equalTo(screenWidth*0.04)
                make.height.equalTo(screenWidth*0.04)
                make.centerY.equalTo(self.challengeLabel.snp_centerY)
            }
        }
        
}