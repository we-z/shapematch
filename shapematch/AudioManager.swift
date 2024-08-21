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
        getAudioSetting()
        setUpAudioFiles()
        setAllAudioVolume()
    }
    
    @Published var mute: Bool = false {
        didSet{
            saveAudiotSetting()
        }
    }
    
    func saveAudiotSetting() {
        if let muteSetting = try? JSONEncoder().encode(mute){
            UserDefaults.standard.set(muteSetting, forKey: muteKey)
        }
    }
    
    func getAudioSetting(){
        guard
            let muteData = UserDefaults.standard.data(forKey: muteKey),
            let savedMuteSetting = try? JSONDecoder().decode(Bool.self, from: muteData)
        else {return}
        
        self.mute = savedMuteSetting
    }
    
    func setAllAudioVolume() {
        if mute == true {
            self.musicPlayer.setVolume(0, fadeDuration: 0)
        } else {
            self.musicPlayer.setVolume(1, fadeDuration: 0)
        }
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
