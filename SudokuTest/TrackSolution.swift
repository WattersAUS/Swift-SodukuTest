//
//  TrackSolution.swift
//  SudokuTest
//
//  Created by Graham Watson on 14/04/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

class TrackSolution: NSObject, NSCopying {
    
    private var userSupplied: [(boardRow: Int, boardColumn: Int, cellRow: Int, cellColumn: Int)] = []
    private var boardSize: (maxBoardRows: Int, maxBoardColumns: Int, maxCellRows: Int, maxCellColumns: Int) = (-1, -1, -1, -1)
    
    init(boardRows: Int = 3, boardColumns: Int = 3, cellRows: Int = 3, cellColumns: Int = 3) {
        self.boardSize.maxBoardRows = boardRows
        self.boardSize.maxBoardColumns = boardColumns
        self.boardSize.maxCellRows = cellRows
        self.boardSize.maxCellColumns = cellColumns
        return
    }
    
    // only add the coord if in bounds of the board we're tracking, and it hasn't already been added
    func addCoordinate(boardRow: Int, boardColumn: Int, cellRow: Int, cellColumn: Int) -> Int {
        if boardRow < 0 || boardColumn < 0 || cellRow < 0 || cellColumn < 0 {
            return -1
        }
        if boardRow >= self.boardSize.maxBoardRows || boardColumn >= self.boardSize.maxBoardColumns || cellRow >= self.boardSize.maxCellRows || cellColumn >= self.boardSize.maxCellColumns {
            return -1
        }
        if self.getCoordinateIndex(boardRow, boardColumn: boardColumn, cellRow: cellRow, cellColumn: cellColumn) > -1 {
            return -1
        }
        userSupplied.append((boardRow, boardColumn, cellRow, cellColumn))
        return self.userSupplied.count
    }

    func clearCoordinates() {
        self.userSupplied.removeAll()
        return
    }
    
    func countOfUserSolution() -> Int {
        return userSupplied.count
    }

    func getCoordinateAtIndex(index: Int) -> (boardRow: Int, boardColumn: Int, cellRow: Int, cellColumn: Int) {
        if index > self.countOfUserSolution() - 1 {
            return(-1, -1, -1, -1)
        }
        return userSupplied[index]
    }
    
    func getCoordinateIndex(boardRow: Int, boardColumn: Int, cellRow: Int, cellColumn: Int) -> Int {
        for index: Int in 0 ..< self.countOfUserSolution() - 1 {
            if userSupplied[index].boardRow == boardRow && userSupplied[index].boardColumn == boardColumn && userSupplied[index].cellRow == cellRow && userSupplied[index].cellColumn == cellColumn {
                return index
            }
        }
        return -1
    }
    
    func getBoardSize() -> (maxBoardRows: Int, maxBoardColumns: Int, maxCellRows: Int, maxCellColumns: Int) {
        return boardSize
    }
    
    // remove the coord only if in bounds of the board and it's been stored
    func removeCoordinate(boardRow: Int, boardColumn: Int, cellRow: Int, cellColumn: Int) -> Int {
        if boardRow < 0 || boardColumn < 0 || cellRow < 0 || cellColumn < 0 {
            return -1
        }
        if boardRow >= self.boardSize.maxBoardRows || boardColumn >= self.boardSize.maxBoardColumns || cellRow >= self.boardSize.maxCellRows || cellColumn >= self.boardSize.maxCellColumns {
            return -1
        }
        for index: Int in 0 ..< self.countOfUserSolution() - 1 {
            if userSupplied[index].boardRow == boardRow && userSupplied[index].boardColumn == boardColumn && userSupplied[index].cellRow == cellRow && userSupplied[index].cellColumn == cellColumn {
                userSupplied.removeAtIndex(index)
                return self.userSupplied.count
            }
        }
        return -1
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = TrackSolution(boardRows: self.boardSize.maxBoardRows, boardColumns: self.boardSize.maxBoardColumns, cellRows: self.boardSize.maxCellRows, cellColumns: self.boardSize.maxCellColumns)
        for coords in self.userSupplied {
            copy.userSupplied.append(coords)
        }
        copy.boardSize = self.boardSize
        return copy
    }
    
}