//
//  Camera.swift
//  social_network
//
//  Created by Radomyr Sidenko on 12.05.2018.
//  Copyright © 2018 Radomyr Sidenko. All rights reserved.
//

import UIKit
import AVFoundation


class CameraController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var vievCamera: UIView!
    
    var captureSession = AVCaptureSession()
    var captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
    var videoLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput!
    var movieFileOut = AVCaptureMovieFileOutput()
    var previewImage: UIImage?
    
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
//        self.displayAlert(userMessage: "takePhoto")
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
    
    ////////////////////////redirect image/////////////////////
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PreviewPage" {
            let previewViewController = segue.destination as! PreviewViewController
            previewViewController.previewImage = self.previewImage
        }
        if segue.identifier == "PostPage" {
            let postController = segue.destination as! PostController
            postController.previewImage = self.previewImage
        }
    }
    /////////////////////////////////////////////
    
    ////////////////////////Photo for post of Library/////////////////////
    var postPhotoUpl: Data!
    @IBAction func openLibrary(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        print("Cancel")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("&&&&&&&&&&&")
        let profileImageFromPicker = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.previewImage = profileImageFromPicker
        dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "PostPage", sender: nil)
        
//        let profileImageFromPicker = info[UIImagePickerControllerOriginalImage] as! UIImage
//        self.previewImage = profileImageFromPicker
//         self.performSegue(withIdentifier: "PreviewPage", sender: nil)
        
    }
    
}

extension CameraController : AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("#################")
        if let imageData = photo.fileDataRepresentation() {
            self.previewImage = UIImage(data: imageData)
            performSegue(withIdentifier: "PreviewPage", sender: nil)
        }
        
//        if let imageData = photo.fileDataRepresentation() {
//            UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData)!, nil, nil, nil)
//        }
        
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
