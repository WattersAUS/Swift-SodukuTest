//
//  GameBoardLabels.swift
//  SudokuTest
//
//  Created by Graham Watson on 04/04/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

class GameBoardLabels {
    
    var solutionLabels: [[CellLabels]] = []
    var boardCoordinates: [(row: Int, column: Int)] = []
    var boardRows: Int = 0
    var boardColumns: Int = 0
    
    init (size: Int = 3, setDifficulty: Int = 6) {
        self.boardColumns = size
        if self.boardColumns != 3 {
            self.boardColumns = 3
        }
        self.boardRows = self.boardColumns
        for row: Int in 0 ..< self.boardRows {
            var rowOfCells: [CellLabels] = [CellLabels(size: self.boardColumns)]
            for column: Int in 0 ..< boardColumns {
                self.boardCoordinates.append((row, column))
                if column > 0 {
                    rowOfCells.append(CellLabels(size: self.boardColumns))
                }
            }
            self.solutionLabels.append(rowOfCells)
        }
    }

}
