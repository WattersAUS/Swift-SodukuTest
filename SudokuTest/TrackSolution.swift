//
//  TrackSolution.swift
//  SudokuTest
//
//  Created by Graham Watson on 14/04/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

class TrackSolution: NSObject, NSCopying {
    
    private var userSupplied: [(boardRow: Int, boardColumn: Int, cellRow: Int, cellColumn: Int)] = []
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = TrackSolution()
//        for row: Int in 0 ..< self.boardRows {
//            var rowOfCells: [Cell] = [self.solutionCells[row][0].copy() as! Cell]
//            for column: Int in 1 ..< self.boardColumns {
//                rowOfCells.append(self.solutionCells[row][column].copy() as! Cell)
//            }
//            copy.solutionCells.append(rowOfCells)
//        }
//        for index: Int in 0 ..< self.boardCoordinates.count {
//            copy.boardCoordinates.append(self.boardCoordinates[index])
//        }
//        copy.boardRows = self.boardRows
//        copy.boardColumns = self.boardColumns
//        copy.stalls = self.stalls
        return copy
    }
    
}