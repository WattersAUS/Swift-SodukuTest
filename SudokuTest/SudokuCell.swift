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

    init (size: Int = 3) {
        self.dimension = size
        if self.dimension != 3 {
            self.dimension = 3
        }
        for row: Int in 0 ..< self.dimension {
            var rowOfNumbers: [Int] = [ 0 ]
            for column: Int in 0 ..< self.dimension {
                cellCoords.append((row, column))
                if column > 0 {
                    rowOfNumbers.append(0)
                }
            }
            numbers.append(rowOfNumbers)
        }
        for _: Int in 0 ..< (self.dimension * self.dimension) {
            self.usedNumbers.append(0)
        }
        return
    }

    // private functions
    private func resetCellUsage() {
        for index: Int in 0 ..< self.usedNumbers.count {
            self.usedNumbers[index] = 0
        }
        return
    }
    
    private func getArrayOfNumberUsage() -> [Int] {
        var values: [Int] = []
        for index: Int in 0 ..< self.usedNumbers.count {
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
        for index: Int in 0 ..< self.usedNumbers.count {
            if self.usedNumbers[index] == 0 {
                completed = false
            }
        }
        self.isComplete = completed
        return self.isComplete
    }
    
    //public functions
    func clearCell() {
        for index: Int in 0 ..< self.cellCoords.count {
            self.numbers[self.cellCoords[index].row][self.cellCoords[index].column] = 0
        }
        self.resetCellUsage()
        self.isComplete = false
        return
    }

    func getRandomUnUsedNumber() -> Int {
        let unUsedValues: [Int] = self.getArrayOfNumberUsage()
        var useTheseValues: [Int] = []
        for index: Int in 0 ..< self.usedNumbers.count {
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
        for index: Int in 0 ..< self.cellCoords.count {
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
        if row >= 0 && row < self.dimension {
            for column: Int in 0 ..< self.dimension {
                values.append(self.numbers[row][column])
            }
        }
        return values
    }
    
    func isNumberUsedInRow(number: Int, row: Int) -> Bool {
        if row >= 0 && row < self.dimension {
            for column: Int in 0 ..< self.dimension {
                if number == self.numbers[row][column] {
                    return true
                }
            }
        }
        return false
    }
    
    func isNumberUsedInColumn(number: Int, column: Int) -> Bool {
        
        if column >= 0 && column < self.dimension {
            for row: Int in 0 ..< self.dimension {
                if number == self.numbers[row][column] {
                    return true
                }
            }
        }
        return false
    }
    
    func isCellComplete() -> Bool {
        return self.isComplete
    }

}