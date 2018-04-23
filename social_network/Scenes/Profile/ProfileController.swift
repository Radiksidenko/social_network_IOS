//
//  ProfileController.swift
//  social_network
//
//  Created by Radomyr Sidenko on 23.04.2018.
//  Copyright © 2018 Radomyr Sidenko. All rights reserved.
//


import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileController: UIViewController {
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    private var ref = Database.database().reference()
    private var auth = Auth.auth()
    
//    @IBOutlet weak var test: UILabel!
    
    @IBOutlet weak var FNameAndLName: UILabel!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var bio: UITextView!
    
    
    
    
    @IBOutlet weak var changeFName: UITextField!
    @IBOutlet weak var changeLName: UITextField!
    @IBOutlet weak var changeNickname: UITextField!
    @IBOutlet weak var changeBio: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes =  [NSAttributedStringKey.foregroundColor: hexStringToUIColor(hex: "FFFFFF")]
        observeChat()
    }
    
    
    
    @IBAction func changeUserInfo(_ sender: Any) {
        
        let userID = Auth.auth().currentUser?.uid
//        let url = "users/"+userID!+"/username"
        self.ref.child("users/"+userID!+"/username").setValue(changeFName.text)
        self.ref.child("users/"+userID!+"/userlname").setValue(changeLName.text)
        self.ref.child("users/"+userID!+"/usernickname").setValue(changeNickname.text)
        self.ref.child("users/"+userID!+"/userbio").setValue(changeBio.text)
    }
    
    
    private func observeChat(){
        let userID = Auth.auth().currentUser?.uid
        
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
//        ref.child("users/"+userID!).observe(.childAdded){(snapshot) in
            DispatchQueue.main.async {
                let value = snapshot.value as? NSDictionary
                let username = value?["username"] as? String ?? ""
                let userlname = value?["userlname"] as? String ?? ""
                let usernickname = value?["usernickname"] as? String ?? ""
                let userbio = value?["userbio"] as? String ?? ""
                
                self.FNameAndLName.text = username + " " + userlname
                self.nickname.text = "@"+usernickname
                self.bio.text = userbio
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        

        
    }
}
