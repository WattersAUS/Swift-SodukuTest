//
//  Cell.swift
//  SudokuTest
//
//  Created by Graham Watson on 02/04/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

class Cell: NSObject, NSCopying {
    
    private var cellNumbers: [[Int]] = []
    private var cellCoordinates: [(row: Int, column: Int)] = []
    private var cellColumns: Int = 0
    private var cellRows: Int = 0
    
    private var numbersUsed: [Int] = []
    private var cellCompleted: Bool = false

    init (size: Int = 3) {
        self.cellColumns = size
        if self.cellColumns != 3 {
            self.cellColumns = 3
        }
        self.cellRows = self.cellColumns
        
        for row: Int in 0 ..< self.cellRows {
            var rowOfNumbers: [Int] = [ 0 ]
            for column: Int in 0 ..< self.cellColumns {
                cellCoordinates.append((row, column))
                if column > 0 {
                    rowOfNumbers.append(0)
                }
            }
            self.cellNumbers.append(rowOfNumbers)
        }
        for _: Int in 0 ..< (self.cellRows * self.cellColumns) {
            self.numbersUsed.append(0)
        }
        return
    }
    
    // private functions
    private func resetCellUsage() {
        for index: Int in 0 ..< self.numbersUsed.count {
            self.numbersUsed[index] = 0
        }
        return
    }
    
    private func getNumbersArray() -> [Int] {
        var values: [Int] = []
        for index: Int in 0 ..< self.numbersUsed.count {
            values.append(self.numbersUsed[index])
        }
        return values
    }
    
    private func setNumberAsUsed(numberUsed: Int) -> Int {
        if numberUsed < 1 || numberUsed > self.numbersUsed.count {
            return 0
        }
        self.numbersUsed[numberUsed - 1] = 1
        return numberUsed
    }
    
    private func setNumberAsUnUsed(numberUsed: Int) {
        if numberUsed < 1 || numberUsed > self.numbersUsed.count {
            return
        }
        self.numbersUsed[numberUsed - 1] = 0
        return
    }

    private func checkForCellCompleted() -> Bool {
        var completed = true
        for index: Int in 0 ..< self.numbersUsed.count {
            if self.numbersUsed[index] == 0 {
                completed = false
            }
        }
        self.cellCompleted = completed
        return self.cellCompleted
    }
    
    //public functions
    func clearCell() {
        for index: Int in 0 ..< self.cellCoordinates.count {
            self.cellNumbers[self.cellCoordinates[index].row][self.cellCoordinates[index].column] = 0
        }
        self.resetCellUsage()
        self.cellCompleted = false
        return
    }
    
    func getRandomUnUsedNumber() -> Int {
        let numberUsage: [Int] = self.getNumbersArray()
        var numbersToUse: [Int] = []
        for index: Int in 0 ..< numberUsage.count {
            if numberUsage[index] == 0 {
                numbersToUse.append(index + 1)
            }
        }
        return numbersToUse[Int(arc4random_uniform(UInt32(numbersToUse.count)))]
    }
    
    func getRandomUnUsedPosition() -> (unUsedRow: Int, unUsedColumn: Int) {
        if self.cellCompleted == true {
            return (-1, -1)
        }
        var row: Int = Int(arc4random_uniform(UInt32(self.cellRows)))
        var column: Int = Int(arc4random_uniform(UInt32(self.cellColumns)))
        while self.cellNumbers[row][column] > 0 {
            row = Int(arc4random_uniform(UInt32(self.cellRows)))
            column = Int(arc4random_uniform(UInt32(self.cellColumns)))
        }
        return (row, column)
    }
    
    func getRandomUsedPosition() -> (usedRow: Int, usedColumn: Int) {
        var used: Int = 0
        for index: Int in 0 ..< self.cellCoordinates.count {
            if self.cellNumbers[self.cellCoordinates[index].row][self.cellCoordinates[index].column] > 0 {
                used = 1
            }
        }
        if used == 0 {
            return(-1 , -1)
        }
        var index: Int = Int(arc4random_uniform(UInt32(self.cellCoordinates.count)))
        while self.cellNumbers[self.cellCoordinates[index].row][self.cellCoordinates[index].column] == 0 {
            index = Int(arc4random_uniform(UInt32(self.cellCoordinates.count)))
        }
        return (self.cellCoordinates[index].row, self.cellCoordinates[index].column)
    }
    
    func clearNumberAtCellPosition(row: Int, column: Int) {
        if row < 0 || row >= self.cellRows || column < 0 || column >= self.cellColumns {
            return
        }
        self.setNumberAsUnUsed(self.cellNumbers[row][column])
        self.cellNumbers[row][column] = 0
        self.cellCompleted = false
        return
    }
    
    func setNumberAtCellPosition(row: Int, column: Int, number: Int) -> Bool {
        if row < 0 || row >= self.cellRows || column < 0 || column >= self.cellColumns || number < 1 || number > self.numbersUsed.count {
            return false
        }
        if self.cellNumbers[row][column] > 0 {
            return false
        }
        self.cellNumbers[row][column] = number
        self.setNumberAsUsed(self.cellNumbers[row][column])
        return self.checkForCellCompleted()
    }
    
    func getNumberAtCellPosition(row: Int, column: Int) -> Int {
        if row < 0 || row >= self.cellRows || column < 0 || column >= self.cellColumns {
            return 0
        }
        return self.cellNumbers[row][column]
    }
    
    func getValuesFromRow(row: Int) -> [Int] {
        var values: [Int] = []
        if row < 0 || row >= self.cellRows {
            return values
        }
        for column: Int in 0 ..< self.cellColumns {
            values.append(self.cellNumbers[row][column])
        }
        return values
    }
    
    func isNumberUsedInRow(number: Int, row: Int) -> Bool {
        if row < 0 || row >= self.cellRows {
            return false
        }
        for column: Int in 0 ..< self.cellColumns {
            if number == self.cellNumbers[row][column] {
                return true
            }
        }
        return false
    }
    
    func isNumberUsedInColumn(number: Int, column: Int) -> Bool {
        if column < 0 || column >= self.cellColumns {
            return false
        }
        for row: Int in 0 ..< self.cellRows {
            if number == self.cellNumbers[row][column] {
                return true
            }
        }
        return false
    }
    
    func isCellCompleted() -> Bool {
        return self.cellCompleted
    }
    
    func cellWidth() -> Int {
        return self.cellColumns
    }
    
    func cellDepth() -> Int {
        return self.cellRows
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = Cell(size: self.cellRows)
        copy.cellCompleted = self.cellCompleted
        for row: Int in 0 ..< self.cellRows {
            for column: Int in 0 ..< self.cellColumns {
                copy.cellNumbers[row][column] = self.cellNumbers[row][column]
            }
        }
        for index: Int in 0 ..< self.numbersUsed.count {
            copy.numbersUsed[index] = self.numbersUsed[index]
        }
        for index: Int in 0 ..< self.cellCoordinates.count {
            copy.cellCoordinates[index] = self.cellCoordinates[index]
        }
        copy.cellColumns = self.cellColumns
        copy.cellRows = self.cellRows
        return copy
    }
    
}