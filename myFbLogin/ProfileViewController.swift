//
//  ProfileViewController.swift
//  myFbLogin
//
//  Created by Raghav Nyati on 11/30/16.
//  Copyright © 2016 Raghav Nyati. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKCoreKit
import FirebaseStorage
import Firebase

class ProfileViewController: UIViewController {

    var viewController: UIViewController!
    
    //MARK:- Properties
    
    @IBOutlet weak var uiImageView: UIImageView!
    @IBOutlet weak var uiLabelView: UILabel!
    @IBOutlet weak var uiEmailLabelView: UILabel!
    
    
    @IBAction func didTapLogout(_ sender: Any) {
        //Signs the users out from the firebase auth
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            AppState.sharedInstance.signedIn = false
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        //signs the user out from facebook
        FBSDKAccessToken.setCurrent(nil)
        
        //take user back to login screen
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginView") as UIViewController
        self.perform(#selector(self.presentViewController), with: nil, afterDelay: 0.0)
    }
    
    func presentViewController(){
        self.present(viewController, animated: true, completion: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Profile View Controller Loaded.")
        
        //self.uiImageView.layer.cornerRadius = self.uiImageView.frame.size.width/2
        self.uiImageView.clipsToBounds = true
        
        if FIRAuth.auth()?.currentUser != nil {
            // User is signed in.
            let user = FIRAuth.auth()?.currentUser
            let email = user?.email
            //let uid = user?.uid
            let photoURL = user?.photoURL
            let name = user?.displayName
            
            self.uiLabelView.text = name
            self.uiEmailLabelView.text = email
            if let photo = photoURL {
                let data = NSData(contentsOf: photo)
                self.uiImageView.image = UIImage(data: data! as Data)
            }
           
        } else {
            print("User not Signed In.")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 

}
