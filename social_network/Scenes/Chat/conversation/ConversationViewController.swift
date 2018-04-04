//
//  File.swift
//  social_network
//
//  Created by Radomyr Sidenko on 04.04.2018.
//  Copyright © 2018 Radomyr Sidenko. All rights reserved.
//


import UIKit
class ConversationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "ConversationCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ConversationCell")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConversationCell", for: indexPath) as? ConversationCell
            else{ fatalError() }
        cell.setup(with: "sdcsc", at: "1.42")
//        cell.backgroundColor = .black
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLoyout: UICollectionViewLayout, sizeForItemAt indexPath:IndexPath) -> CGSize{
        let screenWidth = UIScreen.main.bounds.width
        let height = 144
        
        return CGSize(width: Int(screenWidth), height: Int(height))
    }
    
    
}
