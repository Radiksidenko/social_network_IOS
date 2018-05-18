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

class FeedChatController: UIViewController, UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
    
    private var ref = Database.database().reference()
    private var auth = Auth.auth()
    
    var posts = [Post]()
    
    
    
    @IBOutlet weak var feedLine: UITableView!
    
    var refresh = UIRefreshControl()
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFeedText()
        loadFeed()
        feedLine?.refreshControl = self.refresh
        self.refresh.addTarget(self, action: #selector(refreshFeed(_:)), for: .valueChanged)
        
    }
    @objc private func refreshFeed(_ sender: Any) {
//        posts.removeAll()
        loadFeedText()
        self.feedLine?.reloadData()
        self.refresh.endRefreshing()
    }
   
    func loadFeed(){
        let cellNib=UINib(nibName: "UnitFeed", bundle: Bundle.main) // nibName - имя файла
        feedLine?.register(cellNib, forCellReuseIdentifier: "UnitTableViewCell")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = feedLine.dequeueReusableCell(withIdentifier: "UnitTableViewCell") as? UnitTableViewCell else {fatalError()}
        
        
        
        cell.userPhoto.image = posts[indexPath.row].userPhoto ?? UIImage(named: "avatar2")
        
        cell.usernickname.text = posts[indexPath.row].usernickname
        cell.message.text = posts[indexPath.row].message
        
        if(posts[indexPath.row].postPhoto != nil){
            cell.postPhoto.isHidden = false
            cell.postPhoto.image = posts[indexPath.row].postPhoto
            cell.postPhoto?.frame.size.width = 300
            //            cell.postPhoto.frame.origin.y = 20.0
            cell.postPhoto.frame.origin.x = (self.view.bounds.size.width - cell.postPhoto.frame.size.width) / 2.0
            
            
            
            self.feedLine.rowHeight = (cell.postPhoto?.frame.size.height)! + 130
        }else{
            cell.postPhoto.isHidden = true
            self.feedLine.rowHeight = 100.0
        }
        
        
        
        
        
        return cell
    }
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 500
    //    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    
    
    private func loadFeedText(){
        posts.removeAll()
        ref.child("feed/").observe(.childAdded){(snapshot) in
            
            
            let value = snapshot.value as! [String : AnyObject]
            let message = value["message"] as! String
            let user = value["user"] as! String
            let photo = value["photo"] as? String
            
            if(photo != nil){
                let storage = Storage.storage()
                let storageRef = storage.reference()
                let islandRef = storageRef.child(photo as? String ?? "")
                islandRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                    if let error = error {
                        // Uh-oh, an error occurred!
                    } else {
                        self.ref.child("users").child(user).observeSingleEvent(of: .value, with: { (snapshot) in
                            let value = snapshot.value as? NSDictionary
                            let userPhoto = storageRef.child(value?["userPhoto"] as? String ?? "")
                            userPhoto.getData(maxSize: 5 * 1024 * 1024) { data1, error in
                                if let error = error {
                                    // Uh-oh, an error occurred!
                                } else {
                                    print(value?["usernickname"] ?? "")
                                    let userName = value?["usernickname"] ?? "NULL42"
                                    let image = UIImage(data: data!)
                                    let userPhotoIm = UIImage(data: data1!)
                                    let post = Post(userPhotoValue: (userPhotoIm ?? nil)!, usernicknameValue: userName as! String, messageValue: message ?? "", postPhotoValue: (image ?? nil)!)
                                    self.posts.append(post)
                                    self.feedLine?.reloadData()
                                }
                            }
                        })
                    }
                }
            }else{
                self.ref.child("users").child(user).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let storage = Storage.storage()
                    let storageRef = storage.reference()
                    
                    let userPhoto = storageRef.child(value?["userPhoto"] as? String ?? "")
                    userPhoto.getData(maxSize: 5 * 1024 * 1024) { data1, error in
                        if let error = error {
                            // Uh-oh, an error occurred!
                        } else {
                            
                            let userName = value?["usernickname"] ?? "NULL42"
                            let userPhotoIm = UIImage(data: data1!)
                            
                            let post = Post(userPhotoValue: nil, usernicknameValue: userName as! String, messageValue: message ?? "", postPhotoValue: nil)
                            self.posts.append(post)
                            self.feedLine?.reloadData()
                        }
                    }
                })
            }
        }
    }
    
    
    
}
