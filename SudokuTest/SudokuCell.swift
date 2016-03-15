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
    private var numbers: [[Int]] = []
    private var usedNumbers: [Int] = []
    private var cellCoords: [(row: Int, column: Int)] = []
    private var dimension: Int = 0

    init (size: Int) {
        self.dimension = size
        if self.dimension != 3 && self.dimension != 4 {
            self.dimension = 3
        }
        for var row: Int = 0; row < self.dimension; row++ {
            var rowOfNumbers: [Int] = [ 0 ]
            for var column: Int = 0; column < self.dimension; column++ {
                cellCoords.append((row, column))
                if column > 0 {
                    rowOfNumbers.append(0)
                }
            }
            numbers.append(rowOfNumbers)
        }
        for var loop: Int = 0; loop < (self.dimension * self.dimension); loop++ {
            self.usedNumbers.append(0)
        }
        return
    }

    // private functions
    private func resetCellUsage() {
        for var index:Int = 0; index < self.usedNumbers.count; index++ {
            self.usedNumbers[index] = 0
        }
        return
    }
    
    private func getArrayOfNumberUsage() -> [Int] {
        var values: [Int] = []
        for var index = 0; index < self.usedNumbers.count; index++ {
            values.append(self.usedNumbers[index])
        }
        return values
    }
    
    private func setNumberAsUsed(usedNumber: Int) -> Int {
        if usedNumber < 1 || usedNumber > self.usedNumbers.count {
            return 0
        }
        self.usedNumbers[usedNumber - 1] = 1
        return usedNumber
    }
    
    private func setCellCompleteIfRequired() -> Bool {
        var completed = true
        for var index = 0; index < self.usedNumbers.count; index++ {
            if self.usedNumbers[index] == 0 {
                completed = false
            }
        }
        self.isComplete = completed
        return self.isComplete
    }
    
    //public functions
    func clearCell() {
        for var index: Int = 0; index < self.cellCoords.count; index++ {
            self.numbers[self.cellCoords[index].row][self.cellCoords[index].column] = 0
        }
        self.resetCellUsage()
        self.isComplete = false
        return
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
        var row: Int = Int(arc4random_uniform(UInt32(self.dimension)))
        var column: Int = Int(arc4random_uniform(UInt32(self.dimension)))
        while self.numbers[row][column] > 0 {
            row = Int(arc4random_uniform(UInt32(self.dimension)))
            column = Int(arc4random_uniform(UInt32(self.dimension)))
        }
        return (row, column)
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
    
    func setNumberAtCellPosition(row: Int, column: Int, number: Int) -> Bool {
        if row < 0 || row >= self.dimension || column < 0 || column >= self.dimension || number < 1 || number > self.usedNumbers.count {
            return false
        }
        if self.numbers[row][column] > 0 {
            return false
        }
        self.numbers[row][column] = number
        self.setNumberAsUsed(self.numbers[row][column])
        return self.setCellCompleteIfRequired()
    }
    
    func getValuesFromRow(row: Int) -> [Int] {
        var values: [Int] = []
        for var column = 0; column < self.dimension && row >= 0 && row < self.dimension; column++ {
            values.append(self.numbers[row][column])
        }
        return values
    }
    
    func isNumberUsedInRow(number: Int, row: Int) -> Bool {
        for var column = 0; column < self.dimension && row >= 0 && row < self.dimension; column++ {
            if number == self.numbers[row][column] {
                return true
            }
        }
        return false
    }
    
    func isNumberUsedInColumn(number: Int, column: Int) -> Bool {
        for var row = 0; row < self.dimension && column >= 0 && column < self.dimension; row++ {
            if number == self.numbers[row][column] {
                return true
            }
        }
        return false
    }
    
    func isCellComplete() -> Bool {
        return self.isComplete
    }
    
//    func printCell() {
//        for var index: Int = 0; index < self.cellCoords.count; index++ {
//            print("row: \(self.cellCoords[index].row), column: \(self.cellCoords[index].column), value: \(self.numbers[self.cellCoords[index].row][self.cellCoords[index].column])")
//        }
//        return
//    }
}