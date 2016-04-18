//
//  TrackSolution.swift
//  SudokuTest
//
//  Created by Graham Watson on 14/04/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

class TrackSolution: NSObject, NSCopying {
    
    private var userSupplied: [(boardRows: Int, boardColumns: Int, cellRows: Int, cellColumns: Int)] = []
    private var maxBoardRows: Int
    private var maxBoardColumns: Int
    private var maxCellRows: Int
    private var maxCellColumns: Int
    
    init(boardRows: Int, boardColumns: Int, cellRows: Int, cellColumns: Int) {
        self.maxBoardRows = boardRows
        self.maxBoardColumns = boardColumns
        self.maxCellRows = cellRows
        self.maxCellColumns = cellColumns
        return
    }
    
    func addCoordinateToSolution(boardRow: Int, boardColumn: Int, cellRow: Int, cellColumn: Int) {
        if boardRow < 0 || boardColumn < 0 || cellRow < 0 || cellColumn < 0 {
            return
        }
        if boardRow >= self.maxBoardRows || boardColumn >= self.maxBoardColumns || cellRow >= self.maxCellRows || cellColumn >= self.maxCellColumns {
            return
        }
        userSupplied.append((boardRow, boardColumn, cellRow, cellColumn))
        return
    }

    func removeCoordinateFromSolution(boardRow: Int, boardColumn: Int, cellRow: Int, cellColumn: Int) {
        if boardRow < 0 || boardColumn < 0 || cellRow < 0 || cellColumn < 0 {
            return
        }
        if boardRow >= self.maxBoardRows || boardColumn >= self.maxBoardColumns || cellRow >= self.maxCellRows || cellColumn >= self.maxCellColumns {
            return
        }
        for index: Int in 0 ..< self.userSupplied.count {
            if userSupplied[index].boardRows == boardRow && userSupplied[index].boardColumns == boardColumn && userSupplied[index].cellRows == cellRow && userSupplied[index].cellColumns == cellColumn {
                userSupplied.removeAtIndex(index)
            }
        }
        return
    }

    func countOfUserSolution() -> Int {
        return userSupplied.count
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = TrackSolution(boardRows: self.maxBoardRows, boardColumns: self.maxBoardColumns, cellRows: self.maxCellRows, cellColumns: self.maxCellColumns)
        for coords in self.userSupplied {
            copy.userSupplied.append(coords)
        }
        copy.maxBoardRows = self.maxBoardRows
        copy.maxBoardColumns = self.maxBoardColumns
        copy.maxCellRows = self.maxCellRows
        copy.maxCellColumns = self.maxCellColumns
        return copy
    }
    
}