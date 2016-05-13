//
//  GameBoardImages.swift
//  SudokuTest
//
//  Created by Graham Watson on 12/05/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

class GameBoardImages {
    
    var gameImages: [[CellImages]] = []
    var boardCoordinates: [(row: Int, column: Int)] = []
    var boardRows: Int = 0
    var boardColumns: Int = 0
    
    init (size: Int = 3) {
        self.boardColumns = size
        if self.boardColumns != 3 {
            self.boardColumns = 3
        }
        self.boardRows = self.boardColumns
        for row: Int in 0 ..< self.boardRows {
            var rowOfCells: [CellImages] = [CellImages(size: self.boardColumns)]
            for column: Int in 0 ..< boardColumns {
                self.boardCoordinates.append((row, column))
                if column > 0 {
                    rowOfCells.append(CellImages(size: self.boardColumns))
                }
            }
            self.gameImages.append(rowOfCells)
        }
    }
    
}
