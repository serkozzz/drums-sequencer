//
//  SequencerTimer.swift
//  drums-sequencer
//
//  Created by Sergey Kozlov on 18.02.2025.
//

import Foundation


class SequencerTimer {
    
    static var shared = SequencerTimer()
    
    var interval: TimeInterval = 1/2
    var notesCounter: Int = 0
    var timer: Timer?
    
    init(){
        PlayerModel.shared.bpmSubject.sink { [weak self] bpm in
            self?.updateTimer()
        }
//        GridModel.shared.columnsChanged.sink{ _ in }
//        GridModel.shared.rowsChanged.sink{ _ in }
        updateTimer()
    }

    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) {[weak self] _ in
            guard let self = self else { return }
            
            if (notesCounter >= GridModel.shared.columns) {
                notesCounter = 0
            }
                
            NotificationCenter.default.post(name: .sequencerTimer, object: nil, userInfo: ["noteNumber": notesCounter])
            notesCounter += 1
        }
    }
    
    func pause() {
        
    }
    
    func resetTimer() {
        
    }
    
    private func updateTimer() {
        //always based on 64th notes
        interval = 60 / PlayerModel.shared.bpm / 4
    }
}

extension Notification.Name {
    static let sequencerTimer = Notification.Name("sequencerTimer")
}
