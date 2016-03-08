//
//  SudokuCell.swift
//  SudokuTest
//
//  Created by Graham Watson on 06/03/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

class SudokuCell {
    
    // has the Cell been fully allocated
    var isComplete:Bool = false
    
    // 2d array 3x3
    var numbers = [[Int]](count: 3, repeatedValue: [Int](count: 3, repeatedValue: 0))
    
    // array holding numbers 1 thro 9, 0 = unused, 1 = used
    var usedNumbers = [Int](count: 9, repeatedValue: 0)
    
    func resetCellUsage() {
        for var count:Int = 0; count < 9; count++ {
            self.usedNumbers[count] = 0
        }
        return
    }
    
    func clearCell() {
        for var row = 0; row < 3; row++ {
            for var column = 0; column < 3; column++ {
                self.numbers[row][column] = 0
            }
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
        for var row = 0; row < 3; row++ {
            for var column = 0; column < 3; column++ {
                self.numbers[row][column] = self.getRandomUnUsedNumber()
                self.setNumberAsUsed(self.numbers[row][column])
            }
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
    
    func getCellValues() -> [[Int]] {
        var values: [[Int]] = []
        for var row = 0; row < 3; row++ {
            var rowArray: [Int] = []
            for var column = 0; column < 3; column++ {
                rowArray.append(self.numbers[row][column])
            }
            values.append(rowArray)
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