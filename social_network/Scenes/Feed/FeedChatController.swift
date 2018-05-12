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
    var postPhotoUpl: Data!
    
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var feedLine: UITableView!
    
    ///////////////////keyBoard/////////////////////////
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        postText.resignFirstResponder()
        return true
    }
    /////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFeedText()
        loadFeed()
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



        cell.userPhoto.image = UIImage(named: "avatar2")
        
        cell.usernickname.text = posts[indexPath.row].usernickname
        cell.message.text = posts[indexPath.row].message

        if(posts[indexPath.row].postPhoto != nil){
            cell.postPhoto.isHidden = false
            cell.postPhoto.image = posts[indexPath.row].postPhoto
            cell.postPhoto?.frame.size.width = (posts[indexPath.row].postPhoto?.size.width)!/2
            cell.postPhoto?.frame.size.height = (posts[indexPath.row].postPhoto?.size.height)!/2
            self.feedLine.rowHeight = (cell.postPhoto?.frame.size.height)! + 50
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

        ref.child("feed/").observe(.childAdded){(snapshot) in
            DispatchQueue.main.async {
                
                let value = snapshot.value as! [String : AnyObject]
                let message = value["message"] as! String
                let user = value["user"] as! String
                let photo = value["photo"] as? String
    
                if(photo != nil){
                    let storage = Storage.storage()
                    let storageRef = storage.reference()
                    let islandRef = storageRef.child(photo as? String ?? "")
                    islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                        if let error = error {
                            // Uh-oh, an error occurred!
                        } else {
                            // Data for "images/island.jpg" is returned
                            let image = UIImage(data: data!)
                            let post = Post(userPhotoValue: (image ?? nil)!, usernicknameValue: user ?? "", messageValue: message ?? "", postPhotoValue: (image ?? nil)!)
                            self.posts.append(post)
                            self.feedLine?.reloadData()
                        }
                    }
                }else{
                    let post = Post(userPhotoValue: nil, usernicknameValue: user ?? "", messageValue: message ?? "", postPhotoValue: nil)
                    self.posts.append(post)
                    self.feedLine?.reloadData()
                }
            }
        }
    }
    
    
    @IBAction func sendMessage(_ sender: Any) {
        
        var url = randomString(length: 6)
        if(postPhotoUpl != nil){
            let storage = Storage.storage()
            let storageRef = storage.reference()
            
            var imageRef = storageRef.child("post/"+url+"posPhoto.jpg")
            _ = imageRef.putData(postPhotoUpl, metadata: nil, completion: {
                (metadata,error ) in
                guard let metadata = metadata else{
                    print(error)
                    return
                }
                let downloadURL = metadata.downloadURL()
                print(downloadURL)
                
            })
        }
       
        func test(data: Any){
            let messageRef = ref.child("feed/").childByAutoId()
            
            messageRef.setValue(data ?? ""){( error, databaseRef) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                    return
                }
            }
        }
        
        guard let userID = auth.currentUser?.uid,
            let message = postText.text,
            !message.isEmpty
            else{return}
        if(postPhotoUpl != nil){
            let data = [
                "user": userID,
                "message": message,
                "photo": "post/"+url+"posPhoto.jpg"
            ]
            test(data: data)
        }else{
            let data = [
                "user": userID,
                "message": message
            ]
            test(data: data)
        }
        
       
        //////////////////////////////
        
        
        
    }

    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        print("Cancel")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        let profileImageFromPicker = info[UIImagePickerControllerOriginalImage] as! UIImage
        postPhotoUpl = UIImageJPEGRepresentation(profileImageFromPicker, 0.5)!
        dismiss(animated: true, completion: nil)
        
    }
    
    
    

}
