//
//  ViewController.swift
//  SudokuTest
//
//  Created by Graham Watson on 06/03/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var board: SudokuBoard!
    let kViewStatusBarHeight: CGFloat = 5.0
    let kViewBoardMargin: CGFloat = 35.0
    var viewBoard: UIView!
    var viewCells: [[UIView]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupInitialBoardDisplay()
        board = SudokuBoard(cellWidth: 3)
        board.buildBoard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//
//    @IBAction func resetBoardButtonPressed(sender: UIButton) {
//        board.clearBoard()
//        board.buildBoard()
//        let boardDump: String = board.dumpBoard()
//        outputBoardMsgsTextField.text = boardDump
//    }
//
    
    
    
    func setupInitialBoardDisplay() {
        self.view.backgroundColor = UIColor.blackColor()
        self.viewBoard = UIView(frame: CGRect(x: self.view.bounds.origin.x + self.kViewBoardMargin, y: self.view.bounds.origin.y + self.kViewBoardMargin + self.kViewStatusBarHeight, width: self.view.bounds.width - (2 * self.kViewBoardMargin), height: self.view.bounds.width - (2 * self.kViewBoardMargin)))
        self.viewBoard.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.viewBoard)

        let cellMargin: CGFloat = 5.0
        let cellWidth: CGFloat = (self.viewBoard.bounds.width - (4 * cellMargin)) / 3
        
        var yStart: CGFloat = cellMargin
        for var y: Int = 0; y < 3; y++ {
            var rowCells: [UIView] = []
            var xStart: CGFloat = cellMargin
            for var x: Int = 0; x < 3; x++ {
                let cellUI: UIView = UIView(frame: CGRect(x: xStart, y: yStart, width: cellWidth, height: cellWidth))
                cellUI.backgroundColor = UIColor.blueColor()
                
                let labelMargin: CGFloat = 5.0
                let labelWidth: CGFloat = (cellUI.bounds.width - (4 * labelMargin)) / 3
                //var labelCells: [UILabel] = []
                var jStart: CGFloat = 5.0
                for var j: Int = 0; j < 3; j++ {
                    var kStart: CGFloat = 5.0
                    for var k: Int = 0; k < 3; k++ {
                        let cellLabel: UILabel = UILabel(frame: CGRect(x: kStart, y: jStart, width: labelWidth, height: labelWidth))
                        cellLabel.backgroundColor = UIColor.redColor()
                        // add label to the view to be done here
                        cellUI.addSubview(cellLabel)
                        kStart += labelWidth + labelMargin
                    }
                    jStart += labelWidth + labelMargin
                }
                self.viewBoard.addSubview(cellUI)
                rowCells.append((cellUI))
                xStart += cellWidth + cellMargin
            }
            viewCells.append(rowCells)
            yStart += cellWidth + cellMargin
        }
    }
}

