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
import FirebaseStorage

class ChatController: UIViewController, UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource  {
    private var ref = Database.database().reference()
    private var auth = Auth.auth()
    var chatList = [Chats]()
    
    @IBOutlet weak var messageBoard: UITextView!
    
    @IBOutlet weak var textMessage: UITextField!
    
    @IBOutlet weak var chatView: UITableView!
    
    ///////////////////sendMessage/////////////////////////
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
     ////////////////////////////////////////////
    
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
        //        observeChat()
                loadChannel()
        
        setuoTableWiew()
    }
    
    func setuoTableWiew(){
        let cellNib=UINib(nibName: "Conversation", bundle: Bundle.main) // nibName - имя файла
        chatView.register(cellNib, forCellReuseIdentifier: "ConversationCell")
    }
    
//////////////////////////////////
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = chatView.dequeueReusableCell(withIdentifier: "ConversationCell") as? ConversationCell else {
            print("Error")
            fatalError()
        }

        cell.chatName.text = chatList[indexPath.row].nameChat
        cell.chatPhoto.image = chatList[indexPath.row].chatPhoto
        self.chatView.rowHeight = 250
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       print("click")
    }
    
    //////////////////////////////////
    
    
    func loadChannel(){
        let userID = auth.currentUser?.uid
        ref.child("users").child(userID!).child("chats").observe(.childAdded){(snapshot) in
            DispatchQueue.main.async {
                let value = snapshot.value as! [String : AnyObject]
                let nameChat = value["name"]
                
                
                
                
                let storage = Storage.storage()
                let storageRef = storage.reference()
                let islandRef = storageRef.child(value["photo"] as? String ?? "")
                
                islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if let error = error {
                        // Uh-oh, an error occurred!
                    } else {
                        let chatPhoto = UIImage(data: data!)
                        let chat = Chats(chatId: snapshot.key, nameChaValuet: nameChat as! String, chatPhotoValue: chatPhoto )
                        self.chatList.append(chat)
                        self.chatView.reloadData()
                    }
                }
                
                
                
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
