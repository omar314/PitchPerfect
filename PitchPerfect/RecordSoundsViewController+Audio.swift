//
//  RecordSoundsViewController+PitchPerfect.swift
//  PitchPerfect
//
//  Created by Omar Gonzalez on 3/7/17.
//  Copyright © 2017 Omar. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension RecordSoundsViewController {
  
  internal func getFilePath() -> URL {
    
    let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
    let recordingName = "recordedVoice.wav"
    let pathArray = [dirPath, recordingName]
    let filePath = URL(string: pathArray.joined(separator: "/"))
    
    return filePath!
  }
  
  internal func record(with delegate: AVAudioRecorderDelegate) {

    audioRecorder?.delegate = delegate
    audioRecorder?.prepareToRecord()
    audioRecorder?.record()
  }
  
  internal func stopRecording() {

    
    audioRecorder?.stop()
  }
  
  func toggleRecordingUI(recordingAllowed: Bool) {
    
    recordButton.alpha = recordingAllowed ? 1.0 : 0.4
    stopButton.alpha = recordingAllowed ? 1.0 : 0.4
    recordButton.isUserInteractionEnabled = recordingAllowed
    stopButton.isUserInteractionEnabled = recordingAllowed
    instructionsLabel.text = recordingAllowed ? "TAP TO RECORD" : "RECORDING DISABLED"
  }
  
  func toggleRecordingState(on: Bool) {
    
    recordButton.isEnabled = !on
    stopButton.isEnabled = on
    instructionsLabel.text = on ? "RECORDING ..." : "TAP TO RECORD"
  }
}

extension RecordSoundsViewController: AVAudioRecorderDelegate {
  
  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    
    if flag {
      
      performSegue(withIdentifier: "playRecording", sender: recorder.url)
    } else {
      
      toggleRecordingState(on: false)
      instructionsLabel.text = "RECORDING FAILED"
    }
  }
}
