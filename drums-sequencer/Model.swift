//
//  GridPad.swift
//  drums-sequencer
//
//  Created by Sergey Kozlov on 17.02.2025.
//

import Foundation

let GRID_MAX_COLUMNS = 8
let GRID_MAX_ROWS = 4
let GRID_DEFAULT_COLUMNS = 8
let GRID_DEFAULT_ROWS = 4


class GridModel {
    static var shared = GridModel()

    private(set) var columns = GRID_DEFAULT_COLUMNS
    private(set) var rows = GRID_DEFAULT_ROWS
    
    private(set) var pads: [[Pad]]
    var flattenedPadsArray: [Pad] { pads.flatMap { $0 } }
    
    
    init() {
        self.pads = (0..<GRID_MAX_ROWS).map { _ in
            (0..<GRID_MAX_COLUMNS).map { _ in Pad() }
        }
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
        var column = index % columns
        var row = index / columns
        pads[row][column].isActive.toggle()
    }
    
    func pad(index: Int) -> Pad {
        var column = index % columns
        var row = index / columns
        return pads[row][column]
    }
}



struct Pad : Hashable {
    var isActive = false
    var id = UUID()
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Pad, rhs: Pad) -> Bool {
        return lhs.id == rhs.id
    }
}
