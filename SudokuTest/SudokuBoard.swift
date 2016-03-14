//
//  SudokuBoard.swift
//  SudokuTest
//
//  Created by Graham Watson on 06/03/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

class SudokuBoard {
    var cells: [[SudokuCell]] = []
    let boardCoords: [(row: Int, column: Int)] = [(0,0), (0,1), (0,2), (1,0), (1,1), (1,2), (2,0), (2,1), (2,2)]

    init () {
        // allocate the row of arraysfirst row of cells
        var row: [SudokuCell] = [SudokuCell()]
        row.append(SudokuCell())
        row.append(SudokuCell())
        cells.append(row)
        // 2nd
        row = [SudokuCell()]
        row.append(SudokuCell())
        row.append(SudokuCell())
        cells.append(row)
        // final
        row = [SudokuCell()]
        row.append(SudokuCell())
        row.append(SudokuCell())
        cells.append(row)
    }
    
    func clearBoard() {
        for var index: Int = 0; index < self.boardCoords.count; index++ {
            cells[self.boardCoords[index].row][self.boardCoords[index].column].clearCell()
        }
        return
    }
    
    func isBoardComplete() -> Bool {
        for var index: Int = 0; index < self.boardCoords.count; index++ {
            if cells[self.boardCoords[index].row][self.boardCoords[index].column].isCellComplete() == false {
                return false
            }
        }
        return true
    }

    func checkNumberValidInPosition(cellRow: Int, cellColumn: Int, rowInCell: Int, columnInCell: Int, numberToCheck: Int) -> Bool {
        for var row: Int = 0; row < cellRow; row++ {
            if self.cells[row][cellColumn].isNumberUsedInRow(numberToCheck, row: rowInCell) == true {
                return false
            }
        }
        for var column: Int = 0; column < cellColumn; column++ {
            if self.cells[cellRow][column].isNumberUsedInColumn(numberToCheck, column: columnInCell) == true {
                return false
            }
        }
        return true
    }
    
    func buildCell(row: Int, column: Int) -> Bool {
        var stalled: Int = 0
        while self.cells[row][column].isCellComplete() == false {
            // get an unused row/cell location and an unused number
            let unUsedPosition: (unUsedRow: Int, unUsedColumn: Int) = self.cells[row][column].getRandomUnUsedPosition()
            let unUsedNumber: Int = self.cells[row][column].getRandomUnUsedNumber()
            // check if the unused number can exist in that location by checking adjacent cells
            if checkNumberValidInPosition(row, cellColumn: column, rowInCell: unUsedPosition.unUsedRow, columnInCell: unUsedPosition.unUsedColumn, numberToCheck: unUsedNumber) == true {
                self.cells[row][column].setNumberAtCellPosition(unUsedPosition.unUsedRow, column: unUsedPosition.unUsedColumn, number: unUsedNumber)
                stalled = 0
            } else {
                stalled += 1
                if stalled > 100 {
                    return false
                }
            }
        }
        return true
    }
    
    func buildBoard() {
        var index: Int = 0
        while (self.isBoardComplete() == false) {
            if buildCell(self.boardCoords[index].row, column: self.boardCoords[index].column) == true {
                index++
            } else {
                print("Cell build at (\(self.boardCoords[index].row), \(self.boardCoords[index].column)) stalled, restarting")
                for var i: Int = index; i >= 0; i-- {
                    self.cells[self.boardCoords[i].row][self.boardCoords[i].column].clearCell()
                }
                index = 0
            }
        }
        print("Completed Board Build")
        return
    }
    
    func dumpBoard() -> String {
        if self.isBoardComplete() == false {
            return "Board is not completed"
        }
        var dumpOfBoard: String = ""
        for var boardRow: Int = 0; boardRow < 3; boardRow++ {
            dumpOfBoard += "\nBoard row: \(boardRow)\n"
            for var cellRow: Int = 0; cellRow < 3; cellRow++ {
                var dumpOfCellRow: String = ""
                for var boardColumn: Int = 0; boardColumn < 3; boardColumn++ {
                    let cellColumns: [Int] = self.cells[boardRow][boardColumn].getColumnValuesFromRow(cellRow)
                    dumpOfCellRow += " |"
                    for var i: Int = 0; i < cellColumns.count; i++ {
                        dumpOfCellRow += " \(cellColumns[i])"
                    }
                    dumpOfCellRow += " |"
                }
                dumpOfBoard += "\n" + dumpOfCellRow
            }
        }
        return dumpOfBoard
    }
    
}