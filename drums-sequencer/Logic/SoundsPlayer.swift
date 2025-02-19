//
//  SoundsPlayer.swift
//  drums-sequencer
//
//  Created by Sergey Kozlov on 18.02.2025.
//

import Foundation

class SoundsPlayer {
    
    private var instruments = [ "kick.wav", "snare.wav", "hat.wav", "crash.wav"]
    
    init() {
        do {
            let url = Bundle.main.url(forResource: Globals.AUDIO_STORAGE_ROOT, withExtension: nil)!
            try ContentLoader.shared.loadAudioStorage(dirURL: url)
        }
        catch { print("ContentLoader.\(#function) Ошибка загрузки audioStorage: \(error)") }
    }
    
    func play(instrumentNumber: Int) {
        let wavURL = urlForAudio(instruments[instrumentNumber])
        //Audio.shared.playWAV(url: wavURL )
        Audio.shared.playLoadedSound()
    }
    
    private func urlForAudio(_ fileName: String) -> URL {
        let tempDir = FileManager.default.temporaryDirectory
        let result = tempDir.appending(component: Globals.AUDIO_STORAGE_ROOT).appending(component: fileName)
        return result
    }
    
}
