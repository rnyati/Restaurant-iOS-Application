

import Photos
import UIKit

import Firebase
//import GoogleMobileAds

//let kBannerAdUnitID = "ca-app-pub-3940256099942544/2934735716"

//@objc(FCViewController)
class FCViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,
UITextFieldDelegate {
    
    var ref: FIRDatabaseReference!
    var messages: [FIRDataSnapshot]! = []
    var msglength: NSNumber = 10
    fileprivate var _refHandle: FIRDatabaseHandle!
    
    let userEmailID = FIRAuth.auth()?.currentUser?.email
    
    //@IBOutlet weak var nameLabelView: UILabel!
    
    var storageRef: FIRStorageReference!
    
    @IBOutlet weak var clientTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clientTable.delegate = self
        self.clientTable.dataSource = self
        configureDatabase()
        
    }
    
    deinit {
        self.ref.child("cart").removeObserver(withHandle: _refHandle)
    }
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("cart").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }
            strongSelf.messages.append(snapshot)
            strongSelf.clientTable.insertRows(at: [IndexPath(row: strongSelf.messages.count-1, section: 0)], with: .automatic)
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue cell
        let cell = clientTable .dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! FCViewTableViewCell
        // Unpack message from Firebase DataSnapshot
        print(self.messages[indexPath.row])
        let messageSnapshot: FIRDataSnapshot! = self.messages[indexPath.row]
        let message = messageSnapshot.value as! Dictionary<String, String>
        if userEmailID == message["email"] as String! {
        //tblRowCount += 1
            //configureDatabase()
            let name = String(message["name"] as String!)
            cell.name.text = name
            cell.email.text = message["email"] as String!
            cell.pickUpdate.text = message["pickupDate"] as String!
            
        }
        //print(tblRowCount)
        return cell
    }
    
    
    func fetchConfig() {
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= self.msglength.intValue // Bool
    }
    
    // UITableViewDataSource protocol methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        AppState.sharedInstance.signedIn = false
        dismiss(animated: true, completion: nil)
    }
    
    func showAlert(withTitle title:String, message:String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title,
                                          message: message, preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
