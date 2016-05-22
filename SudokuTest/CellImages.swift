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
    
    init (size: Int = 3) {
        self.cellColumns = size
        if self.cellColumns != 3 {
            self.cellColumns = 3
        }
        self.cellRows = self.cellColumns
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