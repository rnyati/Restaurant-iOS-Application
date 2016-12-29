//
//  CartViewController.swift
//  myFbLogin
//
//  Created by Raghav Nyati on 12/15/16.
//  Copyright © 2016 Raghav Nyati. All rights reserved.
//

import UIKit

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
   
    //@IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalAmountLabel: UILabel!
    var itemList = [String]();
    var priceList = [Float]();
    var qtyList = [Float]();
    var originalPriceList = [Float]();
    var sum: Float = 0.0
    //var cartCell: CartItemTableViewCell!
    
    var combomMenu: [String] = [String]()
    
    
    let cellIdentifier = "CartIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0 ..< HomeViewController.GlobalVariable.myStruct.count {
            if(!itemList.contains(HomeViewController.GlobalVariable.myStruct[i])){
             itemList.append(HomeViewController.GlobalVariable.myStruct[i])
             originalPriceList.append(HomeViewController.GlobalVariable.price[i])
             priceList.append(HomeViewController.GlobalVariable.qty[i] * HomeViewController.GlobalVariable.price[i])
             qtyList.append(HomeViewController.GlobalVariable.qty[i])
            }
            else{
                let indexOfA = itemList.index(of: HomeViewController.GlobalVariable.myStruct[i])
                qtyList[indexOfA!] = HomeViewController.GlobalVariable.qty[i]
                priceList[indexOfA!] = HomeViewController.GlobalVariable.qty[i] * HomeViewController.GlobalVariable.price[i]
            }
        }
        for i in 0 ..< itemList.count{
            sum = sum + priceList[i]
        }
        HomeViewController.GlobalVariable.myStruct=itemList
        HomeViewController.GlobalVariable.price=originalPriceList
        HomeViewController.GlobalVariable.qty=qtyList
        totalAmountLabel.text = "$"+String(format: "%.2f", sum)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        reloadData()
    }

    func reloadData(){
        DispatchQueue.global(qos: .userInitiated).async {
            // Bounce back to the main thread to update the UI
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CartItemTableViewCell
        
        cell.itemNameLabelView.text =  itemList[indexPath.row]
        cell.priceLabelView.text = "$"+String(priceList[indexPath.row])
        cell.quantityLabelView.text = String(Int(qtyList[indexPath.row]))
        return cell
        //return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let row = indexPath.row
        print(row)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            
            let item = itemList[indexPath.row]
            itemList.remove(at: indexPath.row)
            priceList.remove(at: indexPath.row)
            qtyList.remove(at: indexPath.row)
            self.tableView.reloadData()
            let indexOfA = HomeViewController.GlobalVariable.myStruct.index(of:item)
            HomeViewController.GlobalVariable.myStruct.remove(at: indexOfA!)
            HomeViewController.GlobalVariable.price.remove(at: indexOfA!)
            HomeViewController.GlobalVariable.qty.remove(at: indexOfA!)
            totalAmountLabel.text = "$"+String(0.0)
        }

    }
    
    @IBOutlet weak var checkoutButtonClicked: UIButton!
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! CheckoutViewController
        viewController.totalPrice = sum
        //        viewController.itemPrice = itemPrice
        //        viewController.itemName = menuItem
    }
    

}
