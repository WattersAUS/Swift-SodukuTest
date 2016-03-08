//
//  SudokuBoard.swift
//  SudokuTest
//
//  Created by Graham Watson on 06/03/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

class SudokuBoard {
    var cells: [[SudokuCell]] = [[], [], []]
    
    init () {
        // first row of cells
        var row1: [SudokuCell] = [SudokuCell()]
        row1.append(SudokuCell())
        row1.append(SudokuCell())
        cells[0] = row1
        // 2nd
        row1 = [SudokuCell()]
        row1.append(SudokuCell())
        row1.append(SudokuCell())
        cells[1] = row1
        // final
        row1 = [SudokuCell()]
        row1.append(SudokuCell())
        row1.append(SudokuCell())
        cells[2] = row1
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
    
    func populateRandomCell(row:Int, column: Int) {
        if self.cells[row][column].isCellComplete() == true {
            return
        }
        // get a unused number from the selected cell
        let unUsedNumber: Int = self.cells[row][column].getRandomUnUsedNumber()
        // get an unused row/cell location
        let unUsedPosition: (unUsedRow: Int, unUsedColumn: Int) = self.cells[row][column].getRandomUnUsedPosition()
        // check if the unused number can exist in that location by checking adjacent cells
        for var boardRow: Int = 0; boardRow < 3; boardRow++ {
            if self.cells[boardRow][column].isNumberUsedInRow(unUsedNumber, row: boardRow) == true {
                return
            }
        }
        for var boardColumn: Int = 0; boardColumn < 3; boardColumn++ {
            if self.cells[row][boardColumn].isNumberUsedInColumn(unUsedNumber, column: boardColumn) == true {
                return
            }
        }
        // if we get this far, then the number is good use in this location
        self.cells[row][column].setNumberAtCellPosition(unUsedPosition.unUsedRow, column: unUsedPosition.unUsedColumn, number: unUsedNumber)
        return
    }
    
    func checkRowsInAdjacentCells(cellRow: Int, cellColumn: Int, rowToCheck: Int, numberToCheck: Int) -> Bool {
        return false
    }
    
    func checkColumnsInAdjacentCells(cellRow: Int, cellColumn: Int, columnToCheck: Int, numberToCheck: Int) -> Bool {
        return false
    }

    func checkNumberValidInPosition(cellRow: Int, cellColumn: Int, rowInCell: Int, columnInCell: Int, numberToCheck: Int) -> Bool {
        
        return true
    }
    
    func buildCell(row: Int, column: Int) {
        while self.cells[row][column].isCellComplete() == false {
            // get an unused row/cell location and an unused number
            let unUsedPosition: (unUsedRow: Int, unUsedColumn: Int) = self.cells[row][column].getRandomUnUsedPosition()
            let unUsedNumber: Int = self.cells[row][column].getRandomUnUsedNumber()
            // check if the unused number can exist in that location by checking adjacent cells
            if checkNumberValidInPosition(row, cellColumn: column, rowInCell: unUsedPosition.unUsedRow, columnInCell: unUsedPosition.unUsedColumn, numberToCheck: unUsedNumber) == true {
                self.cells[row][column].setNumberAtCellPosition(unUsedPosition.unUsedRow, column: unUsedPosition.unUsedColumn, number: unUsedNumber)
            }
        }
    }
    
    func buildBoard() {
        // start at the top left and build the first cell, this seeds the rest of the table
        // then iterate through the rest of cells left -> right a row at a time
        for var boardRow: Int = 0; boardRow < 3; boardRow++ {
            for var boardColumn: Int = 0; boardColumn < 3; boardColumn++ {
                if boardRow == 0 && boardColumn == 0 {
                    self.cells[boardRow][boardColumn].seedInitialCell()
                } else {
                    buildCell(boardRow, column: boardColumn)
                }
            }
        }
    }
    
    func returnCellsAtPosition(row:Int, column:Int) -> SudokuCell {
        if column >= 0 && column < 3 && row >= 0 && row < 3 {
            return cells[row][column]
        }
        return cells[0][0]
    }
    
}