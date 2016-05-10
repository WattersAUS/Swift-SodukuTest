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

    // NEEDS WORK HERE!!!!! to set default/clear image and enable setting of right image when needed
    private func clearImageView(imageView: UIImageView) {
        return
    }
    
    private func setImageView(imageView: UIImageView) {
        return
    }
    
}