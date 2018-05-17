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
    
    var captureSession = AVCaptureSession()
    
    var captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
    
    var videoLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput!
    var movieFileOut = AVCaptureMovieFileOutput()
    
    @IBOutlet weak var takePhotoButton: UIButton!
    
    ////////////////////////Video//////////////////////
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
    //////////////////////////////////////////////////
    
    ////////////////////////photo/////////////////////
    @IBAction func takePhoto(_ sender: Any) {
        

        
        self.displayAlert(userMessage: "takePhoto")
        let settings = AVCapturePhotoSettings()
        self.capturePhotoOutput?.capturePhoto(with: settings, delegate: self)
    }
    //////////////////////////////////////////////////
    
    
    ////////////////////////Flash/////////////////////
    @IBAction func flash(_ sender: Any) {
        captureSession.beginConfiguration()
        try? captureDevice?.lockForConfiguration()
        let mode = captureDevice?.torchMode ?? .off
        switch mode {
        case .off:
            captureDevice?.torchMode = .on
        default:
            captureDevice?.torchMode = .off
        }
        
        
        captureSession.commitConfiguration()
    }
    //////////////////////////////////////////////////
   
    ////////////////////////design////////////////////
    override var prefersStatusBarHidden: Bool {
        return true
    }
    //////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        takePhotoButton.layer.borderColor = UIColor.white.cgColor
        takePhotoButton.layer.borderWidth = 5
        takePhotoButton.clipsToBounds = true
        takePhotoButton.layer.cornerRadius = min(takePhotoButton.frame.width, takePhotoButton.frame.height) / 2
        
       
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        let captureDeviceInput = try! AVCaptureDeviceInput(device: captureDevice!)
        captureSession.addInput(captureDeviceInput)
        capturePhotoOutput = AVCapturePhotoOutput()
        capturePhotoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
        captureSession.addOutput(capturePhotoOutput!)
        /////////////////////////
//        let micDevice = AVCaptureDevice.default(for: AVMediaType.audio)
//        let input = try! AVCaptureDeviceInput(device: captureDevice!)
//        let micInput = try! AVCaptureDeviceInput(device: micDevice!)
//
////        captureSession.addOutput(movieFileOut)
//        captureSession.addInput(input)
//        captureSession.addInput(micInput)
    
        
        setupVideoLayer()
    }
    
    
    
    func setupVideoLayer(){
        videoLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoLayer?.frame = UIScreen.main.bounds
        videoLayer?.videoGravity = .resizeAspectFill
        vievCamera.layer.addSublayer(videoLayer!)
        captureSession.startRunning()
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

extension CameraController : AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData)!, nil, nil, nil)
            dismiss(animated: true, completion: nil)
        }
    }
}

extension CameraController: AVCaptureFileOutputRecordingDelegate{
    func fileOutput(_ output: AVCaptureFileOutput,
                    didFinishRecordingTo outputFileURL: URL,
                    from connections: [AVCaptureConnection],
                    error: Error?) {
        UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
    }
}
