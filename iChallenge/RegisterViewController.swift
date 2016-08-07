//
//  SignUpViewController.swift
//  Poster
//
//  Created by Admin on 6/15/16.
//  Copyright © 2016 AAkash. All rights reserved.
//

import UIKit
import Parse

class RegisterViewController: UIViewController {
    
    lazy var usernameTextfield = UITextField()
    lazy var passwordTextfield = UITextField()
    lazy var emailTextfield = UITextField()
    lazy var signUpView = UIView()
    lazy var separateLine = UIView()
    lazy var signUpButton = UIButton()
    lazy var loginButton = UIButton()
    lazy var messageLabel = UILabel()
    lazy var appLabel = UILabel()
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //keyboardDidShow
        setup()
    }
    
    override func viewWillAppear(animated: Bool) {
        usernameTextfield.text = ""
        passwordTextfield.text = ""
        emailTextfield.text = ""
        messageLabel.text = ""
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    
    func registerUserAsync() {
        
        // Add email address validation
        
        // Create the user
        let user = PFUser()
        user.username = usernameTextfield.text?.lowercaseString
        user.password = passwordTextfield.text
        user.email = emailTextfield.text?.lowercaseString
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if error == nil {
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.loginUserAsync()
                }
            } else {
                if let message: AnyObject = error!.userInfo["error"] {
                    self.messageLabel.text = "\(message)"
                }				
            }
        }
    }
    
    func loginUserAsync() {
        PFUser.logInWithUsernameInBackground(usernameTextfield.text!.lowercaseString, password: passwordTextfield.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    let VC1 = self.storyboard!.instantiateViewControllerWithIdentifier("Feed")
                    let navController = UINavigationController(rootViewController: VC1) // Creating a navigation controller with VC1 at the root of the navigation stack.
                    self.presentViewController(navController, animated:true, completion: nil)
                }
            } else {
                
                if let message: AnyObject = error!.userInfo["error"] {
                    self.messageLabel.text = "\(message)"
                }
            }
        }
    }
    
    func loginPageLoad() {
        print("alreadt malready")
        dispatch_async(dispatch_get_main_queue()) {
            let VC1 = self.storyboard!.instantiateViewControllerWithIdentifier("Login")
            let navController = UINavigationController(rootViewController: VC1) // Creating a navigation controller with VC1 at the root of the navigation stack.
            self.presentViewController(navController, animated:true, completion: nil)
        }
    }
    
    func setup() {
    
        self.view.backgroundColor = UIColor.blackColor()
        
        signUpView.backgroundColor = UIColor.whiteColor()
        signUpView.layer.cornerRadius = 10
        signUpView.layer.shadowColor = UIColor.blueColor().CGColor
        signUpView.layer.shadowOpacity = 0.1
        signUpView.layer.shadowRadius = 10
        
        usernameTextfield.placeholder = "Username"
        usernameTextfield.font = UIFont(name: "Helvetica Neue", size: 14)
        
        passwordTextfield.placeholder = "Password"
        passwordTextfield.font = UIFont(name: "Helvetica Neue", size: 14)
        passwordTextfield.secureTextEntry = true
        
        emailTextfield.placeholder = "Email"
        emailTextfield.font = UIFont(name: "Helvetica Neue", size: 14)
        
        let buttonColor = UIColor(red: 0/255, green: 166/255, blue: 227/255, alpha: 1.0)
        signUpButton.backgroundColor = buttonColor
        signUpButton.setTitle("Sign Up", forState: .Normal)
        signUpButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 14)
        signUpButton.titleLabel?.textAlignment = .Center
        signUpButton.layer.cornerRadius = 10
        signUpButton.addTarget(self, action: #selector(registerUserAsync), forControlEvents: .TouchUpInside)
        
        loginButton.setTitle("Already have an account? Sign In", forState: .Normal)
        loginButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 14)
        loginButton.titleLabel?.textAlignment = .Center
        loginButton.titleLabel?.textColor = UIColor.whiteColor()
        loginButton.layer.cornerRadius = 20
        loginButton.addTarget(self, action: #selector(loginPageLoad), forControlEvents: .TouchUpInside)
        
        messageLabel.text = ""
        messageLabel.textColor = UIColor.whiteColor()
        messageLabel.textAlignment = .Center
        messageLabel.font = UIFont(name: "Helvetica Neue", size: 10)
        
        appLabel.text = "Challenger"
        appLabel.textColor = UIColor.whiteColor()
        appLabel.textAlignment = .Center
        appLabel.font = UIFont(name: "Pacifico-Regular", size: screenWidth*0.1)
        
        self.view.addSubview(signUpView)
        self.view.addSubview(usernameTextfield)
        self.view.addSubview(passwordTextfield)
        self.view.addSubview(emailTextfield)
        self.view.addSubview(signUpButton)
        self.view.addSubview(loginButton)
        self.view.addSubview(messageLabel)
        self.view.addSubview(appLabel)
        
        updateViewConstraints()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        let screenHeight = UIScreen.mainScreen().bounds.height
        
        signUpView.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.height.equalTo(105)
            make.top.equalTo(screenHeight * 0.35)
            make.width.equalTo(screenWidth * 0.7)
        }
        
        usernameTextfield.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(35)
            make.width.equalTo(self.signUpView.snp_width).offset(15)
            make.top.equalTo(self.signUpView.snp_top)
            make.centerX.equalTo(self.signUpView.snp_centerX).offset(20)
        }
        
        emailTextfield.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(35)
            make.width.equalTo(self.signUpView.snp_width).offset(15)
            make.top.equalTo(usernameTextfield.snp_bottom)
            make.centerX.equalTo(self.signUpView.snp_centerX).offset(20)
        }
        
        passwordTextfield.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(35)
            make.width.equalTo(self.signUpView.snp_width).offset(15)
            make.top.equalTo(emailTextfield.snp_bottom)
            make.centerX.equalTo(self.signUpView.snp_centerX).offset(20)
        }
        
        signUpButton.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.signUpView.snp_centerX)
            make.height.equalTo(35)
            make.top.equalTo(self.signUpView.snp_bottom).offset(15)
            make.width.equalTo(self.signUpView.snp_width)
        }
        
        loginButton.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.signUpView.snp_centerX)
            make.height.equalTo(35)
            make.top.equalTo(self.signUpButton.snp_bottom).offset(100)
            make.width.equalTo(self.signUpView.snp_width)
        }
        
        messageLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.signUpView.snp_centerX)
            make.top.equalTo(self.signUpButton.snp_bottom).offset(20)
        }
        
        appLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.signUpView.snp_centerX)
            make.top.equalTo(screenHeight*0.2)
        }
    }
    
}
