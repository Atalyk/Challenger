//
//  ArticleViewController.swift
//  iChallenge
//
//  Created by Admin on 8/8/16.
//  Copyright © 2016 AAkash. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ArticleViewController: UIViewController , UIWebViewDelegate{
    
    var articleWebView = UIWebView()
    var urlString: String!
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    
    let screenBounds = UIScreen.mainScreen().bounds

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.title = "Article"
        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        let attributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "Pacifico-Regular", size: screenWidth*0.05)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes

        setup()
        
        activityIndicatorView.startAnimation()
        
        articleWebView.delegate = self
        
        let url = NSURL (string: urlString)
        let requestObj = NSURLRequest(URL: url!);
        articleWebView.loadRequest(requestObj)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        activityIndicatorView.stopAnimation()
    }

    
    func setup() {
        
        activityIndicatorView.bounds = CGRect(x: -screenBounds.width*0.5+25, y: -screenBounds.height*0.5+25, width: 50, height: 50)
        
        activityIndicatorView.type = .BallPulse
        activityIndicatorView.color = UIColor.blackColor()
        
        articleWebView = UIWebView(frame: CGRect(x: 0, y: 0, width: screenBounds.width, height: screenBounds.height))
        self.view.addSubview(articleWebView)
    }

}
