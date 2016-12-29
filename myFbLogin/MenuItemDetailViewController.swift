//
//  MenuItemDetailViewController.swift
//  myFbLogin
//
//  Created by Raghav Nyati on 12/15/16.
//  Copyright © 2016 Raghav Nyati. All rights reserved.
//

import UIKit

class MenuItemDetailViewController: UIViewController {

    var passedValue: Int!
    var menuItem: String!
    var itemPrice: Float!
    var itemImage: UIImage!
    var itemDesc: String!
    var i: Int!
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemDescription: UITextView!
    @IBOutlet weak var quantityValue: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
   
    @IBAction func addQuantity(_ sender: Any) {
        let val = Int(quantityValue.text!)
        if let value = val {
        quantityValue.text = String(value + 1)
        }
    }
    
    @IBAction func decreaseQty(_ sender: Any) {
        let val = Int(quantityValue.text!)
        if let value = val {
            if value > 1{
        quantityValue.text = String(value - 1)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let n = passedValue
        i = Int(n!)
        //print(n)
        print(menuItem)
        print(itemPrice)
        
        itemNameLabel.text = menuItem
        itemPriceLabel.text = "$"+String(itemPrice)
        itemImageView.image = itemImage
        itemDescription.text = itemDesc
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didAddToCartTapped(_ sender: Any) {
    }
    var itemList = [String]();
    var priceList = [Float]();
    var qtyList = [Float]();
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        _ = segue.destination as! CartViewController
        HomeViewController.GlobalVariable.myStruct.append(menuItem);
        HomeViewController.GlobalVariable.price.append(itemPrice);
        HomeViewController.GlobalVariable.qty.append(Float(quantityValue.text!)!)
    }

}
