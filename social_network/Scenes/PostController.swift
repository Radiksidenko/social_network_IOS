//
//  PostController.swift
//  social_network
//
//  Created by Radomyr Sidenko on 18.05.2018.
//  Copyright © 2018 Radomyr Sidenko. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class PostController: UIViewController {
    
    @IBOutlet weak var viewPreviewImage: UIImageView!
    @IBOutlet weak var postText: UITextView!
    
    var postPhotoUpl: Data!
    private var ref = Database.database().reference()
    private var auth = Auth.auth()
    
    var previewImage:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPreviewImage.image = previewImage
        postPhotoUpl = UIImageJPEGRepresentation(previewImage!, 0.5)!
    }
    ///////////////////keyBoard/////////////////////////
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        postText.resignFirstResponder()
        return true
    }
    /////////////////////////////////////////////////
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPost(_ sender: Any) {
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
            let message = postText.text
//            !message.isEmpty
            else{return}
        if(postPhotoUpl != nil){
            let data = [
                "user": userID,
                "message": message ?? "",
                "photo": "post/"+url+"posPhoto.jpg"
            ]
            print("#####@@@@@##@#@#@#@@")
            test(data: data)
        }else{
            let data = [
                "user": userID,
                "message": message
            ]
            test(data: data)
        }
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
    
}
