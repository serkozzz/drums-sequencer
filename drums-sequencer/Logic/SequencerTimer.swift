//
//  SequencerTimer.swift
//  drums-sequencer
//
//  Created by Sergey Kozlov on 18.02.2025.
//
import Foundation
import AVFoundation

class SequencerTimer {
    
    var interval: TimeInterval = 1/2
    var notesCounter: Int = 0
    private var timer: DispatchSourceTimer?

    init() {
        // Подписка на изменения BPM
        SequencerModel.shared.bpmSubject.sink { [weak self] bpm in
            self?.updateTimer()
        }
        updateTimer()
    }

    func start() {
        stop() // Останавливаем старый таймер перед запуском нового

        let queue = DispatchQueue(label: "sequencer.timer", qos: .userInteractive)
        timer = DispatchSource.makeTimerSource(queue: queue)
        
        timer?.schedule(deadline: .now(), repeating: interval, leeway: .nanoseconds(0)) // Минимальный `leeway`
        
        timer?.setEventHandler { [weak self] in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if self.notesCounter >= SequencerModel.shared.grid.columns {
                    self.notesCounter = 0
                }

                NotificationCenter.default.post(
                    name: .sequencerTimer,
                    object: nil,
                    userInfo: ["noteNumber": self.notesCounter]
                )
                
                self.notesCounter += 1
            }
        }
        
        timer?.resume() // Запускаем таймер
    }

    func stop() {
        timer?.cancel()
        timer = nil
    }

    func resetTimer() {
        stop()
        notesCounter = 0
        start()
    }

    private func updateTimer() {
        // Always based on 64th notes
        interval = 60 / SequencerModel.shared.bpm / 4
        start() // Перезапускаем таймер при изменении BPM
    }
}

extension Notification.Name {
    static let sequencerTimer = Notification.Name("sequencerTimer")
}

