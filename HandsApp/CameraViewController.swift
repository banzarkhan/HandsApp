//
//  CameraViewController.swift
//  HandsApp
//
//  Created by Ariuna Banzarkhanova on 27/02/23.
//

import UIKit
import Foundation
import SwiftUI
import AVFoundation
import Vision
import Photos
import SnapKit
import AVKit


class CameraViewController: UIViewController {
    var audioPlayer: AVAudioPlayer? //for playing  sound
    var audioPlayerVid: AVAudioPlayer?
    var audioPlayerStop: AVAudioPlayer?
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    private let movieOutput = AVCaptureMovieFileOutput()
    private var videoDeviceInput: AVCaptureDeviceInput!

    private let handPoseRequest = VNDetectHumanHandPoseRequest()
    private let recordButton = UIButton()
    private var isRecording = false
    var savedTimer: Timer?
    // Declare a timer and a counter variable to track elapsed time
    var timer: Timer?
    var counter = 0
    
    var currentCameraPosition: AVCaptureDevice.Position = .front //keeping track of the current camera position.
    
    // Declare a UILabel to display the time elapsed
    static let recordLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = UIFont.systemFont(ofSize: 39, weight: .regular)
        label.textColor = UIColor.white
//        label.backgroundColor = UIColor.systemRed
        label.textAlignment = .center
//        label.isHidden = true
        return label
    }()

    
    let savedLabel: UILabel = {
        let label = UILabel()
        label.text = "Video added to photos!"
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 37.5, weight: .regular)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.black
        label.textAlignment = .center
        label.alpha = 0.65
        label.isHidden = true
        return label
    }()

    
    var frameCounter = 0
    let handPosePredictionInterval = 30
    
    let model = try? MyHandPoseClassifier_1(configuration: MLModelConfiguration())

    private weak var timerLabel: UILabel?
    
    private var isTimerRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCaptureSession()
        prepareCaptureUI()
//        setupRecordButton()
        addAudioInput()
        prepareTimerView()
//        prepareBottomControls()
        UIApplication.shared.isIdleTimerDisabled = true
        view.addSubview(CameraViewController.recordLabel)
        CameraViewController.recordLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            CameraViewController.recordLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -49),
            CameraViewController.recordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        view.addSubview(savedLabel)
        savedLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            savedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            savedLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])


        if let sound = Bundle.main.path(forResource: "camera-shutter.mp3", ofType: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
            } catch {
                print("Error loading sound file: \(error.localizedDescription)")
            }
            
        }
        
        if let sound = Bundle.main.path(forResource: "beep.mp3", ofType: "mp3") {
            do {
                audioPlayerVid = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
            } catch {
                print("Error loading sound file: \(error.localizedDescription)")
            }
            
        }

        if let sound = Bundle.main.path(forResource: "stop.mp3", ofType: "mp3") {
            do {
                audioPlayerStop = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
            } catch {
                print("Error loading sound file: \(error.localizedDescription)")
            }
            
        }


        handPoseRequest.maximumHandCount = 1
    }
    
    deinit {
        captureSession?.stopRunning()
        captureSession = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Re-enable idle timer when the app goes into the background or is closed
        UIApplication.shared.isIdleTimerDisabled = false
    }
    

    //  timer to start counting seconds and minutes when recording starts
    func startTimer() {
//        CameraViewController.recordLabel.isHidden = false
        CameraViewController.recordLabel.textColor = .red
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.counter += 1
            CameraViewController.recordLabel.text = self?.formattedTime()
        }
    }
    
    // Stop the timer when recording ends
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        counter = 0
//        CameraViewController.recordLabel.isHidden = true
        CameraViewController.recordLabel.textColor = .white
        CameraViewController.recordLabel.text = "00:00"
    }
    // for every 60 seconds it will add a minute
    func formattedTime() -> String {
        let minutes = counter / 60
        let seconds = counter % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    
    private func prepareCaptureSession() {
        let captureSession = AVCaptureSession()
        
        // Select a front facing camera, make an input.
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
    @objc func toggleCamera() {
        
        // Toggle the camera position
        currentCameraPosition = (currentCameraPosition == .front) ? .back : .front
        
        // Stop the capture session and remove the inputs
        captureSession?.stopRunning()
        for input in captureSession!.inputs {
            captureSession?.removeInput(input)
        }
        
        // Re-add the inputs for the new camera position
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: currentCameraPosition) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession?.addInput(input)
        
        // Add audio input
        addAudioInput()
        // Restart the capture session
        
        DispatchQueue.global(qos: .background).async { [self] in
            captureSession?.startRunning()
        }

    }

    func addAudioInput() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true, options: .init())
            let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)!
            let audioInput = try AVCaptureDeviceInput(device: audioDevice)
            if ((captureSession?.canAddInput(audioInput)) != nil) {
                captureSession!.addInput(audioInput)
            }
        } catch {
            print("Error setting up audio input: \(error.localizedDescription)")
        }
    }

    
    func startRecording() {
       if !movieOutput.isRecording {
           let outputPath = NSTemporaryDirectory() + "output.mov"
           let outputFileURL = URL(fileURLWithPath: outputPath)
           
           movieOutput.startRecording(to: outputFileURL, recordingDelegate: self)
           startTimer()
           audioPlayerVid?.play()

       }
   }
    func stopRecording() {
       if movieOutput.isRecording {
           movieOutput.stopRecording()
           stopTimer()
           self.savedLabel.isHidden = false
           self.savedTimer = Timer.scheduledTimer(withTimeInterval: 2.69 , repeats: false) { _ in
               DispatchQueue.main.async {
                   self.savedLabel.isHidden = true
               }
           }

           audioPlayerStop?.play()
       }
   }



    
    private func prepareTimerView() {
        let timerLabel = UILabel()
        timerLabel.textAlignment = .center
        timerLabel.font = UIFont.systemFont(ofSize: 300)
        
        view.addSubview(timerLabel)
        timerLabel.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }
        
        self.timerLabel = timerLabel
    }
    

    

    
    func captureImage() {
        guard let photoOutput = captureSession?.outputs.first(where: { $0 is AVCapturePhotoOutput }) as? AVCapturePhotoOutput else { return }
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
        
        let shutterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        shutterView.backgroundColor = UIColor.black
        shutterView.alpha = 0.0
        view.addSubview(shutterView)

        UIView.animate(withDuration: 0.1, animations: {
            shutterView.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.13, animations: {
                shutterView.alpha = 0.0
            }, completion: { _ in
                shutterView.removeFromSuperview()
            })
        })

        
        
        audioPlayer?.play()

    }

    private func runTimer(seconds: Int, completion: @escaping () -> Void) {
        isTimerRunning = true

        var timeLeft = seconds
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            self.timerLabel?.text = "\(timeLeft)"
            timeLeft -= 1
            
            if timeLeft < 0 {
                timer.invalidate()
                self.isTimerRunning = false
                self.timerLabel?.text = nil
            
                completion()
            }
        })
        
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
    }
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {

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
                    case "okay":
                        if isTimerRunning == false, isRecording == false {
                            runTimer(seconds: 3, completion: { [weak self] in
                                guard let self else { return }
                                self.captureImage()
                            })
                        }
                    case "peace":
                        if isTimerRunning == false, isRecording == false {
                            runTimer(seconds: 3, completion: { [weak self] in
                                guard let self else { return }
                                
                                print("pinched to start vid")
                                self.startRecording()
                                self.isRecording.toggle()
                            })
                        }
                    case "fist":
                        if isTimerRunning == false, isRecording == true {
                            self.stopRecording()
                            self.isRecording = false
                        
                            
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

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        guard let image = UIImage(data: imageData) else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    
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

struct HostedViewController: UIViewControllerRepresentable {
    
    @ObservedObject var cameraVM: CameraViewModel
    
    func makeUIViewController(context: Context) -> CameraViewController {
        return CameraViewController()
        }

        func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
            if cameraVM.capturePhoto {
                uiViewController.captureImage()
            } else if cameraVM.toggleCamera {
                uiViewController.toggleCamera()
            }
        }
}
