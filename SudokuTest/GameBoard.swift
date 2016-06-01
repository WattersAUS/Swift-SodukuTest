//
//  GameBoard.swift
//  SudokuTest
//
//  Created by Graham Watson on 02/04/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

class GameBoard: NSObject, NSCopying {
    
    // will contain the solution to the puzzle
    private var solutionBoardCells: [[Cell]] = []
    // the solution with random numbers blanked out (this will be the board shown to the user)
    var gameBoardCells: [[Cell]] = []
    // the board before the user starts (used to restart board functions)
    var originBoardCells: [[Cell]] = []

    private var boardCoordinates: [(row: Int, column: Int)] = []
    private var boardRows: Int = 0
    private var boardColumns: Int = 0
    private var difficulty: Int = 0
    private var stalls: Int = 0
    
    init (size: Int = 3, setDifficulty: Int = 7) {
        super.init()
        self.boardColumns = size
        if self.boardColumns != 3 {
            self.boardColumns = 3
        }
        self.boardRows = self.boardColumns
        self.difficulty = setDifficulty
        if self.difficulty < 0 || self.difficulty > 9 {
            self.difficulty = 7
        }
        // init the all copiees of the board ie solution/game and origin
        for row: Int in 0 ..< self.boardRows {
            var rowOfCells: [Cell] = [Cell(size: self.boardColumns)]
            for column: Int in 0 ..< boardColumns {
                self.boardCoordinates.append((row, column))
                if column > 0 {
                    rowOfCells.append(Cell(size: self.boardColumns))
                }
            }
            self.solutionBoardCells.append(rowOfCells)
        }
        // init the game cells
        for row: Int in 0 ..< self.boardRows {
            var rowOfCells: [Cell] = [Cell(size: self.boardColumns)]
            for column: Int in 0 ..< boardColumns {
                self.boardCoordinates.append((row, column))
                if column > 0 {
                    rowOfCells.append(Cell(size: self.boardColumns))
                }
            }
            self.gameBoardCells.append(rowOfCells)
        }
        // init the origin cells
        for row: Int in 0 ..< self.boardRows {
            var rowOfCells: [Cell] = [Cell(size: self.boardColumns)]
            for column: Int in 0 ..< boardColumns {
                self.boardCoordinates.append((row, column))
                if column > 0 {
                    rowOfCells.append(Cell(size: self.boardColumns))
                }
            }
            self.originBoardCells.append(rowOfCells)
        }
    }

    // private functions
    private func isNumberLegalInPosition(cellRow: Int, cellColumn: Int, rowInCell: Int, columnInCell: Int, number: Int) -> Bool {
        for row: Int in 0 ..< cellRow {
            if self.solutionBoardCells[row][cellColumn].isNumberUsedInColumn(number, column: columnInCell) == true {
                return false
            }
        }
        for column: Int in 0 ..< cellColumn {
            if self.solutionBoardCells[cellRow][column].isNumberUsedInRow(number, row: rowInCell) == true {
                return false
            }
        }
        return true
    }

    private func buildCell(row: Int, column: Int) -> Bool {
        var stalled: Int = 0
        while self.solutionBoardCells[row][column].isCellCompleted() == false {
            // get an unused row/cell location and an unused number
            let unUsedPosition: (unUsedRow: Int, unUsedColumn: Int) = self.solutionBoardCells[row][column].getRandomUnUsedPosition()
            let unUsedNumber: Int = self.solutionBoardCells[row][column].getRandomUnUsedNumber()
            // check if the unused number can exist in that location by checking adjacent solutionBoardCells
            if isNumberLegalInPosition(row, cellColumn: column, rowInCell: unUsedPosition.unUsedRow, columnInCell: unUsedPosition.unUsedColumn, number: unUsedNumber) == true {
                self.solutionBoardCells[row][column].setNumberAtCellPosition(unUsedPosition.unUsedRow, column: unUsedPosition.unUsedColumn, number: unUsedNumber)
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
    
    private func copySolutionCellsToGameCells() {
        self.gameBoardCells.removeAll()
        for row: Int in 0 ..< self.boardRows {
            var rowOfCells: [Cell] = [self.solutionBoardCells[row][0].copy() as! Cell]
            for column: Int in 1 ..< self.boardColumns {
                rowOfCells.append(self.solutionBoardCells[row][column].copy() as! Cell)
            }
            self.gameBoardCells.append(rowOfCells)
        }
        return
    }
    
    private func copySolutionCellsToOriginCells() {
        self.originBoardCells.removeAll()
        for row: Int in 0 ..< self.boardRows {
            var rowOfCells: [Cell] = [self.solutionBoardCells[row][0].copy() as! Cell]
            for column: Int in 1 ..< self.boardColumns {
                rowOfCells.append(self.solutionBoardCells[row][column].copy() as! Cell)
            }
            self.originBoardCells.append(rowOfCells)
        }
        return
    }
    
    private func copyGameCellsToOriginCells() {
        self.originBoardCells.removeAll()
        for row: Int in 0 ..< self.boardRows {
            var rowOfCells: [Cell] = [self.gameBoardCells[row][0].copy() as! Cell]
            for column: Int in 1 ..< self.boardColumns {
                rowOfCells.append(self.gameBoardCells[row][column].copy() as! Cell)
            }
            self.originBoardCells.append(rowOfCells)
        }
        return
    }
    
    private func clearSolutionBoard() {
        for index: Int in 0 ..< self.boardCoordinates.count {
            self.solutionBoardCells[self.boardCoordinates[index].row][self.boardCoordinates[index].column].clearCell()
        }
        return
    }
    
    private func clearGameBoard() {
        for index: Int in 0 ..< self.boardCoordinates.count {
            self.gameBoardCells[self.boardCoordinates[index].row][self.boardCoordinates[index].column].clearCell()
        }
        return
    }
    
    private func clearOriginBoard() {
        for index: Int in 0 ..< self.boardCoordinates.count {
            self.solutionBoardCells[self.boardCoordinates[index].row][self.boardCoordinates[index].column].clearCell()
        }
        return
    }
    
    // public functions
    func clearBoard() {
        self.clearSolutionBoard()
        self.clearGameBoard()
        self.clearOriginBoard()
        return
    }
    
    func isBoardCompleted() -> Bool {
        for index: Int in 0 ..< self.boardCoordinates.count {
            if self.solutionBoardCells[self.boardCoordinates[index].row][self.boardCoordinates[index].column].isCellCompleted() == false {
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
                index += 1
            } else {
                self.stalls += 1
                var i: Int = index
                while i > 0 {
                    self.solutionBoardCells[self.boardCoordinates[i].row][self.boardCoordinates[i].column].clearCell()
                    i -= 1
                }
                index = 0
            }
        }
        return
    }

    func buildGameBoard() {
        self.gameBoardCells.removeAll()
        self.copySolutionCellsToGameCells()
        for cellRowOfObj in self.gameBoardCells {
            for cellObj in cellRowOfObj {
                // using the difficulty determine how many numbers to clear from each cell
                var cellsToClear: Int = self.difficulty - Int(arc4random_uniform(UInt32(3))) + 1
                while cellsToClear > 0 {
                    let usedPosition: (usedRow: Int, usedColumn: Int) = cellObj.getRandomUsedPosition()
                    if usedPosition.usedRow > -1 && usedPosition.usedColumn > -1 {
                        cellObj.clearNumberAtCellPosition(usedPosition.usedRow, column: usedPosition.usedColumn)
                    }
                    cellsToClear -= 1
                }
            }
        }
        return
    }
    
    func buildOriginBoard() {
        self.originBoardCells.removeAll()
        self.copyGameCellsToOriginCells()
    }
    
    func dumpSolutionBoard() -> String {
        if self.isBoardCompleted() == false {
            return "Board is not completed"
        }
        var dumpOfBoard: String = ""
        for boardRow: Int in 0 ..< 3 {
            dumpOfBoard += "\nBoard row: \(boardRow)\n"
            for cellRow: Int in 0 ..< 3 {
                var dumpOfCellRow: String = ""
                for boardColumn: Int in 0 ..< 3 {
                    let cellColumns: [Int] = self.solutionBoardCells[boardRow][boardColumn].getValuesFromRow(cellRow)
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
    
    // get a number from the board the user is completing
    func getNumberFromGameBoard(boardRow: Int, boardColumn: Int, cellRow: Int, cellColumn: Int) -> Int {
        if boardRow < 0 || boardRow >= self.boardRows || boardColumn < 0 || boardColumn >= self.boardColumns {
            return 0
        }
        if cellRow < 0 || cellRow >= self.gameBoardCells[boardRow][boardColumn].cellDepth() || cellColumn < 0 || cellColumn >= self.gameBoardCells[boardRow][boardColumn].cellWidth() {
            return 0
        }
        return self.gameBoardCells[boardRow][boardColumn].getNumberAtCellPosition(cellRow, column: cellColumn)
    }
    
    // get a number from the solution board
    func getNumberFromSolutionBoard(boardRow: Int, boardColumn: Int, cellRow: Int, cellColumn: Int) -> Int {
        if boardRow < 0 || boardRow >= self.boardRows || boardColumn < 0 || boardColumn >= self.boardColumns {
            return 0
        }
        if cellRow < 0 || cellRow >= self.solutionBoardCells[boardRow][boardColumn].cellDepth() || cellColumn < 0 || cellColumn >= self.solutionBoardCells[boardRow][boardColumn].cellWidth() {
            return 0
        }
        return self.solutionBoardCells[boardRow][boardColumn].getNumberAtCellPosition(cellRow, column: cellColumn)
    }
    
    // bit of a hack needs work
    func getBoardWidthInCells() -> Int {
        if self.solutionBoardCells.count < 1 {
            return self.boardColumns * self.boardColumns
        }
        return self.boardColumns * self.solutionBoardCells[0][0].cellWidth()
    }
    
    func getGameDifficulty() -> Int {
        return self.difficulty
    }
    
    func getBoardRows() -> Int {
        return self.boardRows
    }
    
    func getBoardColumns() -> Int {
        return self.boardColumns
    }
    
    func getLocationsOfNumberOnBoard(number: Int) -> [(boardRow: Int, boardColumn: Int, cellRow: Int, cellColumn: Int)] {
        var returnCoords: [(boardRow: Int, boardColumn: Int, cellRow: Int, cellColumn: Int)] = []
        for row: Int in 0 ..< self.boardRows {
            for column: Int in 0 ..< self.boardColumns {
                let cellCoords: (cellRow: Int, cellColumn: Int) = self.gameBoardCells[row][column].getLocationOfNumberInCell(number)
                if (cellCoords != (-1,-1)) {
                    returnCoords.append((row, column, cellCoords.cellRow, cellCoords.cellColumn))
                }
            }
        }
        return(returnCoords)
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = GameBoard(size: self.boardColumns)
        for row: Int in 0 ..< self.boardRows {
            var rowOfCells: [Cell] = [self.solutionBoardCells[row][0].copy() as! Cell]
            for column: Int in 1 ..< self.boardColumns {
                rowOfCells.append(self.solutionBoardCells[row][column].copy() as! Cell)
            }
            copy.solutionBoardCells.append(rowOfCells)
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