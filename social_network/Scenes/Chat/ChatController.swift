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

class ChatController: UIViewController {
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
        let messageRef = ref.child("user/\(userID)/").childByAutoId()
        messageRef.setValue(data){( error, databaseRef) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeChat()
    }
    private func observeChat(){
        guard let userID = auth.currentUser?.uid
            else{return}
        ref.child("user/\(userID)/").observe(.childAdded){(snapshot) in
            DispatchQueue.main.async {
                let text = self.messageBoard.text
                let value = snapshot.value as! [String : AnyObject]
                let message = value["message"] as! String
                let appendMessage = text?.appending("\(message)\n\n")
                self.messageBoard.text = appendMessage
                self.textMessage.text = ""
            }
        }
    }
    
    
    @IBAction func logOut(_ sender: Any) {
        try! auth.signOut()
        guard let appDeligate = UIApplication.shared.delegate as? AppDelegate else {return}
        guard let main = UIStoryboard(name: "Auth", bundle: Bundle.main).instantiateInitialViewController() else {return}
        appDeligate.window?.rootViewController = main
    }
}
