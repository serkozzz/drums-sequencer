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
        NotificationCenter.default.addObserver(self, selector: #selector(tick(_:)), name: .sequencerTimer, object: nil)
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
            var grid = SequencerModel.shared.grid
            grid.lightIndicator(noteNumber: noteNumber)
            soundsPlayer.play(instrumentNumber: 0)
        }
    }
}
