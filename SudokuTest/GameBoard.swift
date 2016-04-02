//
//  GameBoard.swift
//  SudokuTest
//
//  Created by Graham Watson on 02/04/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

class GameBoard: NSObject, NSCopying {
    
    var cells: [[Cell]] = []
    var boardCoordinates: [(row: Int, column: Int)] = []
    var boardRows: Int = 0
    var boardColumns: Int = 0
    var stalls: Int = 0
    
    init (size: Int = 3) {
        super.init()
        self.boardColumns = size
        if self.boardColumns != 3 {
            self.boardColumns = 3
        }
        self.boardRows = self.boardColumns
        for row: Int in 0 ..< boardRows {
            var rowOfCells: [Cell] = [Cell(size: self.boardColumns)]
            for column: Int in 0 ..< boardColumns {
                self.boardCoordinates.append((row, column))
                if column > 0 {
                    rowOfCells.append(Cell(size: self.boardColumns))
                }
            }
            self.cells.append(rowOfCells)
        }
    }

    // private functions
    private func isNumberLegalInPosition(cellRow: Int, cellColumn: Int, rowInCell: Int, columnInCell: Int, number: Int) -> Bool {
        for row: Int in 0 ..< cellRow {
            if self.cells[row][cellColumn].isNumberUsedInColumn(number, column: columnInCell) == true {
                return false
            }
        }
        for column: Int in 0 ..< cellColumn {
            if self.cells[cellRow][column].isNumberUsedInRow(number, row: rowInCell) == true {
                return false
            }
        }
        return true
    }

    private func buildCell(row: Int, column: Int) -> Bool {
        var stalled: Int = 0
        while self.cells[row][column].isCellCompleted() == false {
            // get an unused row/cell location and an unused number
            let unUsedPosition: (unUsedRow: Int, unUsedColumn: Int) = self.cells[row][column].getRandomUnUsedPosition()
            let unUsedNumber: Int = self.cells[row][column].getRandomUnUsedNumber()
            // check if the unused number can exist in that location by checking adjacent cells
            if isNumberLegalInPosition(row, cellColumn: column, rowInCell: unUsedPosition.unUsedRow, columnInCell: unUsedPosition.unUsedColumn, number: unUsedNumber) == true {
                self.cells[row][column].setNumberAtCellPosition(unUsedPosition.unUsedRow, column: unUsedPosition.unUsedColumn, number: unUsedNumber)
                stalled = 0
            } else {
                stalled += 1
                if stalled > 32 {
                    return false
                }
            }
        }
        return true
    }

    // public functions
    func clearBoard() {
        for index: Int in 0 ..< self.boardCoordinates.count {
            self.cells[self.boardCoordinates[index].row][self.boardCoordinates[index].column].clearCell()
        }
        return
    }
    
    func isBoardCompleted() -> Bool {
        for index: Int in 0 ..< self.boardCoordinates.count {
            if self.cells[self.boardCoordinates[index].row][self.boardCoordinates[index].column].isCellCompleted() == false {
                return false
            }
        }
        return true
    }

    func buildSolution() {
        var index: Int = 0
        self.stalls = 0
        while (self.isBoardCompleted() == false) {
            if buildCell(self.boardCoordinates[index].row, column: self.boardCoordinates[index].column) == true {
                print("Completed cell at (\(self.boardCoordinates[index].row),\(self.boardCoordinates[index].column)) ")
                index += 1
            } else {
                self.stalls += 1
                var i: Int = index
                while i > 0 {
                    self.cells[self.boardCoordinates[i].row][self.boardCoordinates[i].column].clearCell()
                    i -= 1
                }
                print("Stalled, reseting")
                index = 0
            }
        }
        return
    }
    
    func dumpBoard() -> String {
        if self.isBoardCompleted() == false {
            return "Board is not completed"
        }
        var dumpOfBoard: String = ""
        for boardRow: Int in 0 ..< 3 {
            dumpOfBoard += "\nBoard row: \(boardRow)\n"
            for cellRow: Int in 0 ..< 3 {
                var dumpOfCellRow: String = ""
                for boardColumn: Int in 0 ..< 3 {
                    let cellColumns: [Int] = self.cells[boardRow][boardColumn].getValuesFromRow(cellRow)
                    dumpOfCellRow += " |"
                    for i: Int in 0 ..< cellColumns.count {
                        dumpOfCellRow += " \(cellColumns[i])"
                    }
                    dumpOfCellRow += " |"
                }
                dumpOfBoard += "\n" + dumpOfCellRow
            }
            dumpOfBoard += "\n"
        }
        return dumpOfBoard
    }
    
    func getNumberFromBoard(boardRow: Int, boardColumn: Int, cellRow: Int, cellColumn: Int) -> Int {
        if boardRow < 0 || boardRow >= self.boardRows || boardColumn < 0 || boardColumn >= self.boardColumns {
            return 0
        }
        if cellRow < 0 || cellRow >= self.cells[boardRow][boardColumn].cellDepth() || cellColumn < 0 || cellColumn >= self.cells[boardRow][boardColumn].cellWidth() {
            return 0
        }
        return self.cells[boardRow][boardColumn].getNumberAtCellPosition(cellRow, column: cellColumn)
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = GameBoard(size: self.boardColumns)
        for row: Int in 0 ..< self.boardRows {
            var rowOfCells: [Cell] = [self.cells[row][0].copy() as! Cell]
            for column: Int in 1 ..< self.boardColumns {
                rowOfCells.append(self.cells[row][column].copy() as! Cell)
            }
            copy.cells.append(rowOfCells)
        }
        for index: Int in 0 ..< self.boardCoordinates.count {
            copy.boardCoordinates.append(self.boardCoordinates[index])
        }
        copy.boardRows = self.boardRows
        copy.boardColumns = self.boardColumns
        copy.stalls = self.stalls
        return copy
    }
    
}