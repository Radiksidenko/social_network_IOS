//
//  Camera.swift
//  social_network
//
//  Created by Radomyr Sidenko on 12.05.2018.
//  Copyright © 2018 Radomyr Sidenko. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController {
    
    
    @IBOutlet weak var vievCamera: UIView!
    
    var captureSession: AVCaptureSession?
    var videoLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        let input = try! AVCaptureDeviceInput(device: captureDevice!)
        
        captureSession = AVCaptureSession()
        
        captureSession?.addInput(input)
        
        videoLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoLayer?.frame = UIScreen.main.bounds
        videoLayer?.videoGravity = .resizeAspectFill
        
        vievCamera.layer.addSublayer(videoLayer!)
          captureSession?.startRunning()
    }
    
}
