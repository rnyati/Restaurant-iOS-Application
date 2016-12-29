//
//  HomeViewController.swift
//  myFbLogin
//
//  Created by Raghav Nyati on 12/14/16.
//  Copyright © 2016 Raghav Nyati. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var viewController: UIViewController!
    
    var vegMenu: [String] = []
    var nonVegMenu: [String] = []
    var combosMenu: [String] = []
    var dessertsMenu: [String] = []
    var menu: [String] = []
    
    var vegIconArray:Array = [UIImage]()
    var nonVegIconArray:Array = [UIImage]()
    var comboIconArray:Array = [UIImage]()
    var dessertIconArray:Array = [UIImage]()
    var image:Array = [UIImage]()
    
    var vegPrice:Array = [Float]()
    var nonVegPrice:Array = [Float]()
    var comboPrice:Array = [Float]()
    var dessertPrice:Array = [Float]()
    var price:Array = [Float]()
    
    var vegDescription:Array = [String]()
    var nonVegDescription:Array = [String]()
    var comboDescription:Array = [String]()
    var dessertDescription:Array = [String]()
    var desc:Array = [String]()
    
    @IBAction func cartClicked(_ sender: Any) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        cartViewController = mainStoryboard.instantiateViewController(withIdentifier: "CartViewController") as UIViewController
        //self.present(homeViewController, animated: true, completion: nil)
        //self.navigationController?.show(homeViewController, sender: nil)
        self.perform(#selector(getter: self.cartViewController), with: nil, afterDelay: 0.0)
    }
    
    let cellIdentifier = "CellIdentifier"
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentView: UISegmentedControl!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var cartViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        combosMenu = ["Rice Bowl", "2 Entree Plate", "Ultimate Combo"]
        dessertsMenu = ["Gulab Jamun", "Ras Malai", "Kheer", "Carrot Cake", "Rasgulla"]
        nonVegMenu = ["Chicken Tikka Masala", "Chicken Curry", "Butter Chicken", "Goat Curry", "Tandoori Chicken", "Beef Curry", "Fish"]
        vegMenu = ["Samosa", "Chole Bhature", "Pani Puri","Pao Bhaji","Paneer Cutlet","Patties","Kachori"]
        
        vegIconArray = [UIImage(named:"v1")!,UIImage(named:"v2")!,UIImage(named:"v3")!,UIImage(named:"v4")!,
        UIImage(named:"v5")!,UIImage(named:"v6")!,UIImage(named:"v7")!]
        nonVegIconArray = [UIImage(named:"nv1")!,UIImage(named:"nv2")!,UIImage(named:"nv3")!,UIImage(named:"nv4")!,UIImage(named:"nv5")!,UIImage(named:"nv6")!,UIImage(named:"nv7")!]
        comboIconArray = [UIImage(named:"c1")!,UIImage(named:"c2")!,UIImage(named:"c3")!]
        dessertIconArray = [UIImage(named:"d1")!,UIImage(named:"d2")!,UIImage(named:"d3")!,UIImage(named:"d4")!,UIImage(named:"d5")!]
        
        comboPrice = [5.99, 7.99, 10.99]
        vegPrice = [4.99, 8.99, 5.99,2.49,4.99,3.99,8.99]
        nonVegPrice = [8.99, 6.99, 7.99, 6.99, 8.99, 10.99, 9.99, 8.99]
        dessertPrice = [4.99, 4.99, 4.99, 4.99, 4.99]
        
        comboDescription = ["Authentic Hyderabadi Dum Biryani", "Veggies, Mushroom Chicken and Honey Walnut Shrimp (2 Entree Plate) Lo Mein, Orange Chicken, Beef W/ Broccoli (2 Entree Plate) ... Orange/Kung Pao Chicken W/ Chow Mein & Fried Rice (2 Entree Plate)", "Special combination of chicken tikka, lamb, sheekh kebab, lamb boti kebab, tandoori fish, goat curry, chicken curry, veg curry, daal, rice, naan, raita, and dessert of the day."]
        dessertDescription = ["Most popular and loved dessert in India.  It is best described as an Indian version of a donut immersed in a sweet syrup.", "Bengali dessert consisting of soft paneer balls immersed in chilled creamy milk.", "Rice pudding cooked with milk and sugar, flavored with nuts and saffron.", "Classic Indian dessert made with carrot and milk.", "Homemade cheese or paneer balls soaked in chilled sugar syrup."]
        nonVegDescription = ["Dish of roasted chunks of chicken tikka in a spicy sauce. The sauce is usually creamy, spiced and orange-coloured.", "South Asian curry consists of chicken stewed in an onion and tomato-based sauce, flavored with ginger, garlic, mango chutney, tomato puree, chili peppers and a variety of spices", "Indian dish of chicken in a mildly spiced curry sauce.", "Indian curry dish that is prepared from mutton and vegetables and originated in Bengal", "Roasted chicken prepared with yogurt and spices.", "Best served with plain basmati rice or eaten with naan or pita bread.", "Indian dish with Chinese roots"]
        vegDescription = ["Fried or baked dish with a savoury filling, such as spiced potatoes, onions, peas, lentils, macaroni, noodles or minced meat.", "Bhatura chole is a combination of chana masala (spicy chick peas) and fried bread called bhatoora (made of maida flour)", "Potato, onion, chickpeas, coriander chutney stuffed crispy puri drenched in sour and spicy mint flavored water (pudina pani).","Fast food dish from Maharashtra, consisting of a thick vegetable curry usually prepared in butter and served with a soft bread roll.","Paneer cutlet or paneer tikki one of the best after school snacks for kids.","Patties can be eaten with a knife and a fork in dishes like Salisbury steak, but are typically served in a sort of sandwich called a burger, or a hamburger if the patty is made from ground beef.","Kachori is a spicy snack from the Indian subcontinent; popular in India, Pakistan and other parts of South Asia."]
        
        
            segmentView.selectedSegmentIndex = 0
            menu = vegMenu
            image = vegIconArray
            price = vegPrice
            desc = vegDescription
        // Do any additional setup after loading the view.
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func presentViewController(){
        self.present(viewController, animated: true, completion: nil)
    }

    @IBAction func segmentStateChanged(_ sender: Any) {
        switch segmentView.selectedSegmentIndex{
        case 0:
            menu = vegMenu
            image = vegIconArray
            price = vegPrice
            desc = vegDescription
            reloadData()
        case 1:
            menu = nonVegMenu
            image = nonVegIconArray
            price = nonVegPrice
            desc = nonVegDescription
            reloadData()
        case 2:
            menu = combosMenu
            image = comboIconArray
            price = comboPrice
            desc = comboDescription
            reloadData()
        case 3:
            menu = dessertsMenu
            image = dessertIconArray
            price = dessertPrice
            desc = dessertDescription
            reloadData()
        default:
            break;
        }
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
        let numberOfRows = menu.count
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HomeTableViewCell
        
        // Fetch Menu
        let menu1 = menu[indexPath.row]
        let image1 = image[indexPath.row]
        let price1 = price[indexPath.row]
        
        // Configure Cell
        cell.titleLabelView.text = menu1
        cell.imgView.image = image1
        cell.priceLabelView.text = "$" + String(price1)
        //cell.textLabel?.text = menu1
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator;
        return cell
        //return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let row = indexPath.row
        print(menu[row])
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier != "CartSegue"){
            let viewController = segue.destination as! MenuItemDetailViewController
            let cell = sender as! UITableViewCell
            let selectedRow = tableView.indexPath(for: cell)!.row
            viewController.passedValue = selectedRow
            //print(selectedRow)
            viewController.itemPrice = price[selectedRow]
            viewController.menuItem = menu[selectedRow]
            viewController.itemImage = image[selectedRow]
            viewController.itemDesc = desc[selectedRow]
        }else{
            _ = segue.destination as! CartViewController
            //viewController.match = self.match
        }
    }
    
    struct GlobalVariable {
        static var myStruct = [String]();
        static var price = [Float]();
        static var qty = [Float]();
    }
    
    @IBAction func didCartTapped(_ sender: Any) {
        performSegue(withIdentifier: "CartSegue", sender: self)
        print("Cart Cliked")
    }

}
