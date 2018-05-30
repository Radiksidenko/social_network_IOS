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
        messageRef.setValue(data){( error, databaseRef) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
        }
    }
   
     ///////////////////keyBoard/////////////////////////
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textMessage.resignFirstResponder()
        return true
    }
     ////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeChat()
        
        loadChannel()
    }
    
    
    func loadChannel(){
        let userID = auth.currentUser?.uid
        
        ref.child("users").child(userID!).child("chats").observe(.childAdded){(snapshot) in
            DispatchQueue.main.async {
                
                let value = snapshot.value as! [String : AnyObject]
                
                
                
               
                print("∑∑∑∑∑∑¥¥¥¥¥¥¥¥¥¥¥¥¥¥")
                print(snapshot.key,value)
                print("¥¥¥¥¥¥¥¥¥¥¥¥¥¥∑∑∑∑∑∑")
                
            }
        }
    }
    
    private func observeChat(){
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
                    let appendMessage = self.messageBoard.text?.appending("\(usernickname ?? "") : \(message)\n\n")
                    self.messageBoard.text =  appendMessage
                })
            }
        }
    }
}
