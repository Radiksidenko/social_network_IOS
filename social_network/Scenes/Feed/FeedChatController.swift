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
import FirebaseStorage

class FeedChatController: UIViewController, UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource  {
    private var ref = Database.database().reference()
    private var auth = Auth.auth()
    
    
    
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var feedLine: UITableView!
    
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        postText.resignFirstResponder()
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFeedText()
        loadFeed()
    }

    func loadFeed(){
        let cellNib=UINib(nibName: "UnitFeed", bundle: Bundle.main) // nibName - имя файла
        feedLine.register(cellNib, forCellReuseIdentifier: "UnitTableViewCell")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = feedLine.dequeueReusableCell(withIdentifier: "UnitTableViewCell") as? UnitTableViewCell else {fatalError()}

//        ref.child("feed/").observe(.childAdded){(snapshot) in
//            DispatchQueue.main.async {
//
//                let value = snapshot.value as! [String : AnyObject]
//                let message = value["message"] as! String
//                let user = value["user"] as! String
//
//                let storage = Storage.storage()
//                let storageRef = storage.reference()
//                let islandRef = storageRef.child(value["photo"] as? String ?? "")
//                islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
//                    if let error = error {
//                        // Uh-oh, an error occurred!
//                    } else {
//                        // Data for "images/island.jpg" is returned
//                        let image = UIImage(data: data!)
//                        cell.postPhoto.image = UIImage(data: data!)
//                    }
//                }
//
//                cell.userPhoto.image = UIImage(named: "avatar")
//                cell.usernickname.text = user
//                cell.message.text = message
//                cell.postPhoto?.frame.size.width = (UIImage(named: "avatar")?.size.width)!/2
//                cell.postPhoto?.frame.size.height = (UIImage(named: "avatar")?.size.height)!/2
//            }
//        }



        if(Int(indexPath[1]) % 2 == 0){

            cell.userPhoto.image = UIImage(named: "avatar")
            cell.usernickname.text = "@Rick"
            cell.message.text = "42"
            cell.postPhoto?.frame.size.width = (UIImage(named: "avatar")?.size.width)!/2
            cell.postPhoto?.frame.size.height = (UIImage(named: "avatar")?.size.height)!/2
            cell.postPhoto.image = UIImage(named: "avatar2")
        }else{


            cell.userPhoto.image = UIImage(named: "avatar2")
            print(cell.postPhoto?.frame.size.width)
            print("======================")
            print((UIImage(named: "avatar")?.size.width)!)


            cell.usernickname.text = "@Test"
            cell.message.text = "1337"

            cell.postPhoto?.frame.size.width = (UIImage(named: "avatar")?.size.width)!/2
            cell.postPhoto?.frame.size.height = (UIImage(named: "avatar")?.size.height)!/2
            cell.postPhoto.image = UIImage(named: "avatar")


        }

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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


    private func loadFeedText(){

        ref.child("feed/").observe(.childAdded){(snapshot) in
            DispatchQueue.main.async {


                let value = snapshot.value as! [String : AnyObject]
                let message = value["message"] as! String
                let user = value["user"] as! String
                let photo = value["photo"] as? String

                print(("\(user) : \(message)\n photo: \(photo)\n ___________\n"))

            }
        }
    }

}
