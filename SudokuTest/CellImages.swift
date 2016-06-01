//
//  CellImages.swift
//  SudokuTest
//
//  Created by Graham Watson on 10/05/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation
import UIKit

// to hold reference to image/type of image displayed ie. default, selected, highlighted
struct CellContent {
    var cellImageView: UIImageView!
    var cellState: Int!
}

class CellImages {
    var cellContents: [[CellContent]] = []
    var cellColumns: Int = 0
    var cellRows: Int = 0

    // for main board array where rows = cols
    init (size: Int = 3) {
        var setRows: Int = size
        if setRows != 3 {
            setRows = 3
        }
        self.allocateImageArray(setRows, columns: setRows)
        return
    }

    // for control panel where rows != cols
    // allowed rows 3 -> 6, columns 2 -> 4
    init (rows: Int = 6, columns: Int = 2) {
        var setRows: Int = rows
        var setColumns: Int = columns
        if (setColumns < 2) || (setColumns > 4) {
            setColumns = 2
        }
        if (setRows < 3) || (setRows > 6) {
            setRows = 6
        }
        self.allocateImageArray(setRows, columns: setColumns)
        return
    }

    private func allocateImageArray(rows: Int, columns: Int) {
        for _: Int in 0 ..< rows {
            var rowOfImages: [CellContent] = []
            for _: Int in 0 ..< columns {
                var image = CellContent()
                image.cellImageView = UIImageView()
                image.cellState = -1
                rowOfImages.append(image)
            }
            self.cellContents.append(rowOfImages)
        }
        self.cellRows = rows
        self.cellColumns = columns
        return
    }

    func setToImage(row: Int, column: Int, imageToSet: UIImage, imageState: Int) {
        if (row < 0) || (row > self.cellRows) || (column < 0 ) || (column > self.cellColumns) {
            return
        }
        self.cellContents[row][column].cellImageView.image = imageToSet
        self.cellContents[row][column].cellState = imageState
        return
    }
    
    func unsetToImage(row: Int, column: Int) {
        if (row < 0) || (row > self.cellRows) || (column < 0 ) || (column > self.cellColumns) {
            return
        }
        self.cellContents[row][column].cellImageView.image = nil
        self.cellContents[row][column].cellState = -1
        return
    }
    
    func getImageState(row: Int, column: Int) -> Int {
        if (row < 0) || (row > self.cellRows) || (column < 0 ) || (column > self.cellColumns) {
            return -2
        }
        return self.cellContents[row][column].cellState
    }
}