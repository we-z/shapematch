//
//  AudioManager.swift
//  shape match
//
//  Created by Wheezy Capowdis on 8/20/24.
//

import Foundation
import AVFoundation

let musicOnKey = "musicOnKey"

class AudioManager: ObservableObject {
    static let sharedAudioManager = AudioManager()
    @Published var musicPlayer: AVAudioPlayer!
    
    init() {
        getAudioSetting()
        setUpAudioFiles()
        setAllAudioVolume()
    }
    
    @Published var musicOn: Bool = true {
        didSet{
            saveAudiotSetting()
        }
    }
    
    func saveAudiotSetting() {
        if let musicOnSetting = try? JSONEncoder().encode(musicOn){
            UserDefaults.standard.set(musicOnSetting, forKey: musicOnKey)
        }
    }
    
    func getAudioSetting(){
        guard
            let musicOnData = UserDefaults.standard.data(forKey: musicOnKey),
            let savedMusicOnSetting = try? JSONDecoder().decode(Bool.self, from: musicOnData)
        else {return}
        
        self.musicOn = savedMusicOnSetting
    }
    
    func setAllAudioVolume() {
        if musicOn == true {
            self.musicPlayer.setVolume(1, fadeDuration: 0)
        } else {
            self.musicPlayer.setVolume(0, fadeDuration: 0)
        }
    }
    
    func setUpAudioFiles() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
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
