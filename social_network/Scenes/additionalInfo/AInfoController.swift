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
import Firebase

class AInfoController: UIViewController {
    ///////////////////storage/////////////////////////
   
    private func storageTest(){
        
    }
    ///////////////////storage/////////////////////////
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
        setInfo()
        AInfoController.style(input: changeFName)
        AInfoController.style(input: changeLName)
        AInfoController.style(input: changeNickname)
        AInfoController.style(input: gender)
        AInfoController.style(input: phone)
        
    }
    class func style(input :UITextField) {
        let width = CGFloat(2.0)
        
        let style = CALayer()
        style.borderColor = UIColor.darkGray.cgColor
        style.borderWidth = width
        style.frame = CGRect(x: 0, y: (input.frame.size.height) - width,
                             width:  (input.frame.size.width),
                             height: (input.frame.size.height))
        input.layer.addSublayer(style)
        input.layer.masksToBounds = true
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

    private func setInfo(){
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            DispatchQueue.main.async {
                let value = snapshot.value as? NSDictionary
                let username = value?["username"] as? String ?? ""
                let userlname = value?["userlname"] as? String ?? ""
                let usernickname = value?["usernickname"] as? String ?? ""
                let userbio = value?["userbio"] as? String ?? ""
                let genderVal = value?["gender"] as? String ?? ""
                let phoneVal = value?["phone"] as? String ?? ""
                
                self.changeFName.text = username
                self.changeLName.text = userlname
                self.changeNickname.text = usernickname
                self.changeBio.text = userbio
                self.gender.text = genderVal
                self.phone.text = phoneVal
                
                
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
