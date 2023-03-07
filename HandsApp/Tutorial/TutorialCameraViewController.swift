//
//  TutorialCameraViewController.swift
//  HandsApp
//
//  Created by Ariuna Banzarkhanova on 02/03/23.
//

import UIKit
import Foundation
import SwiftUI
import AVFoundation
import Vision
import Photos
import SnapKit

class TutorialCameraViewController: UIViewController {
    
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    private let movieOutput = AVCaptureMovieFileOutput()
    private var videoDeviceInput: AVCaptureDeviceInput!
    
    private let handPoseRequest = VNDetectHumanHandPoseRequest()
    private let recordButton = UIButton()
    private var isRecording = false
    
    let tutorialVM: TutorialCameraViewModel
    
    init(tutorialVM: TutorialCameraViewModel){
        self.tutorialVM = tutorialVM
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var frameCounter = 0
    let handPosePredictionInterval = 30
    
    let model = try? MyHandPoseClassifier_1(configuration: MLModelConfiguration())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCaptureSession()
        prepareCaptureUI()
        
        handPoseRequest.maximumHandCount = 1
    }
    
    deinit {
        captureSession?.stopRunning()
        captureSession = nil
    }
    
    private func prepareCaptureSession() {
        let captureSession = AVCaptureSession()
        
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        
        captureSession.addInput(input)
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: .main)
        captureSession.addOutput(videoOutput)
        
        let photoOutput = AVCapturePhotoOutput()
        captureSession.addOutput(photoOutput)
        
        
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            fatalError("Could not get video device")
        }
        
        do {
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            if captureSession.canAddInput(videoDeviceInput) {
                captureSession.addInput(videoDeviceInput)
            }
        } catch {
            fatalError("Could not create video device input: \(error.localizedDescription)")
        }
        
        self.captureSession?.sessionPreset = .high
        self.captureSession = captureSession
        captureSession.addOutput(movieOutput)
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.captureSession?.startRunning()
        }
    }
    
    private func prepareCaptureUI() {
        guard let session = captureSession else { return }
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer)
        
        self.videoPreviewLayer = videoPreviewLayer
    }
}

extension TutorialCameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up, options: [:])
        
        do {
            try handler.perform([handPoseRequest])
        } catch {
            print(error)
        }
        
        guard let handPoses = handPoseRequest.results, !handPoses.isEmpty else {
            return
        }
        
        guard let observation = handPoses.first else {return}
        
        frameCounter += 1
        if frameCounter % handPosePredictionInterval == 0 {
            makePrediction(handPoseObservation: observation)
            frameCounter = 0
        }
    }
    
    func makePrediction(handPoseObservation: VNHumanHandPoseObservation) {
        guard let keypointsMultiArray = try? handPoseObservation.keypointsMultiArray() else { fatalError() }
        do {
            let prediction = try model!.prediction(poses: keypointsMultiArray)
            let label = prediction.label
            guard let confidence = prediction.labelProbabilities[label] else { return }
            print("label:\(prediction.label)\nconfidence:\(confidence)")
            if confidence > 0.9 {
                DispatchQueue.main.async { [self] in
                    switch label {
                    case "peace":
                        if tutorialVM.gesture == "PeacePoseBlack" {
                            tutorialVM.gesture = "PeaceOk"
                            tutorialVM.textGesture = "GOOD JOB"
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.tutorialVM.gesture = "FistPoseBlack"
                                self.tutorialVM.textGesture = "STOP recording"
                            }
                        }
                    case "fist":
                        if tutorialVM.gesture == "FistPoseBlack" {
                            tutorialVM.gesture = "FistPose"
                            tutorialVM.textGesture = "WELL DONE"
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.tutorialVM.gesture = "OkPoseBlack"
                                self.tutorialVM.textGesture = "Now TAKE A PICTURE"
                            }
                        }
                    case "okay":
                        if tutorialVM.gesture == "OkPoseBlack" {
                            tutorialVM.gesture = "OkPose"
                            tutorialVM.textGesture = "GREAT!"
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.tutorialVM.gesture = ""
                            }
                        }
                    default : break
                    }
                }
            }
        } catch {
            print("Prediction error")
        }
    }
}

extension TutorialCameraViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        guard let image = UIImage(data: imageData) else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}

extension TutorialCameraViewController: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print("Started recording to \(fileURL)")
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error recording video: \(error.localizedDescription)")
        } else {
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
                    }) { success, error in
                        if success {
                            print("Video saved to photos")
                        } else {
                            print("Error saving video to photos: \(error?.localizedDescription ?? "unknown error")")
                        }
                    }
                } else {
                    print("Access to photo library denied")
                }
            }
        }
    }
}

struct TutorialHostedViewController: UIViewControllerRepresentable {
    
    var tutorialVM: TutorialCameraViewModel
    
    func makeUIViewController(context: Context) -> TutorialCameraViewController {
        return TutorialCameraViewController(tutorialVM: tutorialVM)
        }

        func updateUIViewController(_ uiViewController: TutorialCameraViewController, context: Context) {
        }
}
