//
//  SudokuCell.swift
//  SudokuTest
//
//  Created by Graham Watson on 06/03/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

class SudokuCell {
    
    private var isComplete:Bool = false
    private var numbers = [[Int]](count: 3, repeatedValue: [Int](count: 3, repeatedValue: 0))
    private var usedNumbers: [Int] = []
    private var cellCoords: [(row: Int, column: Int)] = []
    private var cells: Int = 0

    init (size: Int) {
        var cellSize: Int = size
        if cellSize != 3 && cellSize != 4 {
            cellSize = 3
        }
        for var row: Int = 0; row < cellSize; row++ {
            for var column: Int = 0; column < size; column++ {
                cellCoords.append((row, column))
            }
        }
        cells = cellSize * cellSize
        for var loop: Int = 0; loop < cells; loop++ {
            self.usedNumbers.append(0)
        }
    }
    
    func resetCellUsage() {
        for var count:Int = 0; count < 9; count++ {
            self.usedNumbers[count] = 0
        }
        return
    }
    
    func clearCell() {
        for var index: Int = 0; index < self.cellCoords.count; index++ {
            self.numbers[self.cellCoords[index].row][self.cellCoords[index].column] = 0
        }
        self.resetCellUsage()
        self.isComplete = false
        return
    }
    
    func getArrayOfNumberUsage() -> [Int] {
        var values: [Int] = []
        for var index = 0; index < 9; index++ {
            values.append(self.usedNumbers[index])
        }
        return values
    }
    
    func getRandomUnUsedNumber() -> Int {
        let unUsedValues: [Int] = self.getArrayOfNumberUsage()
        var useTheseValues: [Int] = []
        for var index = 0; index < unUsedValues.count; index++ {
            if unUsedValues[index] == 0 {
                useTheseValues.append(index + 1)
            }
        }
        return useTheseValues[Int(arc4random_uniform(UInt32(useTheseValues.count)))]
    }
    
    func getRandomUnUsedPosition() -> (unUsedRow: Int, unUsedColumn: Int) {
        if self.isComplete == true {
            return (-1, -1)
        }
        var row = Int(arc4random_uniform(3))
        var column = Int(arc4random_uniform(3))
        while self.numbers[row][column] > 0 {
            row = Int(arc4random_uniform(3))
            column = Int(arc4random_uniform(3))
        }
        return (row, column)
    }
    
    func setNumberAsUsed(usedNumber: Int) -> Int {
        if usedNumber < 1 || usedNumber > 9 {
            return 0
        }
        self.usedNumbers[usedNumber - 1] = 1
        return usedNumber
    }
    
    func seedInitialCell() {
        self.clearCell()
        for var index: Int = 0; index < self.cellCoords.count; index++ {
            self.numbers[self.cellCoords[index].row][self.cellCoords[index].column] = self.getRandomUnUsedNumber()
            self.setNumberAsUsed(self.numbers[self.cellCoords[index].row][self.cellCoords[index].column])
        }
        self.isComplete = true
        return
    }
    
    func setCellCompleteIfRequired() -> Bool {
        var completed = true
        for var index = 0; index < 9; index++ {
            if usedNumbers[index] == 0 {
                completed = false
            }
        }
        self.isComplete = completed
        return self.isComplete
    }
    
    func setNumberAtCellPosition(row: Int, column: Int, number: Int) -> Bool {
        if row < 0 || row > 2 || column < 0 || column > 2 || number < 1 || number > 9 {
            return false
        }
        if self.numbers[row][column] > 0 {
            return false
        }
        self.numbers[row][column] = number
        self.setNumberAsUsed(self.numbers[row][column])
        return self.setCellCompleteIfRequired()
    }
    
    func getColumnValuesFromRow(row: Int) -> [Int] {
        var values: [Int] = []
        for var column = 0; column < 3 && row >= 0 && row < 3; column++ {
            values.append(self.numbers[row][column])
        }
        return values
    }
    
    func getRowValuesFromColumn(column: Int) -> [Int] {
        var values: [Int] = []
        for var row = 0; row < 3 && column >= 0 && column < 3; row++ {
            values.append(self.numbers[row][column])
        }
        return values
    }
    
    func isNumberUsedInRow(number: Int, row: Int) -> Bool {
        for var column = 0; column < 3 && row >= 0 && row < 3; column++ {
            if number == self.numbers[row][column] {
                return true
            }
        }
        return false
    }
    
    func isNumberUsedInColumn(number: Int, column: Int) -> Bool {
        for var row = 0; row < 3 && column >= 0 && column < 3; row++ {
            if number == self.numbers[row][column] {
                return true
            }
        }
        return false
    }
    
    func isCellComplete() -> Bool {
        return self.isComplete
    }
}