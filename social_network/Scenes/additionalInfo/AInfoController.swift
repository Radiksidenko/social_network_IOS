//
//  AInfoController.swift
//  social_network
//
//  Created by Radomyr Sidenko on 24.04.2018.
//  Copyright © 2018 Radomyr Sidenko. All rights reserved.
//


import UIKit
import FirebaseAuth
import FirebaseDatabase

class AInfoController: UIViewController {
    
    @IBOutlet weak var changeFName: UITextField!
    @IBOutlet weak var changeLName: UITextField!
    @IBOutlet weak var changeNickname: UITextField!
    @IBOutlet weak var changeBio: UITextView!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    private var ref = Database.database().reference()
    private var auth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    @IBAction func changeUserInfo(_ sender: Any) {
        let userID = Auth.auth().currentUser?.uid
        
        self.ref.child("users/"+userID!+"/username").setValue(changeFName.text)
        self.ref.child("users/"+userID!+"/userlname").setValue(changeLName.text)
        self.ref.child("users/"+userID!+"/usernickname").setValue(changeNickname.text)
        self.ref.child("users/"+userID!+"/userbio").setValue(changeBio.text)
        self.ref.child("users/"+userID!+"/gender").setValue(gender.text)
        self.ref.child("users/"+userID!+"/phone").setValue(phone.text){ (error, ref) -> Void in
            let appDeligate = UIApplication.shared.delegate as? AppDelegate
            //Main AInfo
            let main = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()
            appDeligate?.window?.rootViewController = main
        }
        
        
    }

}
