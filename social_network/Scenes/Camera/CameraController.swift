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
    
    
    @IBAction func recVideo(_ sender: Any) {
        
        if movieFileOut.isRecording{
            movieFileOut.stopRecording()
        }else{
            self.displayAlert(userMessage: "start")
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let fileUrl = path.first?.appendingPathComponent("output.mov")
            
            try? FileManager.default.removeItem(at: fileUrl!)
            movieFileOut.startRecording(to: fileUrl!, recordingDelegate: self )
        }
        
    }
    
    
    
    
    @IBOutlet weak var vievCamera: UIView!
    var captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
    var captureSession: AVCaptureSession?
    var movieFileOut = AVCaptureMovieFileOutput()
    var videoLayer: AVCaptureVideoPreviewLayer?
    
    
    @IBAction func flash(_ sender: Any) {
        captureSession?.beginConfiguration()
        try? captureDevice?.lockForConfiguration()
        let mode = captureDevice?.torchMode ?? .off
        switch mode {
        case .off:
            captureDevice?.torchMode = .on
        default:
            captureDevice?.torchMode = .off
        }
        
        
        captureSession?.commitConfiguration()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
//        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        let micDevice = AVCaptureDevice.default(for: AVMediaType.audio)
        
        let input = try! AVCaptureDeviceInput(device: captureDevice!)
        let micInput = try! AVCaptureDeviceInput(device: micDevice!)
        
        captureSession = AVCaptureSession()
        captureSession?.addInput(input)
        captureSession?.addOutput(movieFileOut)
        
        
        captureSession?.addInput(micInput)
        
       setupVideoLayer()
    }
    
    
    func setupVideoLayer(){
        videoLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoLayer?.frame = UIScreen.main.bounds
        videoLayer?.videoGravity = .resizeAspectFill
        vievCamera.layer.addSublayer(videoLayer!)
        captureSession?.startRunning()
    }
    
    ////////////////////////window alert/////////////////////
    func displayAlert(userMessage: String) {
        var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(ok)
        self.present(myAlert, animated: true, completion: nil)
    }
    /////////////////////////////////////////////
    
}

extension CameraController: AVCaptureFileOutputRecordingDelegate{
    
    func fileOutput(_ output: AVCaptureFileOutput,
                    didFinishRecordingTo outputFileURL: URL,
                    from connections: [AVCaptureConnection],
                    error: Error?) {
        
        UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
    }
}
