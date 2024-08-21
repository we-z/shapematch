//
//  AudioManager.swift
//  shape match
//
//  Created by Wheezy Capowdis on 8/20/24.
//

import Foundation
import AVFoundation

let muteKey = "Mute"

class AudioManager: ObservableObject {
    static let sharedAudioManager = AudioManager()
    @Published var musicPlayer: AVAudioPlayer!
    
    init() {
        setUpAudioFiles()
    }
    
    func setUpAudioFiles() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting up audio session: \(error)")
        }
        if let music = Bundle.main.path(forResource: "ShapeMatchMusic", ofType: "mp3"){
            do {
                self.musicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: music))
                self.musicPlayer.numberOfLoops = -1
                self.musicPlayer.enableRate = true
                self.musicPlayer.play()
            } catch {
                print("Error playing audio: \(error)")
            }
        }
    }
    
}
