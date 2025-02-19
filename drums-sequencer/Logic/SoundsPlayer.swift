//
//  SoundsPlayer.swift
//  drums-sequencer
//
//  Created by Sergey Kozlov on 18.02.2025.
//

import Foundation
import AVFAudio

class SoundsPlayer {
    
    private let engine = AVAudioEngine()
    private var instruments = [ "kick.wav", "snare.wav", "hat.wav", "crash.wav"]
    private var samplers: [AudioSampler] = []
    
    init() {
        configureAudioSession()
        
        instruments.forEach {
            let wavURL = urlForAudio($0)
            samplers.append(AudioSampler(engine: engine, wavUrl: wavURL))
        }
        startAudioEngine()
    }
    
    
    func play(instrumentNumber: Int) {
        let wavURL = urlForAudio(instruments[instrumentNumber])
        //Audio.shared.playWAV(url: wavURL )
        samplers[instrumentNumber].play()
    }
    
    private func urlForAudio(_ fileName: String) -> URL {
        let tempDir = FileManager.default.temporaryDirectory
        let result = tempDir.appending(component: Globals.AUDIO_STORAGE_ROOT).appending(component: fileName)
        return result
    }
    
}

extension SoundsPlayer {
    private func startAudioEngine() {
        do {
            try engine.start()
        } catch {
            print("Ошибка запуска AVAudioEngine: \(error.localizedDescription)")
        }
    }
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Ошибка настройки аудиосессии: \(error.localizedDescription)")
        }
    }
}
