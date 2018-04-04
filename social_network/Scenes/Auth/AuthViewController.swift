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
    
    @IBOutlet weak var buttonLogin: UIButton!
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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg img")!)
        ///////////////loginButton//////////////////
        self.buttonLogin.layer.borderWidth = 1.0
        let borderAlpha : CGFloat = 0.7
        self.buttonLogin.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        ///////////////End loginButton//////////////////
        ///////////////textField//////////////////
        let border = CALayer()
        let border2 = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.borderWidth = width
        
        border2.borderColor = UIColor.darkGray.cgColor
        border2.borderWidth = width
        ///////////////username input//////////////////
        border.frame = CGRect(x: 0, y: username.frame.size.height - width, width:  username.frame.size.width, height: username.frame.size.height)
        username.layer.addSublayer(border)
        username.layer.masksToBounds = true
        ///////////////password input//////////////////
        border2.frame = CGRect(x: 0, y: password.frame.size.height - width, width:  password.frame.size.width, height: password.frame.size.height)
        password.layer.addSublayer(border2)
        password.layer.masksToBounds = true
        ///////////////End textField//////////////////

    }
    
    @IBAction func createUser(_ sender: Any) {
        guard let usernameText = username.text,
            let passwordText = password.text,
            passwordText.count >= 6
            else{ return}
        Auth.auth().createUser(withEmail: usernameText, password: passwordText) { (user, error) in
            if let error = error{
                debugPrint("#############")
                debugPrint("∑∑∑∑∑∑∑∑∑∑∑∑∑")
                debugPrint("#############")
                debugPrint(error.localizedDescription)
            }
            debugPrint("#############")
            debugPrint("////////////")
            debugPrint("#############")
            debugPrint(user)
            self.switcMain()
        }

    }
    
    
    @IBAction func ForgotPassword(_ sender: Any) {
        debugPrint("*************")
        guard let appDeligate = UIApplication.shared.delegate as? AppDelegate else {return}
        guard let main = UIStoryboard(name: "Forgot", bundle: Bundle.main).instantiateInitialViewController() else {return}
        appDeligate.window?.rootViewController = main
    }
    
    @IBAction func SingUp(_ sender: Any) {
        guard let appDeligate = UIApplication.shared.delegate as? AppDelegate else {return}
        guard let main = UIStoryboard(name: "SingUp", bundle: Bundle.main).instantiateInitialViewController() else {return}
        appDeligate.window?.rootViewController = main
    }
    
    
    @IBAction func back(_ sender: Any) {
        guard let appDeligate = UIApplication.shared.delegate as? AppDelegate else {return}
        guard let main = UIStoryboard(name: "Auth", bundle: Bundle.main).instantiateInitialViewController() else {return}
        appDeligate.window?.rootViewController = main
    }
    
    private func switcMain(){
        guard let appDeligate = UIApplication.shared.delegate as? AppDelegate else {return}
        guard let main = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController() else {return}
        appDeligate.window?.rootViewController = main
        
    }
}

