//
//  ViewController.swift
//  FBLoginRatanak
//
//  Created by Raksmey on 11/29/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import FacebookShare

class ViewController: UIViewController, FBSDKLoginButtonDelegate, FBSDKSharingDelegate {

    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBSDKLoginButton()
        
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
        loginButton.delegate = self
        //permission to get email
        loginButton.readPermissions = ["email","public_profile"]
        isHideElement(b: true)
    
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        isHideElement(b: true)
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error == nil{
            
            //request to facebook
            // /me path of fb
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id, email, gender, name"]).start(completionHandler: { (connection, results, error) in
                if error == nil {
                    self.isHideElement(b: false)
                    let user:[String:Any] = results as! [String:Any]
                    let fid = user["id"]
                    self.usernameLabel.text = user["name"] as! String?
                    self.emailLabel.text = user["email"] as! String?
                    self.genderLabel.text = user["gender"] as! String?
                    let url = URL(string: "https://graph.facebook.com/\(fid!)/picture?type=large")
                    let data = try? Data(contentsOf: url!)
                    self.profileImageView.image = UIImage(data: data!)

            
                }
                
            })
            
            //==========custom share button============
            let content: FBSDKShareLinkContent = FBSDKShareLinkContent()
            content.contentURL = URL(string: "https://developers.facebook.com/docs/ios")
            let shareButton = FBSDKShareButton(frame: CGRect(x: self.view.bounds.width/2 - 125, y: 400, width: 100, height: 30))
            shareButton.shareContent = content
            self.view.addSubview(shareButton)
            //===========================================
        }
    }
    func isHideElement(b: Bool){
        self.profileImageView.isHidden = b
        self.usernameLabel.isHidden = b
        self.emailLabel.isHidden = b
        self.genderLabel.isHidden = b
    }
    
    //==============================custom share page=================================
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
      
    }
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        print("erorr")
    }
    
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        print("cancel")
    }

}

