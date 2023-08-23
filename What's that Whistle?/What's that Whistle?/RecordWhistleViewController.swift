//
//  RecordWhistleViewController.swift
//  What's that Whistle?
//
//  Created by Tony Alhwayek on 8/22/23.
//

import AVFoundation
import UIKit

class RecordWhistleViewController: UIViewController, AVAudioRecorderDelegate {
    
    var stackView: UIStackView!
    
    // Elements for recording and playback
    var recordButton: UIButton!
    var playButton: UIButton!
    var recordingSession: AVAudioSession!
    var whistleRecorder: AVAudioRecorder!
    var whistlePlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Record your whistle"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Record", style: .plain, target: nil, action: nil)
        
        recordingSession = AVAudioSession.sharedInstance()
        
        // Ask for permission
        // If accepted, show recording UI
        // If denied, or an error was encountered, show fail UI
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        self.loadFailUI()
                    }
                }
            }
        } catch {
            self.loadFailUI()
        }
    }
    
    // Load view with specific components and customizations
    override func loadView() {
        view = UIView()
        view.backgroundColor = .gray
        
        // Create and customize stack view
        stackView = UIStackView()
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.alignment = .center
        stackView.axis = .vertical
        view.addSubview(stackView)
        
        // Set stack view constraints
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
    // UI functions
    // If the user granted mic permission
    // Allow them to record
    func loadRecordingUI() {
        // Add recording button
        recordButton = UIButton()
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.setTitle("Tap to Record", for: .normal)
        recordButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        recordButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
        stackView.addArrangedSubview(recordButton)
        
        // Add play button
        playButton = UIButton()
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setTitle("Tap to Play", for: .normal)
        // Hide button until needed
        playButton.isHidden = true
        playButton.alpha = 0
        playButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        stackView.addArrangedSubview(playButton)
    }
    
    // If user denied mic permission
    // Show user why they can't record
    func loadFailUI() {
        let failLabel = UILabel()
        failLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        failLabel.text = "Recording failed: Please ensure the app has access to your microphone."
        failLabel.numberOfLines = 0
        stackView.addArrangedSubview(failLabel)
    }
    
    // Note: Class functions are called on the class, not on an instance of the class
    // File access functions
    // Find a place to save data
    class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    // Add data to documents directory
    class func getWhistleURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent("whistle.m4a")
    }
    
    // Recording functions
    // When user starts recording
    func startRecording() {
        view.backgroundColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 1)
        recordButton.setTitle("Tap to Stop", for: .normal)
        
        let audioURL = RecordWhistleViewController.getWhistleURL()
        print(audioURL.absoluteString)
        
        let settings = [
            // Set audio format as AAC
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            // Set bite rate
            AVSampleRateKey: 12000,
            // Set number of channels (mono audio in this case)
            AVNumberOfChannelsKey: 1,
            // Set audio quality
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            whistleRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
            whistleRecorder.delegate = self
            whistleRecorder.record()
        } catch {
            finishRecording(success: false)
        }
    }
    
    // When recording is finished
    func finishRecording(success: Bool) {
        view.backgroundColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)
        
        whistleRecorder.stop()
        whistleRecorder = nil
        
        if success {
            // Ask if user wants to rewrite their recording
            recordButton.setTitle("Tap to re-record", for: .normal)
            
            // Reveal play button
            if playButton.isHidden {
                // Animate revealing the play button
                UIView.animate(withDuration: 0.35, animations: { [unowned self] in
                    self.playButton.isHidden = false
                    self.playButton.alpha = 1
                })
            }
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextTapped))
        } else {
            recordButton.setTitle("Tap to Record", for: .normal)
            
            // Show an alert
            let failedAC = UIAlertController(title: "Recording failed", message: "There was a problem recording your whistle; please try again.", preferredStyle: .alert)
            failedAC.addAction(UIAlertAction(title: "OK", style: .default))
            present(failedAC, animated: true)
        }
    }
    
    // Called when record button is tapped
    @objc func recordTapped() {
        // If no recording session is already taking place
        if whistleRecorder == nil {
            startRecording()
            
            // Hide play button while recording
            if !playButton.isHidden {
                UIView.animate(withDuration: 0.35, animations: { [unowned self] in
                    self.playButton.isHidden = true
                    self.playButton.alpha = 0
                })
            }
        } else {
            finishRecording(success: true)
        }
    }
    
    // When play button is tapped
    @objc func playTapped() {
        let audioURL = RecordWhistleViewController.getWhistleURL()
        
        // Try playing the recorded audio
        do {
            whistlePlayer = try AVAudioPlayer(contentsOf: audioURL)
            whistlePlayer.play()
        } catch {
            let failedAC = UIAlertController(title: "Playback failed", message: "There was a problem playing your whistle; please try re-recording.", preferredStyle: .alert)
            failedAC.addAction(UIAlertAction(title: "OK", style: .default))
            present(failedAC, animated: true)
        }
    }
    
    @objc func nextTapped() {
        
    }
    
    // If record did not finish successfully
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}
