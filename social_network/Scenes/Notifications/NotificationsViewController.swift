//
//  NotificationsViewController.swift
//  social_network
//
//  Created by Radomyr Sidenko on 12.03.2018.
//  Copyright © 2018 Radomyr Sidenko. All rights reserved.
//

import UIKit


class NotificationsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        //        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        //        if cell == nil {
        //            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        //        }
        //        cell!.textLabel?.text = "Hello World!"
        //        return cell!
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTableViewCell", for: indexPath) as? NotificationsTableViewCell else {fatalError()}
        
        if(Int(indexPath[1]) % 2 == 0){
            cell.avatar.image = UIImage(named: "avatar")
            cell.name.text = "Rick"
            cell.subName.text = "42"
        }else{
            cell.avatar.image = UIImage(named: "avatar2")
            //            cell.name.lineBreakMode = .byWordWrapping
            //            cell.name.numberOfLines = 0
            
            cell.name.text = "Test"
            
            cell.subName.text = "1337"
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
