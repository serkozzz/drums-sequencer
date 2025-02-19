//
//  AudioPlayer.swift
//  easy-peasy
//
//  Created by Sergey Kozlov on 10.01.2025.
//

import AVFoundation

class Audio {
    
    static var shared = Audio()
    var audioPlayer: AVAudioPlayer!
    
    init() {
        configureAudioSession()
    }
    
    func playMP3(url: URL) {
        
        do {
            // Инициализация аудиоплеера
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = 0.5
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch {
            print("Ошибка воспроизведения: \(error.localizedDescription)")
        }
    }
    
    func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Ошибка настройки аудиосессии: \(error.localizedDescription)")
        }
    }
    
}
