//
//  Chat.swift
//  social_network
//
//  Created by Radomyr Sidenko on 20.03.2018.
//  Copyright © 2018 Radomyr Sidenko. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ChatController: UIViewController, UITextFieldDelegate {
    private var ref = Database.database().reference()
    private var auth = Auth.auth()
    
    @IBOutlet weak var messageBoard: UITextView!
    @IBOutlet weak var textMessage: UITextField!
    
    @IBAction func sendMessage(_ sender: Any) {
        guard let userID = auth.currentUser?.uid,
            let message = textMessage.text,
            !message.isEmpty
            else{return}
        let data = [
            "user": userID,
            "message": message
        ]
        debugPrint("////////////////")
        debugPrint("/////",data,"///////")
        debugPrint("////////////////")
        let messageRef = ref.child("message/").childByAutoId()
//        let messageRef = ref.child("user/\(userID)/").childByAutoId()
        messageRef.setValue(data){( error, databaseRef) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
        }
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textMessage.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeChat()
    }
    
    private func observeChat(){
        
////////////////////////userListTest/////////////////////////////
//        ref.child("users/").observe(.childAdded){(snapshot) in
//            DispatchQueue.main.async {
//                let value = snapshot.value as! [String : AnyObject]
//                let message = value["usernickname"] as! String
//                debugPrint("??????????????????????????")
//                debugPrint(message)
//                debugPrint("////////////////////////////")
//            }
//        }
//        guard let userID = auth.currentUser?.uid
//            else{return}
////////////////////////////////////////////////////////////////
        
        
        ref.child("message/").observe(.childAdded){(snapshot) in
            DispatchQueue.main.async {
                let text = self.messageBoard.text
                let value = snapshot.value as! [String : AnyObject]
                let message = value["message"] as! String
               
                
                var usernickname: String!
                
                
                let user_id = value["user"] as! String
                
                
                
                self.ref.child("users").child(user_id).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! [String : AnyObject]
                    usernickname = value["usernickname"] as? String ?? ""
                    print(usernickname)
                })
               

//                let appendMessage = text?.appending("\(message)\n\n")
                 let appendMessage = text?.appending("\(user_id) : \(message)\n\n")
                self.messageBoard.text = appendMessage
                self.textMessage.text = ""

                
                
            
                
                
               
                
            }
        }
    }
    
    
    
}
