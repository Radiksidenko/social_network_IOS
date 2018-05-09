//
//  FeedChatController.swift
//  social_network
//
//  Created by Radomyr Sidenko on 09.05.2018.
//  Copyright © 2018 Radomyr Sidenko. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class FeedChatController: UIViewController, UITextFieldDelegate {
    private var ref = Database.database().reference()
    private var auth = Auth.auth()
    
    @IBOutlet weak var feedLine: UITextView!
    
    @IBOutlet weak var postText: UITextView!
    
    
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        postText.resignFirstResponder()
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFeed()
    }
    
    
    
    @IBAction func sendMessage(_ sender: Any) {
        guard let userID = auth.currentUser?.uid,
            let message = postText.text,
            !message.isEmpty
            else{return}
        let data = [
            "user": userID,
            "message": message
        ]
      
        let messageRef = ref.child("feed/").childByAutoId()
        
        messageRef.setValue(data){( error, databaseRef) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
        }
    }
    
    
    private func loadFeed(){
      
        ref.child("feed/").observe(.childAdded){(snapshot) in
            DispatchQueue.main.async {
                let text = self.feedLine?.text
                
                let value = snapshot.value as! [String : AnyObject]
                let message = value["message"] as! String
                let user = value["user"] as! String
                let photo = value["photo"] as? String
                
                print(value)
                
                let appendMessage = text?.appending("\(user) : \(message)\n photo: \(photo)\n ___________\n")
                
                self.feedLine?.text = appendMessage
            }
        }
    }
    
}
