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
        var setSize: Int = size
        if setSize != 3 {
            setSize = 3
        }
        self.allocateImageArray(setSize, columns: setSize)
        return
    }

    private func allocateImageArray(rows: Int, columns: Int) {
        self.boardRows = rows
        self.boardColumns = columns
        for row: Int in 0 ..< rows {
            var rowOfCells: [CellImages] = [CellImages(rows: rows, columns: columns)]
            for column: Int in 0 ..< columns {
                self.boardCoordinates.append((row, column))
                if column > 0 {
                    rowOfCells.append(CellImages(rows: rows, columns: columns))
                }
            }
            self.gameImages.append(rowOfCells)
        }
        return
    }
    
    func getLocationsOfHighlightedImagesOnBoard() -> [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] {
        var returnCoords: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] = []
        for boardRow: Int in 0 ..< self.boardRows {
            for boardColumn: Int in 0 ..< self.boardColumns {
                let highlighted: [(cellRow: Int, cellColumn: Int)] = self.gameImages[boardRow][boardColumn].getLocationsOfCellsStateEqualTo(1)
                if highlighted.isEmpty == false {
                    for coord in highlighted {
                        returnCoords.append((boardRow, boardColumn, coord.cellRow, coord.cellColumn))
                    }
                }
            }
        }
        return(returnCoords)
    }
    
}
