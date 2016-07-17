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
        // need to remap diff level passed to internal useful value
        self.setGameDifficulty(setDifficulty)
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

    //
    // private functions
    //
    private func isNumberLegalInSolution(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int), number: Int) -> Bool {
        for boardRow: Int in 0 ..< coord.row {
            if self.solutionBoardCells[boardRow][coord.column].isNumberUsedInColumn(number, column: coord.cellColumn) == true {
                return false
            }
        }
        for boardColumn: Int in 0 ..< coord.column {
            if self.solutionBoardCells[coord.row][boardColumn].isNumberUsedInRow(number, row: coord.cellRow) == true {
                return false
            }
        }
        return true
    }

    private func isNumberLegalInGame(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int), number: Int) -> Bool {
        for boardRow: Int in 0 ..< self.boardRows {
            if self.gameBoardCells[boardRow][coord.column].isNumberUsedInColumn(number, column: coord.cellColumn) == true {
                return false
            }
        }
        for boardColumn: Int in 0 ..< self.boardColumns {
            if self.gameBoardCells[coord.row][boardColumn].isNumberUsedInRow(number, row: coord.cellRow) == true {
                return false
            }
        }
        return true
    }
    
    private func buildCell(row: Int, column: Int) -> Bool {
        var stalled: Int = 0
        while self.solutionBoardCells[row][column].isCellCompleted() == false {
            // get an unused row/cell location and an unused number
            let unUsedPosition: (unUsedRow: Int, unUsedColumn: Int) = self.solutionBoardCells[row][column].getRandomFreePosition()
            let unUsedNumber: Int = self.solutionBoardCells[row][column].getRandomFreeNumber()
            // check if the unused number can exist in that location by checking adjacent solutionBoardCells
            if isNumberLegalInSolution((row, column: column, cellRow: unUsedPosition.unUsedRow, cellColumn: unUsedPosition.unUsedColumn), number: unUsedNumber) == true {
                self.solutionBoardCells[row][column].setNumberAtCellPosition(unUsedPosition.unUsedRow, column: unUsedPosition.unUsedColumn, number: unUsedNumber)
                stalled = 0
            } else {
                stalled = stalled + 1
                if stalled > 100 {
                    return false
                }
            }
        }
        return true
    }
    
    //
    // once we have a solved board, need to copy to origin where we will remove random numbers to produce the game board
    //
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
    
    //
    // for restarting, take the game board back to before the user started solving the puzzle
    //
    private func copyOriginCellsToGameCells() {
        self.gameBoardCells.removeAll()
        for row: Int in 0 ..< self.boardRows {
            var rowOfCells: [Cell] = [self.originBoardCells[row][0].copy() as! Cell]
            for column: Int in 1 ..< self.boardColumns {
                rowOfCells.append(self.originBoardCells[row][column].copy() as! Cell)
            }
            self.gameBoardCells.append(rowOfCells)
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
    
    //
    // public functions - remap game difficulty to useful internal value
    //
    
    func getGameDifficulty() -> Int {
        // remap the diff level to ui control mapping
        var difficulty: Int = 0
        switch self.difficulty {
            case gameDiff.Easy.rawValue:
                difficulty = 0
                break
            case gameDiff.Medium.rawValue:
                difficulty = 1
                break
            case gameDiff.Hard.rawValue:
                difficulty = 2
                break
            default:
                break
        }
        return difficulty
    }
    
    func setGameDifficulty(newDifficulty: Int) {
        switch newDifficulty {
        case 0:
            self.difficulty = gameDiff.Easy.rawValue
            break
        case 1:
            self.difficulty = gameDiff.Medium.rawValue
            break
        case 2:
            self.difficulty = gameDiff.Hard.rawValue
            break
        default:
            self.difficulty = gameDiff.Easy.rawValue
            break
        }
        return
    }
    
    func clearBoard() {
        self.clearSolutionBoard()
        self.clearOriginBoard()
        self.clearGameBoard()
        return
    }
    
    func isSolutionCompleted() -> Bool {
        for index: Int in 0 ..< self.boardCoordinates.count {
            if self.solutionBoardCells[self.boardCoordinates[index].row][self.boardCoordinates[index].column].isCellCompleted() == false {
                return false
            }
        }
        return true
    }

    func isGameCompleted() -> Bool {
        for index: Int in 0 ..< self.boardCoordinates.count {
            if self.gameBoardCells[self.boardCoordinates[index].row][self.boardCoordinates[index].column].isCellCompleted() == false {
                return false
            }
        }
        return true
    }
    
    func isNumberFullyUsedOnGameBoard(number: Int) -> Bool {
        for index: Int in 0 ..< self.boardCoordinates.count {
            if self.gameBoardCells[self.boardCoordinates[index].row][self.boardCoordinates[index].column].isCellCompleted() == false {
                if self.gameBoardCells[self.boardCoordinates[index].row][self.boardCoordinates[index].column].isNumberUsedInCell(number) == false {
                    return false
                }
            }
        }
        return true
    }
    
    func buildSolution() {
        var index: Int = 0
        self.stalls = 0
        while (self.isSolutionCompleted() == false) {
            if buildCell(self.boardCoordinates[index].row, column: self.boardCoordinates[index].column) == true {
                index = index + 1
            } else {
                self.stalls = self.stalls + 1
                var i: Int = index
                while i > 0 {
                    self.solutionBoardCells[self.boardCoordinates[i].row][self.boardCoordinates[i].column].clearCell()
                    i = i - 1
                }
                index = 0
            }
        }
        return
    }
    
    //
    // from the prebuilt solution board, we need to remove random numbers (depending on the set difficulty)
    //
    func buildOriginBoard() {
        var maxNumbersToClearFromBoard: [Int] = []
        for _: Int in 0 ..< (self.boardColumns * self.boardRows) {
            maxNumbersToClearFromBoard.append((self.boardColumns * self.boardRows) - self.getCellsToClear())
        }
        self.originBoardCells.removeAll()
        self.copySolutionCellsToOriginCells()
        for cellRowOfObj in self.originBoardCells {
            for cellObj in cellRowOfObj {
                // using the difficulty determine how many numbers to clear from each cell
                var numbersToClear: Int = self.getCellsToClear()
                while numbersToClear > 0 {
                    let usedPosition: (usedRow: Int, usedColumn: Int) = cellObj.getRandomUsedPosition()
                    if usedPosition.usedRow == -1 {
                        numbersToClear = 0
                    } else {
                        let number: Int = cellObj.getNumberAtCellPosition(usedPosition.usedRow, column: usedPosition.usedColumn) - 1
                        if maxNumbersToClearFromBoard[number] > 0 {
                            cellObj.clearNumberAtCellPosition(usedPosition.usedRow, column: usedPosition.usedColumn)
                        }
                        numbersToClear = numbersToClear - 1
                    }
                }
            }
        }
        return
    }
    
    //
    // get a random number of numbers to remove from a cell depending on difficulty
    //
    func getCellsToClear() -> Int {
        return self.difficulty + 1 - Int(arc4random_uniform(UInt32(2)))
    }
    
    //
    // always created from the 'origin' board, which is the solution with random numbers removed and where the user starts to solve the puzzle
    //
    func initialiseGameBoard() {
        self.gameBoardCells.removeAll()
        self.copyOriginCellsToGameCells()
        return
    }
    
    func dumpSolutionBoard() -> String {
        if self.isSolutionCompleted() == false {
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
    
    //
    // get a number from the board the user is completing
    //
    func getNumberFromGameBoard(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int)) -> Int {
        if coord.row < 0 || coord.row >= self.boardRows || coord.column < 0 || coord.column >= self.boardColumns {
            return 0
        }
        if coord.cellRow < 0 || coord.cellRow >= self.gameBoardCells[coord.row][coord.column].cellDepth() || coord.cellColumn < 0 || coord.cellColumn >= self.gameBoardCells[coord.row][coord.column].cellWidth() {
            return 0
        }
        return self.gameBoardCells[coord.row][coord.column].getNumberAtCellPosition(coord.cellRow, column: coord.cellColumn)
    }

    //
    // get a number from the solution board
    //
    func getNumberFromSolutionBoard(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int)) -> Int {
        if coord.row < 0 || coord.row >= self.boardRows || coord.column < 0 || coord.column >= self.boardColumns {
            return 0
        }
        if coord.cellRow < 0 || coord.cellRow >= self.solutionBoardCells[coord.row][coord.column].cellDepth() || coord.cellColumn < 0 || coord.cellColumn >= self.solutionBoardCells[coord.row][coord.column].cellWidth() {
            return 0
        }
        return self.solutionBoardCells[coord.row][coord.column].getNumberAtCellPosition(coord.cellRow, column: coord.cellColumn)
    }
    
    //
    // is the location an 'origin' posn, we'll use this to work out if the user can interact with that position
    //
    func isOriginBoardCellUsed(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int)) -> Bool {
        if coord.row < 0 || coord.row >= self.boardRows || coord.column < 0 || coord.column >= self.boardColumns {
            return false
        }
        if coord.cellRow < 0 || coord.cellRow >= self.originBoardCells[coord.row][coord.column].cellDepth() || coord.cellColumn < 0 || coord.cellColumn >= self.originBoardCells[coord.row][coord.column].cellWidth() {
            return false
        }
        return (self.originBoardCells[coord.row][coord.column].getNumberAtCellPosition(coord.cellRow, column: coord.cellColumn) == 0) ? false : true
    }
    
    //
    // is the location on the game board used
    //
    func isGameBoardCellUsed(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int)) -> Bool {
        if coord.row < 0 || coord.row >= self.boardRows || coord.column < 0 || coord.column >= self.boardColumns {
            return false
        }
        if coord.cellRow < 0 || coord.cellRow >= self.gameBoardCells[coord.row][coord.column].cellDepth() || coord.cellColumn < 0 || coord.cellColumn >= self.gameBoardCells[coord.row][coord.column].cellWidth() {
            return false
        }
        return (self.gameBoardCells[coord.row][coord.column].getNumberAtCellPosition(coord.cellRow, column: coord.cellColumn) == 0) ? false : true
    }
    
    //
    // can the number exist in this position in the game
    //
    func isNumberValidOnGameBoard(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int), number: Int) -> Bool {
        if coord.row < 0 || coord.row >= self.boardRows || coord.column < 0 || coord.column >= self.boardColumns {
            return false
        }
        if coord.cellRow < 0 || coord.cellRow >= self.gameBoardCells[coord.row][coord.column].cellDepth() || coord.cellColumn < 0 || coord.cellColumn >= self.gameBoardCells[coord.row][coord.column].cellWidth() {
            return false
        }
        if self.gameBoardCells[coord.row][coord.column].isNumberUsedInCell(number) == true {
            return false
        }
        return self.isNumberLegalInGame(coord, number: number)
    }
    
    //
    // populate a position on the game board if permissable
    //
    func setNumberOnGameBoard(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int), number: Int) -> Bool {
        if coord.row < 0 || coord.row >= self.boardRows || coord.column < 0 || coord.column >= self.boardColumns {
            return false
        }
        if coord.cellRow < 0 || coord.cellRow >= self.gameBoardCells[coord.row][coord.column].cellDepth() || coord.column < 0 || coord.column >= self.gameBoardCells[coord.row][coord.column].cellWidth() {
            return false
        }
        if self.gameBoardCells[coord.row][coord.column].isNumberUsedInCell(number) == true {
            return false
        }
        if self.isNumberLegalInGame(coord, number: number) == false {
            return false
        }
        //
        // passed all the validation, so add it. could still be wrong ofc
        //
        self.gameBoardCells[coord.row][coord.column].setNumberAtCellPosition(coord.cellRow, column: coord.cellColumn, number: number)
        return true
    }

    //
    // remove a number from the board
    //
    func clearNumberOnGameBoard(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int)) {
        if coord.row < 0 || coord.row >= self.boardRows || coord.column < 0 || coord.column >= self.boardColumns {
            return
        }
        if coord.cellRow < 0 || coord.cellRow >= self.gameBoardCells[coord.row][coord.column].cellDepth() || coord.cellColumn < 0 || coord.cellColumn >= self.gameBoardCells[coord.row][coord.column].cellWidth() {
            return
        }
        self.gameBoardCells[coord.row][coord.column].clearNumberAtCellPosition(coord.cellRow, column: coord.cellColumn)
        return
    }
    
    //
    // bit of a hack needs work
    //
    func getBoardWidthInCells() -> Int {
        if self.solutionBoardCells.count < 1 {
            return self.boardColumns * self.boardColumns
        }
        return self.boardColumns * self.solutionBoardCells[0][0].cellWidth()
    }

    func getBoardRows() -> Int {
        return self.boardRows
    }
    
    func getBoardColumns() -> Int {
        return self.boardColumns
    }
    
    func getLocationsOfNumberOnBoard(number: Int) -> [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] {
        var returnCoords: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] = []
        for boardRow: Int in 0 ..< self.boardRows {
            for boardColumn: Int in 0 ..< self.boardColumns {
                let cellCoords: (cellRow: Int, cellColumn: Int) = self.gameBoardCells[boardRow][boardColumn].getLocationOfNumberInCell(number)
                if (cellCoords != (-1,-1)) {
                    returnCoords.append((boardRow, boardColumn, cellCoords.cellRow, cellCoords.cellColumn))
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