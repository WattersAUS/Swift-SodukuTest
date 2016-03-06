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
    }
    
    func clearBoard() {
        for var row = 0; row < 3; row++ {
            for var column = 0; column < 3; column++ {
                cells[row][column].clearAllCells()
            }
        }
    }
    
    func checkAllCellsAreBuilt() -> Bool {
        for var cellRow = 0; cellRow < 3; cellRow++ {
            for var cellColumn = 0; cellColumn < 3; cellColumn++ {
                if self.cells[cellRow][cellColumn].isCellFull == false {
                    return false
                }
            }
        }
        return true
    }
    
    func populateRandomCell(row:Int, column: Int) {
        if self.cells[row][column].isCellFull == true {
            return
        }
        // get array of all positions still to be filled
        var freeCellPositions: [[Int]] = [[],[]]
        
        // get a random unused number to use
        var randomUnUsedNumber: Int = self.cells[row][column].getRandomUnUsedNumber()
        
        
        // check that adjacent positions by row/column do not also use the same number
        
        // populate the number
        
        // set the number as used in the cell
        
        return
    }
    
    func buildBoard() {
        // pick a random cell to populate first
        var cellRow: Int = Int(arc4random_uniform(3))
        var cellColumn: Int = Int(arc4random_uniform(3))
        self.cells[cellRow][cellColumn].populateAllCells()
        // now randomly select a cell to set a number in, until all numbers are set in all cells
        repeat {
            cellRow = Int(arc4random_uniform(3))
            cellColumn = Int(arc4random_uniform(3))
            if self.cells[cellRow][cellColumn].isCellFull == false {
                // cell selected, now populate a number in that cell
                self.populateRandomCell(cellRow, column: cellColumn)
            }
        } while self.checkAllCellsAreBuilt() == false
    }
    
    func returnCellsAtPosition(row:Int, column:Int) -> SudokuCell {
        if column >= 0 && column < 3 && row >= 0 && row < 3 {
            return cells[row][column]
        }
        return cells[0][0]
    }
    
}
