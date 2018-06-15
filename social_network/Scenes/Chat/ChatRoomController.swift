//
//  ChatRoomController.swift
//  social_network
//
//  Created by Radomyr Sidenko on 31.05.2018.
//  Copyright © 2018 Radomyr Sidenko. All rights reserved.
//


import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ChatRoomController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    private var ref = Database.database().reference()
    private var auth = Auth.auth()
    var chatId: String!
    
    @IBOutlet weak var chatPhoto: UIImageView!
    @IBOutlet weak var chatName: UILabel!
    @IBOutlet weak var messageBoard: UITableView!
    
    @IBOutlet weak var textMessage: UITextField!
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
   
    class Message {
        var text: String!
        var owner: String?
        init(textString: String, ownerString: String) {
            text = textString
            owner = ownerString
        }
    }
    
    var messageList = [Message]()
    
    let cellReuseIdentifier = "cell"
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.messageBoard.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        setuoTableWiew()
        messageBoard.delegate = self
        messageBoard.dataSource = self
        
        loadData()
    }
    func setuoTableWiew(){
        let cellNib=UINib(nibName: "Message", bundle: Bundle.main) // nibName - имя файла
        messageBoard.register(cellNib, forCellReuseIdentifier: "MessageCell")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = messageBoard.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? MessageCell else {fatalError()}
//        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "test")
//        cell.textLabel?.text = messageList[indexPath.row].text
//        cell.detailTextLabel?.text = messageList[indexPath.row].owner
        cell.message?.text = messageList[indexPath.row].text
        cell.ower?.text = messageList[indexPath.row].owner
//        self.messageBoard.rowHeight = 100.0
        
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.width - 20, height: 120))
        if(cell.ower?.text == auth.currentUser?.uid){
            whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.38, 1.0, 0.50, 1])
        }else{
             whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.57, 0.67, 0.20, 1])
        }
       
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 2.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubview(toBack: whiteRoundedView)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
   
    func loadData(){
        ref.child("chat").child(chatId).observeSingleEvent(of: .value, with: { (snapshot) in
            DispatchQueue.main.async {
                let value = snapshot.value as? NSDictionary
                let storage = Storage.storage()
                let storageRef = storage.reference()
                let islandRef = storageRef.child(value?["photo"] as? String ?? "")
                
                islandRef.getData(maxSize: 1 * 1024 * 1024) {
                    data, error in
                    if let error = error {
                        // Uh-oh, an error occurred!
                    } else {
                        self.chatPhoto.image = UIImage(data: data!)
                        self.chatName.text = value?["name"] as! String
                    }
                }
                
                self.ref.child("chat").child(self.chatId).child("message").observe(.childAdded){(snapshot) in
                    DispatchQueue.main.async {
                       print(snapshot)
                        let value = snapshot.value as? NSDictionary
                        let message = Message(textString: value?["text"] as! String, ownerString: value?["owner"] as! String )
                        self.messageList.append(message)
                        self.messageBoard.reloadData();
                    }
                }
            }
        })
    }

    
    ///////////////////keyBoard/////////////////////////
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    ////////////////////////////////////////////
    
    ///////////////////sendMessage/////////////////////////
    @IBAction func sendMessage(_ sender: Any) {
        guard let userID = auth.currentUser?.uid,
            let message = textMessage.text,
            !message.isEmpty
            else{return}
        let data = [
            "owner": userID,
            "text": message
        ]
       
        let messageRef = ref.child("chat").child(self.chatId).child("message").childByAutoId()
        messageRef.setValue(data){( error, databaseRef) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
        }
    }
    ////////////////////////////////////////////
}
