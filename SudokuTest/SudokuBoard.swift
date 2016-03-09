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

        self.buildBoard()
    }
    
    func clearBoard() {
        for var row = 0; row < 3; row++ {
            for var column = 0; column < 3; column++ {
                cells[row][column].clearCell()
            }
        }
    }
    
    func isBoardComplete() -> Bool {
        for var row = 0; row < 3; row++ {
            for var column = 0; column < 3; column++ {
                if self.cells[row][column].isCellComplete() == false {
                    return false
                }
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
//        print ("Cell(\(row),\(column)) completed")
        return true
    }
    
    func buildBoard() {
        let cellCoords: [(row: Int, column: Int)] = [(0,0), (0,1), (0,2), (1,0), (1,1), (1,2), (2,0), (2,1), (2,2)]
        var cellIndex: Int = 0
        while (self.isBoardComplete() == false) {
//            print("Building cell at (\(cellCoords[cellIndex].row),\(cellCoords[cellIndex].column))")
            if buildCell(cellCoords[cellIndex].row, column: cellCoords[cellIndex].column) == true {
                cellIndex++
            } else {
                print("Cell build at (\(cellCoords[cellIndex].row), \(cellCoords[cellIndex].column)) stalled, restarting")
                for var i: Int = cellIndex; i >= 0; i-- {
//                    print("Clearing cell at (\(cellCoords[i].row), \(cellCoords[i].column))")
                    self.cells[cellCoords[i].row][cellCoords[i].column].clearCell()
                }
                cellIndex = 0
            }
            if cellIndex == 9 {
                print("Completed Board Build...")
            }
        }
        return
    }
    
    func returnCellsAtPosition(row:Int, column:Int) -> SudokuCell {
        if column >= 0 && column < 3 && row >= 0 && row < 3 {
            return cells[row][column]
        }
        return cells[0][0]
    }
    
}