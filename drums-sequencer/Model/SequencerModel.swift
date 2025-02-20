//
//  SequencerModel.swift
//  drums-sequencer
//
//  Created by Sergey Kozlov on 18.02.2025.
//

import Combine


class SequencerModel {
    static var shared = SequencerModel()
    
    var instruments: [InstrumentModel] = [
        InstrumentModel(name: "kick", imageName: "kick.jpg", audioFileName: "kick.wav"),
        InstrumentModel(name: "snare", imageName: "snare.jpg", audioFileName: "snare.wav"),
        InstrumentModel(name: "hat", imageName: "hat.jpg", audioFileName: "hat.wav"),
        InstrumentModel(name: "hat-opened", imageName: "hat-opened.jpg", audioFileName: "hat-opened.wav"),
        InstrumentModel(name: "crash", imageName: "crash.jpg", audioFileName: "crash.wav")]
    
    
    var grid: GridModel
    var bpm: Double = 120 {
        didSet { bpmSubject.send(bpm) }
    }
    
    init () {
        grid = GridModel(instrumentsCount: instruments.count)
    }
    var bpmSubject = PassthroughSubject<Double, Never>()
}
