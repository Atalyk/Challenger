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

class LoginViewController: UIViewController {
    
    lazy var usernameTextfield = UITextField()
    lazy var passwordTextfield = UITextField()
    lazy var loginView = UIView()
    lazy var loginLine = UIView()
    lazy var signInButton = UIButton()
    lazy var signUpButton = UIButton()
    lazy var resetPasswordButton = UIButton()
    lazy var messageLabel = UILabel()
    lazy var appLabel = UILabel()
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
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
        
        usernameTextfield.placeholder = "Username"
        usernameTextfield.textAlignment = .Left
        usernameTextfield.font = UIFont(name: "Helvetica Neue", size: 14)
        
        passwordTextfield.placeholder = "Password"
        passwordTextfield.textAlignment = .Left
        passwordTextfield.secureTextEntry = true
        passwordTextfield.font = UIFont(name: "Helvetica Neue", size: 14)
        
        let buttonColor = UIColor(red: 0/255, green: 166/255, blue: 227/255, alpha: 1.0)
        signInButton.backgroundColor = buttonColor
        signInButton.setTitle("Sign In", forState: .Normal)
        signInButton.layer.cornerRadius = 10
        signInButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 14)
        signInButton.titleLabel?.textAlignment = .Center
        signInButton.addTarget(self, action: #selector(LoginViewController.loginUser), forControlEvents: .TouchUpInside)
        
        resetPasswordButton.setTitle("Forgot Password?", forState: .Normal)
        resetPasswordButton.titleLabel?.font = UIFont(name: "Helvetica", size: 14)
        resetPasswordButton.titleLabel?.textAlignment = .Center
        resetPasswordButton.addTarget(self, action: #selector(LoginViewController.resetPasswordButtonPressed), forControlEvents: .TouchUpInside)
        
        signUpButton.setTitle("New Member? Sign Up!", forState: .Normal)
        signUpButton.titleLabel?.font = UIFont(name: "Helvetica", size: 14)
        signUpButton.titleLabel?.textAlignment = .Center
        signUpButton.addTarget(self, action: #selector(LoginViewController.signUpButtonPressed), forControlEvents: .TouchUpInside)
        
        messageLabel.text = ""
        messageLabel.textColor = UIColor.whiteColor()
        messageLabel.textAlignment = .Center
        messageLabel.font = UIFont(name: "Helvetica Neue", size: 10)
        
        appLabel.text = "Challenger"
        appLabel.textColor = UIColor.whiteColor()
        appLabel.textAlignment = .Center
        appLabel.font = UIFont(name: "Pacifico-Regular", size: screenWidth*0.1)
        
        loginLine.backgroundColor = UIColor.grayColor()
        
        
        self.view.addSubview(loginView)
        self.view.addSubview(loginLine)
        self.view.addSubview(usernameTextfield)
        self.view.addSubview(resetPasswordButton)
        self.view.addSubview(passwordTextfield)
        self.view.addSubview(signInButton)
        self.view.addSubview(signUpButton)
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
            make.height.equalTo(70)
            make.width.equalTo(screenWidth * 0.7)
        }
        
        loginLine.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.loginView.snp_centerX)
            make.centerY.equalTo(self.loginView.snp_centerY)
            //make.height.equalTo(0.3)
            make.width.equalTo(loginView.snp_width)
        }
        
        usernameTextfield.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.loginView.snp_centerX).offset(20)
            make.top.equalTo(self.loginView.snp_top)
            make.height.equalTo(35)
            make.width.equalTo(self.loginView.snp_width).offset(15)
        }
        
        passwordTextfield.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.loginView.snp_centerX).offset(20)
            make.top.equalTo(self.usernameTextfield.snp_bottom)
            make.height.equalTo(35)
            make.width.equalTo(self.loginView.snp_width).offset(15)
        }
        
        signInButton.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.loginView.snp_centerX)
            make.top.equalTo(self.loginView.snp_bottom).offset(15)
            make.width.equalTo(self.loginView.snp_width)
            make.height.equalTo(30)
        }
        
        resetPasswordButton.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.loginView.snp_centerX)
            make.top.equalTo(self.signInButton.snp_bottom).offset(15)
            make.width.equalTo(self.loginView.snp_width)
            make.height.equalTo(30)
        }
        
        messageLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.loginView.snp_centerX)
            make.top.equalTo(self.signInButton.snp_bottom).offset(20)
        }
        
        appLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.loginView.snp_centerX)
            make.top.equalTo(screenHeight*0.2)
        }
        
        signUpButton.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.loginView.snp_centerX)
            make.width.equalTo(self.loginView.snp_width)
            make.height.equalTo(35)
            make.top.equalTo(self.signInButton.snp_bottom).offset(100)
        }
    }
    
    func signUpButtonPressed() {
        let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Register")
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func resetPasswordButtonPressed() {
        let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ResetPassword")
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func loginUser() {
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
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}
