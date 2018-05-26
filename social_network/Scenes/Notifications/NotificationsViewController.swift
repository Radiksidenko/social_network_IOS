//
//  NotificationsViewController.swift
//  social_network
//
//  Created by Radomyr Sidenko on 12.03.2018.
//  Copyright © 2018 Radomyr Sidenko. All rights reserved.
//

import UIKit
import FirebaseAuth

class NotificationsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.backgroundColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes =  [NSAttributedStringKey.foregroundColor: hexStringToUIColor(hex: "fffff")]
        setuoTableWiew()
    }
    func setuoTableWiew(){
        let cellNib=UINib(nibName: "Notifications", bundle: Bundle.main) // nibName - имя файла
        tableView.register(cellNib, forCellReuseIdentifier: "NotificationsTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTableViewCell", for: indexPath) as? NotificationsTableViewCell else {fatalError()}
        if(Int(indexPath[1]) % 2 == 0){
            cell.avatar.image = UIImage(named: "avatar")
            cell.name.text = "@Rick"
            cell.action.text = "42"
            cell.time.text = "1337 seconds ago"
        }else{
            cell.avatar.image = UIImage(named: "avatar2")
            cell.name.text = "@Test"
            cell.action.text = "1337"
            cell.time.text = "3h ago"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    
    
    @IBAction func logOut(_ sender: Any) {
        debugPrint("№№№№№№№№№№№№№")
        var auth = Auth.auth()
        try! auth.signOut()
        guard let appDeligate = UIApplication.shared.delegate as? AppDelegate else {return}
        guard let main = UIStoryboard(name: "Auth", bundle: Bundle.main).instantiateInitialViewController() else {return}
        appDeligate.window?.rootViewController = main
    }
    
}
