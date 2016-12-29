//
//  CheckoutViewController.swift
//  myFbLogin
//
//  Created by Raghav Nyati on 12/16/16.
//  Copyright © 2016 Raghav Nyati. All rights reserved.
//

import UIKit
import Firebase

class CheckoutViewController: UIViewController {

    var totalPrice: Float!
    
    let cartRef = FIRDatabase.database().reference().child("cart")
    
//    @IBOutlet weak var currentDateView: UILabel!
//    @IBOutlet weak var currentTimeView: UILabel!
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    
    var pickupDate: Date!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    
    var homeViewController: UIViewController!
    
    //var #imageLiteral(resourceName: "date") = Date()
    
    //dateFormatter.timeStyle = .MediumStyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if dateTimePicker != nil {
            var now = Date()
            now = now.addingTimeInterval(60.0 * 60.0)
            dateTimePicker!.setDate(now, animated: true)
            dateTimePicker.minimumDate = now
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CheckoutViewController.hideKeyBoard))
        view.addGestureRecognizer(tap)
        
    }

    func hideKeyBoard(){
    view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        cartRef.observe(.value) { (snap: FIRDataSnapshot) in
            //self.testLabel.text = (snap.value as AnyObject).description
        }
    }
    
    func post(){
        let name = nameTextField.text
        let mobile = mobileTextField.text
        let email = emailTextField.text
        let currentDate = String(describing: Date())
        let pickupDate = String(describing: dateTimePicker.date)
        
        //for i in 0 ..< HomeViewController.GlobalVariable.myStruct
        
        let posts: [String : AnyObject] = ["name":name as AnyObject, "mobile":mobile as AnyObject, "email":email as AnyObject, "currentDate":currentDate as AnyObject, "pickupDate":pickupDate as AnyObject, "orderItems": HomeViewController.GlobalVariable.myStruct as AnyObject, "qty":HomeViewController.GlobalVariable.qty as AnyObject]
        
        cartRef.childByAutoId().setValue(posts)
        print("Posting value ")
    }
    
    @IBAction func checkoutClicked(_ sender: Any) {
        if(totalPrice > 0.00){
           
            if !(nameTextField.text?.isEmpty)! && !(mobileTextField.text?.isEmpty)! && !(emailTextField.text?.isEmpty)!{
                 post()
                var alertController = UIAlertController(title: "Success!", message: "Your order is scheduled for Pickup.", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                    //run your function here
                    self.homeScreen()
                }))
                self.present(alertController, animated: true, completion: nil)
                HomeViewController.GlobalVariable.myStruct.removeAll()
                HomeViewController.GlobalVariable.price.removeAll()
                HomeViewController.GlobalVariable.qty.removeAll()
            }
            else{
                let alert = UIAlertController(title: "Invalid Fields", message: "Enter all details", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else{
            let alert = UIAlertController(title: "Invalid Order", message: "Your cart is empty.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func homeScreen(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "TabView") as! UITabBarController
       
        self.perform(#selector(self.presentHomeViewController), with: nil, afterDelay: 0.0)
    }
    
    func presentHomeViewController(){
        self.present(homeViewController, animated: true, completion: nil)
    }
    
    @IBAction func dateSelected() {
        let selected: Date = dateTimePicker!.date
        print(selected)
    }
    
    @IBAction func dateChanged(_ sender: Any) {
        let newDate:Date = (sender as AnyObject).date
        print(newDate)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
