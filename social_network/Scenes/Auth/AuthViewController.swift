//
//  AuthViewController.swift
//  social_network
//
//  Created by Radomyr Sidenko on 31.03.2018.
//  Copyright © 2018 Radomyr Sidenko. All rights reserved.
//

import UIKit
import FirebaseAuth

class AuthViewController: UIViewController{
    

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func login(_ sender: Any) {
        guard let usernameText = username.text,
        let passwordText = password.text,
        passwordText.count >= 6
        else{ return}
        Auth.auth().signIn( withEmail: usernameText,
                            password: passwordText){[weak self] (user, error) in
                                if let error = error{
                                    debugPrint(error.localizedDescription)
                                }
                                debugPrint("////////////")
                                debugPrint(user)
                                self?.switcMain()
        }
    }
    private func switcMain(){
        guard let appDeligate = UIApplication.shared.delegate as? AppDelegate else {return}
        guard let main = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController() else {return}
        appDeligate.window?.rootViewController = main
        
    }
}

