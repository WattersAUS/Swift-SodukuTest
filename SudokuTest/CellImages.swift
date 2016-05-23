//
//  CellImages.swift
//  SudokuTest
//
//  Created by Graham Watson on 10/05/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation
import UIKit

class CellImages {
    
    var cellNumbers: [[UIImageView]] = []
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
        self.cellRows = rows
        self.cellColumns = columns
        for _: Int in 0 ..< self.cellRows {
            var rowOfNumbers: [UIImageView] = []
            for _: Int in 0 ..< self.cellColumns {
                let imageView = UIImageView()
                rowOfNumbers.append(imageView)
            }
            self.cellNumbers.append(rowOfNumbers)
        }
        return
    }
    
    func setToImage(row: Int, column: Int, imageToSet: UIImage) {
        let imageView: UIImageView = cellNumbers[row][column]
        imageView.image = imageToSet
        return
    }

    func unsetToImage(row: Int, column: Int) {
        let imageView: UIImageView = cellNumbers[row][column]
        imageView.image = nil
        return
    }
}