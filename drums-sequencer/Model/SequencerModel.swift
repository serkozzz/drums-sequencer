//
//  SequencerModel.swift
//  drums-sequencer
//
//  Created by Sergey Kozlov on 18.02.2025.
//

import Combine


class SequencerModel {
    static var shared = SequencerModel()
    
    var grid = GridModel()
    var bpm: Double = 120 {
        didSet { bpmSubject.send(bpm) }
    }
    var bpmSubject = PassthroughSubject<Double, Never>()
}
