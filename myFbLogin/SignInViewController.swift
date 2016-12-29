//
//  ViewController.swift
//  myFbLogin
//
//  Created by Raghav Nyati on 11/30/16.
//  Copyright © 2016 Raghav Nyati. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth


class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    var viewController: UIViewController!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var loginButton = FBSDKLoginButton()
    var homeViewController: UIViewController!
    
    @IBOutlet weak var aivLoadingSpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginButton.isHidden = true
        
        if FIRAuth.auth()?.currentUser != nil {
            // User is signed in.
            // Move the user to the Home Screen
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "TabView") as! UITabBarController
            self.perform(#selector(self.presentHomeViewController), with: nil, afterDelay: 0.0)
            
        } else {
            // No user is signed in.
            // Show the user the Login Button
            self.loginButton.center = self.view.center
            self.loginButton.readPermissions = ["public_profile", "email", "user_friends"]
            self.loginButton.delegate = self
            self.view.addSubview(loginButton)
            self.loginButton.isHidden = false
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.hideKeyBoard))
        view.addGestureRecognizer(tap)
        
    }
    
    func hideKeyBoard(){
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let user = FIRAuth.auth()?.currentUser {
            self.signedIn(user)
        }
    }
    
    @IBAction func didTapSignIn(_ sender: Any) {
        // Sign In with credentials.
        if ((emailField.text?.isEmpty)! || (passwordField.text?.isEmpty)!){
            let alert = UIAlertController(title: "Invalid Fields", message: "Enter all details", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            guard let email = emailField.text, let password = passwordField.text else { return }
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
                if let error = error {
//                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                    self.viewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginView") as UIViewController
//                    //self.present(homeViewController, animated: true, completion: nil)
//                    //self.navigationController?.show(homeViewController, sender: nil)
//                    self.perform(#selector(self.presentViewController1), with: nil, afterDelay: 0.0)
                    print(error.localizedDescription)
                    return
                }
            self.signedIn(user!)
            }
        }
    }
    
    func presentViewController1(){
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func didTapSignUp(_ sender: Any) {
        
        if !(emailField.text?.isEmpty)! && !(passwordField.text?.isEmpty)!{
            guard let email = emailField.text, let password = passwordField.text else { return }
            FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                let alert = UIAlertController(title: "Success", message: "User Registered Sucessfully", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)

                self.setDisplayName(user!)
            }
        }
        else{
            let alert = UIAlertController(title: "Invalid Fields", message: "Enter all details", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func didRequestPasswordReset(_ sender: Any) {
        let prompt = UIAlertController.init(title: nil, message: "Email:", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default) { (action) in
            let userInput = prompt.textFields![0].text
            if (userInput!.isEmpty) {
                return
            }
            FIRAuth.auth()?.sendPasswordReset(withEmail: userInput!) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }
        }
        prompt.addTextField(configurationHandler: nil)
        prompt.addAction(okAction)
        present(prompt, animated: true, completion: nil);
    }
    
    func setDisplayName(_ user: FIRUser) {
        let changeRequest = user.profileChangeRequest()
        changeRequest.displayName = user.email!.components(separatedBy: "@")[0]
        changeRequest.commitChanges(){ (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.signedIn(FIRAuth.auth()?.currentUser)
        }
    }
    
    func signedIn(_ user: FIRUser?) {
        MeasurementHelper.sendLoginEvent()
        
        AppState.sharedInstance.displayName = user?.displayName ?? user?.email
        AppState.sharedInstance.photoURL = user?.photoURL
        AppState.sharedInstance.signedIn = true
        let notificationName = Notification.Name(rawValue: Constants.NotificationKeys.SignedIn)
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: nil)
        performSegue(withIdentifier: Constants.Segues.SignInToFp, sender: nil)
    }
    
    func presentHomeViewController(){
        self.present(homeViewController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        print("user logged in.")
        
        loginButton.isHidden = true
        aivLoadingSpinner.startAnimating()
        
        if error != nil {
            print("**** Firebase Auth ERROR ****")
            //print(error!)
            self.loginButton.isHidden = false
            aivLoadingSpinner.stopAnimating()
        }
        else if(result.isCancelled){
            self.loginButton.isHidden = false
            aivLoadingSpinner.stopAnimating()
        }
        else{
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                print("Usr logged in to Fireabse Auth.")
                self.aivLoadingSpinner.stopAnimating()
                self.signedIn(user)
            }
        }
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("user logged out.")
    }

}

