//
//  LoginViewController.swift
//  Poster
//
//  Created by Admin on 6/15/16.
//  Copyright © 2016 AAkash. All rights reserved.
//

import UIKit
import SnapKit
import Parse

class ResetViewController: UIViewController {
    
    lazy var emailTextfield = UITextField()
    lazy var loginView = UIView()
    lazy var resetPasswordButton = UIButton()
    lazy var signInButton = UIButton()
    lazy var messageLabel = UILabel()
    lazy var appLabel = UILabel()
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ResetViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    //Pacifico-Regular
    
    func setup() {
        _ = UIColor(red: 0/255, green: 175/255, blue: 240/255, alpha: 1.0)
        self.view.backgroundColor = UIColor.blackColor()
        loginView.backgroundColor = UIColor.whiteColor()
        loginView.layer.cornerRadius = 10
        loginView.layer.shadowColor = UIColor.blueColor().CGColor
        loginView.layer.shadowOpacity = 0.1
        loginView.layer.shadowRadius = 10
        
        emailTextfield.placeholder = "Email"
        emailTextfield.textAlignment = .Left
        emailTextfield.font = UIFont(name: "Helvetica Neue", size: 14)
        
        let buttonColor = UIColor(red: 0/255, green: 166/255, blue: 227/255, alpha: 1.0)
        resetPasswordButton.backgroundColor = buttonColor
        resetPasswordButton.setTitle("Reset Password", forState: .Normal)
        resetPasswordButton.layer.cornerRadius = 10
        resetPasswordButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 14)
        resetPasswordButton.titleLabel?.textAlignment = .Center
        resetPasswordButton.addTarget(self, action: #selector(ResetViewController.resetPassword), forControlEvents: .TouchUpInside)
        
        signInButton.setTitle("Already have an account? Sign In", forState: .Normal)
        signInButton.titleLabel?.font = UIFont(name: "Helvetica", size: 14)
        signInButton.titleLabel?.textAlignment = .Center
        signInButton.addTarget(self, action: #selector(ResetViewController.signInButtonPressed), forControlEvents: .TouchUpInside)
        
        messageLabel.text = ""
        messageLabel.textColor = UIColor.whiteColor()
        messageLabel.textAlignment = .Center
        messageLabel.font = UIFont(name: "Helvetica Neue", size: 10)
        
        appLabel.text = "Challenger"
        appLabel.textColor = UIColor.whiteColor()
        appLabel.textAlignment = .Center
        appLabel.font = UIFont(name: "Pacifico-Regular", size: screenWidth*0.1)
   
        
        self.view.addSubview(loginView)
        self.view.addSubview(emailTextfield)
        self.view.addSubview(resetPasswordButton)
        self.view.addSubview(signInButton)
        self.view.addSubview(messageLabel)
        self.view.addSubview(appLabel)
        
        updateViewConstraints()
        
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        
        /*
         usernameTextfield.snp_makeConstraints { (make) -> Void in
         make.centerX.equalTo(self.view)
         make.top.equalTo(screenHeight * 0.3)
         make.height.equalTo(44)
         make.width.equalTo(screenWidth * 0.7)
         }
         */
        
        loginView.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.top.equalTo(screenHeight * 0.35)
            make.height.equalTo(35)
            make.width.equalTo(screenWidth * 0.7)
        }
        
        emailTextfield.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.loginView.snp_centerX).offset(20)
            make.top.equalTo(self.loginView.snp_top)
            make.height.equalTo(35)
            make.width.equalTo(self.loginView.snp_width).offset(15)
        }
        
        resetPasswordButton.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.loginView.snp_centerX)
            make.top.equalTo(self.loginView.snp_bottom).offset(15)
            make.width.equalTo(self.loginView.snp_width)
            make.height.equalTo(30)
        }
        
        messageLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.loginView.snp_centerX)
            make.top.equalTo(self.resetPasswordButton.snp_bottom).offset(20)
        }
        
        appLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.loginView.snp_centerX)
            make.top.equalTo(screenHeight*0.2)
        }
        
        signInButton.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.loginView.snp_centerX)
            make.width.equalTo(self.loginView.snp_width)
            make.height.equalTo(35)
            make.top.equalTo(self.resetPasswordButton.snp_bottom).offset(100)
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func signInButtonPressed() {
        let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func resetPassword() {
        PFUser.requestPasswordResetForEmailInBackground((emailTextfield.text?.lowercaseString)!) {
            (success: Bool, error: NSError?) -> Void in
            if error == nil {
                self.messageLabel.text = "The request is sent"
            } else {
                self.messageLabel.text = String(error)
            }
        }
    }
    
}
