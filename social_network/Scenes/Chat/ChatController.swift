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
    var idChat: String!
    
    
    
    
    
  
    
    @IBOutlet weak var chatView: UITableView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.chatView.rowHeight = 100
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       print("click")
//        chatName.text = indexPath.row as? String
        idChat = chatList[indexPath.row].id
        performSegue(withIdentifier: "ChatRoom", sender: nil)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChatRoom" {
            let chatRoom = segue.destination as! ChatRoomController
            chatRoom.chatId = self.idChat
            print(self.idChat)
        }
        
    }
}
