//
//  PostViewController.swift
//  social_network
//
//  Created by Radomyr Sidenko on 26.05.2018.
//  Copyright © 2018 Radomyr Sidenko. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


class PostViewController: UIViewController{
    var postID: String!
    private var ref = Database.database().reference()
    private var auth = Auth.auth()
    
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userNickName: UILabel!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var postImage: UIImageView!
    
    
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        test()
    }
   
    func test(){
        
        
        
        
        ref.child("feed").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let userId = value?["user"]
            print("message:", value?["message"])
            self.postText.text = value?["message"] as! String
            
            let storage = Storage.storage()
            let storageRef = storage.reference()
            
            let postImageview = storageRef.child(value?["photo"] as? String ?? "")
            postImageview.getData(maxSize: 5 * 1024 * 1024) { data1, error in
                if error != nil {
                    // Uh-oh, an error occurred!
                } else {
                    self.postImage.image = UIImage(data: data1!)
//                    self.userPhoto?.frame.size.width = 42
//                    self.userPhoto?.frame.size.height = 42
                }
            }
            
            self.ref.child("users").child(userId as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                
                let value = snapshot.value as? NSDictionary
                let storage = Storage.storage()
                let storageRef = storage.reference()
                print(value?["usernickname"])
                self.userNickName.text = value?["usernickname"] as! String
                
                let userPhoto = storageRef.child(value?["userPhoto"] as? String ?? "")
                userPhoto.getData(maxSize: 5 * 1024 * 1024) { data1, error in
                    if error != nil {
                        // Uh-oh, an error occurred!
                    } else {
                        self.userPhoto.image = UIImage(data: data1!)
                        self.userPhoto?.frame.size.width = 42
                        self.userPhoto?.frame.size.height = 42
                    }
                }
                
                
            })
            
        })
    }
}
