//
//  ContentView.swift
//  mictest
//
//  Created by Artiom Shapovalov on 21.01.2022.
//

import SwiftUI
import AVFoundation
import GameKit

struct ContentView: View {
  private var audioEngine: AVAudioEngine!
  private var mic: AVAudioInputNode!
  @State private var micTapped = false
  @State private var counter   = 0
  
  private var micTappedBinding: Binding<Bool> {
    Binding { micTapped } set: {
      micTapped = $0
      if $0 {
        let micFormat = mic.inputFormat(forBus: 0)
        mic.installTap(onBus: 0, bufferSize: 2048, format: micFormat) { (buffer, when) in
          debugPrint(counter)
          counter += 1
        }
        do {
          try audioEngine.start()
        } catch { }
      } else {
        mic.removeTap(onBus: 0)
        audioEngine.stop()
        audioEngine.reset()
      }
    }
  }
  
  init() {
    configureAudioSession()
    audioEngine = AVAudioEngine()
    mic = audioEngine.inputNode
  }
  
  private func configureAudioSession() {
    do {
      // AVAudioSession configuration that works for specific games
      
      // CODM
      
      // .playAndRecord
      // [.mixWithOthers, .defaultToSpeaker]
      
      // FREE FIRE
      
      // Nothing works
      
      try AVAudioSession
        .sharedInstance()
        .setCategory(
          AVAudioSession.Category.playAndRecord,
          options: [.mixWithOthers, .defaultToSpeaker]
          // options: []
          // options: [.mixWithOthers]
          // options: [.mixWithOthers, .defaultToSpeaker]
          // options: [.mixWithOthers, .overrideMutedMicrophoneInterruption]
          // options: [.mixWithOthers, .allowAirPlay]
          // options: [.mixWithOthers, .allowBluetooth]
          // options: [.mixWithOthers, .allowBluetoothA2DP]
          // options: [.mixWithOthers, .duckOthers]
          // options: [.defaultToSpeaker]
        )
      try AVAudioSession.sharedInstance().setActive(true)
      try AVAudioSession.sharedInstance().setMode(.gameChat)
    } catch { }
  }
  
  var body: some View {
    VStack {
      HStack(spacing: 20) {
        Button(micTapped ? "Stop mic" : "Start mic") {
          micTappedBinding.wrappedValue.toggle()
        }
        
        if counter > 0 {
          Button("Clear") {
            micTappedBinding.wrappedValue = false
            counter = 0
          }
        }
      }
      .padding()
      
      Text("Samples: \(counter)")
    }
  }
}
