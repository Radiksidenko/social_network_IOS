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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ////////////////////////background/////////////////////
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg img")!)
        
        let background = UIImage(named: "bg img")
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
        ////////////////////////////////////////////
        
        ///////////////Button//////////////////
        self.buttonLogin?.layer.borderWidth = 1.0
        let borderAlpha : CGFloat = 0.7
        self.buttonLogin?.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        /////////////////////////////////
        
        ///////////////textField//////////////////
        let border = CALayer()
        let border2 = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.borderWidth = width
        border2.borderColor = UIColor.darkGray.cgColor
        border2.borderWidth = width
        
        ///////////////input//////////////////
        if((username) != nil){
            border.frame = CGRect(x: 0, y: (username?.frame.size.height)! - width, width:  (username.frame.size.width), height: (username?.frame.size.height)!)
            username?.layer.addSublayer(border)
            username?.layer.masksToBounds = true
        }
        
        ///////////////password input//////////////////
        if((password) != nil){
            border2.frame = CGRect(x: 0, y: password.frame.size.height - width, width:  password.frame.size.width, height: password.frame.size.height)
            password.layer.addSublayer(border2)
            password.layer.masksToBounds = true
        }
        /////////////////////////////////
        
    }
    
    ////////////////////////Spinner/////////////////////
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
    /////////////////////////////////////////////
    
    //////////////////switc page////////////////////////
    private func switcPage(page: String){
        guard let appDeligate = UIApplication.shared.delegate as? AppDelegate else {return}
        guard let main = UIStoryboard(name: page, bundle: Bundle.main).instantiateInitialViewController() else {return}
        appDeligate.window?.rootViewController = main
        
    }
    //////////////////////////////////////////
    
    
    ////////////////////////window alert/////////////////////
    func displayAlert(userMessage: String) {
        var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(ok)
        self.present(myAlert, animated: true, completion: nil)
    }
    /////////////////////////////////////////////
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var buttonLogin: UIButton!
    
    ////////////////////////Login/////////////////////
    @IBAction func login(_ sender: Any) {
        
        let sv = AuthViewController.displaySpinner(onView: self.view)
        guard let usernameText = username.text,
            let passwordText = password.text
            //        passwordText.count >= 6
            else{ return}
        Auth.auth().signIn( withEmail: usernameText,
                            password: passwordText){[weak self] (user, error) in
                                if let error = error{
                                    debugPrint(error.localizedDescription)
                                    debugPrint("$$$$$$$$$$$$$$$")
                                    debugPrint("login")
                                    debugPrint("$$$$$$$$$$$$$$$")
                                    AuthViewController.removeSpinner(spinner: sv)
                                    self?.displayAlert(userMessage: error.localizedDescription)
                                }
                                
                                if !(error != nil){
                                    AuthViewController.removeSpinner(spinner: sv)
                                    self?.switcPage(page: "Main")
                                }
                                
        }
    }
    /////////////////////////////////////////////
    
    ///////////////createUser//////////////////
    @IBAction func createUser(_ sender: Any) {
        let sv = AuthViewController.displaySpinner(onView: self.view)
        guard let usernameText = username.text,
            let passwordText = password.text
            //            passwordText.count >= 6
            else{ return}
        Auth.auth().createUser(withEmail: usernameText, password: passwordText) { (user, error) in
            if let error = error{
                debugPrint("#############")
                debugPrint("createUser")
                debugPrint("#############")
                debugPrint(error.localizedDescription)
                AuthViewController.removeSpinner(spinner: sv)
                self.displayAlert(userMessage: error.localizedDescription)
            }
            if !(error != nil){
                debugPrint(user)
                self.switcPage(page: "Main")
            }
        }
    }
    //////////////////////////////////////////
    
    /////////////////////ResetPassword/////////////////////
    @IBAction func ResetPassword(_ sender: Any) {
        let usernameText = username.text
        Auth.auth().sendPasswordReset(withEmail: usernameText!) { error in
            if let error = error{
                debugPrint("#############")
                debugPrint("ResetPassword")
                debugPrint("#############")
                debugPrint(error.localizedDescription)
                self.displayAlert(userMessage: error.localizedDescription)
            }
            if !(error != nil){
                self.switcPage(page: "ForgotOK")
            }
            
        }
    }
    //////////////////////////////////////////
    
    ////////////////////ForgotPassword//////////////////////
    @IBAction func ForgotPassword(_ sender: Any) {
        self.switcPage(page: "Forgot")
    }
    //////////////////////////////////////////
    
    //////////////////SingUp////////////////////////
    @IBAction func SingUp(_ sender: Any) {
        self.switcPage(page: "SingUp")
    }
    //////////////////////////////////////////
    
    ////////////////////////back button//////////////////
    @IBAction func back(_ sender: Any) {
        self.switcPage(page: "Auth")
    }
    //////////////////////////////////////////
    
}

