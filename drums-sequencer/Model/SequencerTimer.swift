//
//  SequencerTimer.swift
//  drums-sequencer
//
//  Created by Sergey Kozlov on 18.02.2025.
//

import Foundation


class SequencerTimer {
    
    var interval: TimeInterval = 1/2
    var notesCounter: Int = 0
    var timer: Timer?
    
    init(){
        SequencerModel.shared.bpmSubject.sink { [weak self] bpm in
            self?.updateTimer()
        }
//        GridModel.shared.columnsChanged.sink{ _ in }
//        GridModel.shared.rowsChanged.sink{ _ in }
        updateTimer()
    }

    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) {[weak self] _ in
            guard let self = self else { return }
            
            if (notesCounter >= SequencerModel.shared.grid.columns) {
                notesCounter = 0
            }
                
            NotificationCenter.default.post(name: .sequencerTimer, object: nil, userInfo: ["noteNumber": notesCounter])
            notesCounter += 1
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    func resetTimer() {
        
    }
    
    private func updateTimer() {
        //always based on 64th notes
        interval = 60 / SequencerModel.shared.bpm / 4
    }
}

extension Notification.Name {
    static let sequencerTimer = Notification.Name("sequencerTimer")
}
