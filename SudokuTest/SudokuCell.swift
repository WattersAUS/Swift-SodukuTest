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
    var isCellFull:Bool = false
    
    // 2d array 3x3
    var numbers = [[Int]](count: 3, repeatedValue: [Int](count: 3, repeatedValue: 0))
    
    // numbers 1 thro 9
    // 0 = unused, 1 = used
    var usedNumbers = [Int](count: 9, repeatedValue: 0)
    
    func resetUsage() {
        for var count:Int = 0; count < 9; count++ {
            self.usedNumbers[count] = 0
        }
    }
    
    func clearAllCells() {
        for var row = 0; row < 3; row++ {
            for var column = 0; column < 3; column++ {
                self.numbers[row][column] = 0
            }
        }
        self.resetUsage()
        self.isCellFull = false
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
                useTheseValues.append(index)
            }
        }
        return useTheseValues[Int(arc4random_uniform(UInt32(useTheseValues.count)))]
    }
    
    func setNumberAsUsed(usedNumber: Int) -> Int {
        if usedNumber < 1 || usedNumber > 9 {
            return 0
        }
        self.usedNumbers[usedNumber - 1] = 1
        return usedNumber
    }
    
    func populateAllCells() {
        self.clearAllCells()
        for var row = 0; row < 3; row++ {
            for var column = 0; column < 3; column++ {
                self.numbers[row][column] = self.getRandomUnUsedNumber()
                self.setNumberAsUsed(self.numbers[row][column])
            }
        }
        self.isCellFull = true
    }
    
    func populateRandomUnUsedNumberAtCellPosition(row: Int, column: Int) -> Int {
        if row < 0 || row > 2 || column < 0 || column > 2 {
            return 0
        }
        if self.numbers[row][column] > 0 {
            return 0
        }
        self.numbers[row][column] = self.getRandomUnUsedNumber()
        self.setNumberAsUsed(self.numbers[row][column])
        return self.numbers[row][column]
    }
    
    func returnRowValuesAtColumnPosition(row: Int) -> [Int] {
        var values: [Int] = []
        for var column = 0; column < 3 && row >= 0 && row < 3; column++ {
            values.append(self.numbers[row][column])
        }
        return values
    }
    
    func returnColumnValuesAtRowPosition(column: Int) -> [Int] {
        var values: [Int] = []
        for var row = 0; row < 3 && column >= 0 && column < 3; row++ {
            values.append(self.numbers[row][column])
        }
        return values
    }
    
    func returnAllValues() -> [[Int]] {
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
    
    func checkNumberInUseInRow(number: Int, row: Int) -> Bool {
        for var column = 0; column < 3 && row >= 0 && row < 3; column++ {
            if number == self.numbers[row][column] {
                return true
            }
        }
        return false
    }
    
    func checkNumberInUseInColumn(number: Int, column: Int) -> Bool {
        for var row = 0; row < 3 && column >= 0 && column < 3; row++ {
            if number == self.numbers[row][column] {
                return true
            }
        }
        return false
    }
}
