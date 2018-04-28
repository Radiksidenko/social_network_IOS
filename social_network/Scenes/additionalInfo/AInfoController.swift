//
//  AInfoController.swift
//  social_network
//
//  Created by Radomyr Sidenko on 24.04.2018.
//  Copyright © 2018 Radomyr Sidenko. All rights reserved.
//


import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class AInfoController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
   
    ///////////////////storage/////////////////////////
    
    @IBAction private func storageTest(_ sender: Any){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
 
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        print("Cancel")
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        let profileImageFromPicker = info[UIImagePickerControllerOriginalImage] as! UIImage
        let data: Data = UIImageJPEGRepresentation(profileImageFromPicker, 0.5)!
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let userID = Auth.auth().currentUser?.uid

        var imageRef = storageRef.child("images/"+userID!+"userPhoto.jpg")
        _ = imageRef.putData(data, metadata: nil, completion: {
            (metadata,error ) in
            guard let metadata = metadata else{
                print(error)
                return
            }
            let downloadURL = metadata.downloadURL()
            print(downloadURL)
            self.setInfo()
        })
        //////////////////////////////////////////
        
        
        self.ref.child("users/"+userID!+"/userPhoto").setValue("images/"+userID!+"userPhoto.jpg")
        dismiss(animated: true, completion: nil)
    }
    
    ///////////////////storage/////////////////////////
    
    
    
    @IBOutlet weak var changeFName: UITextField!
    @IBOutlet weak var changeLName: UITextField!
    @IBOutlet weak var changeNickname: UITextField!
    @IBOutlet weak var changeBio: UITextView!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    
    private var ref = Database.database().reference()
    private var auth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ////////////////////////background/////////////////////
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg img")!)
        
        let background = UIImage(named: "bg img")
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
        ////////////////////////////////////////////
        
        
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
                
                ////////////////////////////////

                
                let storage = Storage.storage()
                let storageRef = storage.reference()
                let islandRef = storageRef.child(value?["userPhoto"] as? String ?? "")
                islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if let error = error {
                        // Uh-oh, an error occurred!
                    } else {
                        // Data for "images/island.jpg" is returned
                        let image = UIImage(data: data!)
                        self.userImage.image = UIImage(data: data!)
                    }
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
