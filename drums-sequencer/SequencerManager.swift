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
            GridModel.shared.lightIndicator(noteNumber: noteNumber)
        }
    }
}
