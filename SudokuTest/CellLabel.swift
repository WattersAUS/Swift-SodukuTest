//
//  CellLabel.swift
//  SudokuTest
//
//  Created by Graham Watson on 03/04/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation
import UIKit

class CellLabel {
    
    var cellNumbers: [[UILabel]] = []
    private var cellColumns: Int = 0
    private var cellRows: Int = 0
    
    init (size: Int = 3) {
        self.cellColumns = size
        if self.cellColumns != 3 {
            self.cellColumns = 3
        }
        self.cellRows = self.cellColumns
        for _: Int in 0 ..< self.cellRows {
            var rowOfNumbers: [UILabel] = []
            for _: Int in 0 ..< self.cellColumns {
                let label = UILabel()
                label.font = UIFont(name: "MarkerFelt-Wide", size: 40)
                label.textAlignment = NSTextAlignment.Center
                rowOfNumbers.append(label)
            }
            self.cellNumbers.append(rowOfNumbers)
        }
        return
    }
    
    private func clearLabelValue(label: UILabel) {
        label.text = ""
        label.backgroundColor = UIColor.whiteColor()
    }
    
    private func setLabelValue(label: UILabel, value: Int) {
        label.text = "\(value)"
        label.backgroundColor = UIColor.lightGrayColor()
    }

    func setLabelToNumber(row: Int, column: Int, number: Int) {
        if row < 0 || row >= self.cellRows || column < 0 || column >= self.cellColumns {
            return
        }
        let label: UILabel = self.cellNumbers[row][column]
        if number == 0 {
            self.clearLabelValue(label)
        } else {
            self.setLabelValue(label, value: number)
        }
        return
    }
}