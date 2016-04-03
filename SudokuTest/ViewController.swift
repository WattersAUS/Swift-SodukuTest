//
//  ViewController.swift
//  SudokuTest
//
//  Created by Graham Watson on 06/03/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var sudokuBoard: GameBoard!
    let kViewStatusBarHeight: CGFloat = 5.0
    let kViewBoardMargin: CGFloat = 35.0
    var viewBoard: UIView!
    var viewCells: [[UIView]] = []
    var viewLabels: [[UILabel]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sudokuBoard = GameBoard()
        sudokuBoard.buildSolution()
        print(sudokuBoard.dumpBoard())
        sudokuBoard.buildGame()
        self.setupInitialBoardDisplay()
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
        self.view.backgroundColor = UIColor.lightGrayColor()
        self.viewBoard = UIView(frame: CGRect(x: self.view.bounds.origin.x + self.kViewBoardMargin, y: self.view.bounds.origin.y + self.kViewBoardMargin + self.kViewStatusBarHeight + 20, width: self.view.bounds.width - (2 * self.kViewBoardMargin), height: self.view.bounds.width - (2 * self.kViewBoardMargin)))
        self.viewBoard.backgroundColor = UIColor.blackColor()
        self.view.addSubview(self.viewBoard)

        let cellMargin: CGFloat = 5.0
        let cellWidth: CGFloat = (self.viewBoard.bounds.width - (4 * cellMargin)) / 3
        
        var yStart: CGFloat = cellMargin
        for y: Int in 0 ..< 3 {
            var rowCells: [UIView] = []
            var xStart: CGFloat = cellMargin
            for x: Int in 0 ..< 3 {
                let cellUI: UIView = UIView(frame: CGRect(x: xStart, y: yStart, width: cellWidth, height: cellWidth))
                cellUI.backgroundColor = UIColor.blackColor()
                
                let labelMargin: CGFloat = 5.0
                let labelWidth: CGFloat = (cellUI.bounds.width - (4 * labelMargin)) / 3
                var jStart: CGFloat = 5.0
                for j: Int in 0 ..< 3 {
                    var kStart: CGFloat = 5.0
                    for k: Int in 0 ..< 3 {

                        
                        
                        
                        
                        let cellLabel: UILabel = UILabel()
                        cellLabel.frame = CGRect(x: kStart, y: jStart, width: labelWidth, height: labelWidth)
                        let numberRetrieved: Int = sudokuBoard.getNumberFromGameBoard(y, boardColumn: x, cellRow: j, cellColumn: k)
                        if numberRetrieved == 0 {
                            cellLabel.text = ""
                            cellLabel.backgroundColor = UIColor.whiteColor()
                        } else {
                            cellLabel.text = "\(numberRetrieved)"
                            cellLabel.backgroundColor = UIColor.lightGrayColor()
                        }
                        cellLabel.font = UIFont(name: "MarkerFelt-Wide", size: 40)
                        cellLabel.textAlignment = NSTextAlignment.Center
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

