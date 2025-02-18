//
//  GridPad.swift
//  drums-sequencer
//
//  Created by Sergey Kozlov on 17.02.2025.
//

import Foundation
import Combine


let GRID_MAX_COLUMNS = 64
let GRID_MAX_ROWS = 8
let GRID_DEFAULT_COLUMNS = 8
let GRID_DEFAULT_ROWS = 4


class PlayerModel {
    static var shared = PlayerModel()
    var bpm: Double = 120 {
        didSet { bpmSubject.send(bpm) }
    }
    var bpmSubject = PassthroughSubject<Double, Never>()
}


class GridModel {
    static var shared = GridModel()
    
    private(set) var columns = GRID_DEFAULT_COLUMNS {
        didSet { columnsChanged.send(columns) }
    }
    private(set) var rows = GRID_DEFAULT_ROWS {
        didSet { rowsChanged.send(rows) }
    }
    
    private(set) var pads: [[Pad]]
    private(set) var indicators: [Pad]
    
    var flattenedPadsArray: [Pad] {
        let allRows = pads.flatMap { Array($0.prefix(columns)) }
        return Array(allRows.prefix(rows * columns))
    }
    
    
    init() {
        self.pads = (0..<GRID_MAX_ROWS).map { _ in
            (0..<GRID_MAX_COLUMNS).map { _ in Pad() }
        }
        
        self.indicators = (0..<columns).map { _ in Pad() }
    }
    
    func canDoubleColumns() -> Bool { return columns < GRID_MAX_COLUMNS }
    
    func doubleColumns() {
        guard canDoubleColumns() else { return }
        columns *= 2
    }
    
    func canAddRow() -> Bool { return rows < GRID_MAX_ROWS }
    
    func addRow() {
        guard canAddRow() else { return }
        rows += 1
    }
    
    func tooglePad(row: Int, column: Int) {
        pads[row][column].isActive.toggle()
    }
    
    func tooglePad(index: Int) {
        let column = index % columns
        let row = index / columns
        pads[row][column].isActive.toggle()
    }
    
    func lightIndicator(noteNumber: Int) {
        for i in indicators.indices {
            indicators[i].isActive = i == noteNumber
        }
        indicatorsUpdated.send(indicators)
    }
    
//    func pad(index: Int) -> Pad {
//        let column = index % columns
//        let row = index / columns
//        return pads[row][column]
//    }
    
    func pad(uuid: UUID) -> Pad {
        return flattenedPadsArray.first(where: { pad in uuid == pad.id })!
    }
    
    func indicator(uuid: UUID) -> Pad {
        return indicators.first(where: { pad in uuid == pad.id })!
    }
    
    
    var columnsChanged = PassthroughSubject<Int, Never>()
    var rowsChanged = PassthroughSubject<Int, Never>()
    var indicatorsUpdated = PassthroughSubject<[Pad], Never>()
}



struct Pad {
    var isActive = false
    var id = UUID()
}


