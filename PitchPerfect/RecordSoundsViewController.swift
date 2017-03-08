//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Omar Gonzalez on 3/4/17.
//  Copyright © 2017 Omar. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController{
  
  @IBOutlet weak var recordButton: UIButton!
  @IBOutlet weak var stopButton: UIButton!
  @IBOutlet weak var instructionsLabel: UILabel!
  
  lazy var audioRecorder: AVAudioRecorder? = {
    do {
      try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
      
      let audioRecorder = try AVAudioRecorder(url: self.getFilePath(), settings: [:])
      audioRecorder.isMeteringEnabled = true
      return audioRecorder
      
    } catch {
      //Catch
      self.showAlert(Alerts.AudioFileError, message: String(describing: error))
      return nil
    }
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    toggleRecordingState(on: false)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    checkRecordingPermissions()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  internal func checkRecordingPermissions() {
    
    do {
      try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
      try AVAudioSession.sharedInstance().setActive(true)
      AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
        DispatchQueue.main.async {
          self.toggleRecordingUI(recordingAllowed: allowed)
        }
      })
    } catch {
      DispatchQueue.main.async {
        self.toggleRecordingUI(recordingAllowed: false)
      }
    }
  }  
  
  @IBAction func recordButtonPressed(_ sender: Any) {

    toggleRecordingState(on: true)
    record(with: self)
  }
  
  @IBAction func stopButtonPressed(_ sender: Any) {

    toggleRecordingState(on: false)
    stopRecording()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if
      let vc = segue.destination as? PlaySoundsViewController,
      let recordedAudioURL = sender as? URL {
      
      vc.recordedAudioURL = recordedAudioURL
    }
  }
}

