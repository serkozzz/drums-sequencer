//
//  SequencerManager.swift
//  drums-sequencer
//
//  Created by Sergey Kozlov on 18.02.2025.
//

import Foundation

class SequencerManager {
    
    static let shared = SequencerManager()
    
    var sequencerTimer = SequencerTimer()
    var soundsPlayer = SoundsPlayer()
    init() {
        prepareAudioStorage()
        NotificationCenter.default.addObserver(self, selector: #selector(tick(_:)), name: .sequencerTimer, object: nil)
    }
    
    private func prepareAudioStorage() {
        do {
            let url = Bundle.main.url(forResource: Globals.AUDIO_STORAGE_ROOT, withExtension: nil)!
            try ContentLoader.shared.loadAudioStorage(dirURL: url)
        }
        catch { print("ContentLoader.\(#function) Ошибка загрузки audioStorage: \(error)") }
    }
    
    func play() {
        sequencerTimer.start()
    }
    
    func stop()
    {
        sequencerTimer.stop()
    }
    
    
    @objc func tick(_ notification: Notification) {
        if let noteNumber = notification.userInfo?["noteNumber"] as? Int {
            print("noteNumber \(noteNumber)")
            let grid = SequencerModel.shared.grid
            grid.lightIndicator(noteNumber: noteNumber)
            
            for i in 0..<grid.rows {
                if grid.pads[i][noteNumber].isActive {
                    soundsPlayer.play(instrumentNumber: i)
                }
            }
        }
    }
}
