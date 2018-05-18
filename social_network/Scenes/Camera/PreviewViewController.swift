//
//  PreviewViewController.swift
//  social_network
//
//  Created by Radomyr Sidenko on 18.05.2018.
//  Copyright © 2018 Radomyr Sidenko. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    
    @IBOutlet weak var viewPreviewImage: UIImageView!
    var previewImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPreviewImage.image = previewImage
    }
    @IBAction func save(_ sender: Any) {
        guard let imageToSave = previewImage else {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PostPage" {
            let postController = segue.destination as! PostController
            postController.previewImage = self.previewImage
        }
    }
    @IBAction func post(_ sender: Any) {
        performSegue(withIdentifier: "PostPage", sender: nil)
    }
    
    
    
}
