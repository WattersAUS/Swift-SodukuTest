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
    var displayBoard: GameBoardLabels!
    var debug: Int = 1
    
    var viewBoard: UIView!
    let kViewStatusBarHeight: CGFloat = 5.0
    let kViewBoardMargin: CGFloat = 35.0
    
    var viewCells: [[UIView]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.sudokuBoard = GameBoard()
        self.displayBoard = GameBoardLabels()
        //self.buildSudoku()
        self.initialBoardDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // build the initial board display, with all cells = 0 (ie blank)
    func initialBoardDisplay() {
        self.view.backgroundColor = UIColor.lightGrayColor()
        self.viewBoard = UIView(frame: CGRect(x: self.view.bounds.origin.x + self.kViewBoardMargin, y: self.view.bounds.origin.y + self.kViewBoardMargin + self.kViewStatusBarHeight + 20, width: self.view.bounds.width - (2 * self.kViewBoardMargin), height: self.view.bounds.width - (2 * self.kViewBoardMargin)))
        self.viewBoard.backgroundColor = UIColor.blackColor()
        self.view.addSubview(self.viewBoard)
        self.setupBoardContainerDisplay()
        self.initialiseLabelsToAcceptTouch()
        return
    }
    
    func setupBoardContainerDisplay() {
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
                        let cellLabels: CellLabels = self.displayBoard.solutionLabels[y][x]
                        let newLabel: UILabel = cellLabels.cellNumbers[j][k]
                        newLabel.frame = CGRect(x: kStart, y: jStart, width: labelWidth, height: labelWidth)
                        cellLabels.setLabelToNumber(j, column: k, number: 0)
                        cellUI.addSubview(newLabel)
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
    
    @IBAction func resetButtonPressed(sender: UIButton) {
        self.buildSudoku()
    }
    
    //
    //    @IBAction func resetBoardButtonPressed(sender: UIButton) {
    //        board.clearBoard()
    //        board.buildBoard()
    //        let boardDump: String = board.dumpBoard()
    //        outputBoardMsgsTextField.text = boardDump
    //    }
    //
    
    func buildSudoku() {
        sudokuBoard.clearBoard()
        sudokuBoard.buildSolution()
        if self.debug > 0 {
            print(sudokuBoard.dumpBoard())
        }
        sudokuBoard.buildGame()
        self.updateBoardDisplay()
        return
    }
    
    func updateBoardDisplay() {
        for y: Int in 0 ..< 3 {
            for x: Int in 0 ..< 3 {
                for j: Int in 0 ..< 3 {
                    for k: Int in 0 ..< 3 {
                        let cellLabels: CellLabels = self.displayBoard.solutionLabels[y][x]
                        cellLabels.setLabelToNumber(j, column: k, number: sudokuBoard.getNumberFromGameBoard(y, boardColumn: x, cellRow: j, cellColumn: k))
                    }
                }
            }
        }
    }
    
    func initialiseLabelsToAcceptTouch() {
        for y: Int in 0 ..< 3 {
            for x: Int in 0 ..< 3 {
                for j: Int in 0 ..< 3 {
                    for k: Int in 0 ..< 3 {
                        let cellLabels: CellLabels = self.displayBoard.solutionLabels[y][x]
                        let label: UILabel = cellLabels.cellNumbers[j][k]
                        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.detectedUILabelTapped(_:)))
                        singleTap.numberOfTapsRequired = 1
                        singleTap.numberOfTouchesRequired = 1
                        label.addGestureRecognizer(singleTap)
                        label.userInteractionEnabled = true
                    }
                }
            }
        }
    }
    
    func detectedUILabelTapped(recognizer: UITapGestureRecognizer) {
        if(recognizer.state == UIGestureRecognizerState.Ended) {
//            let alertView = UIAlertController(title: "Cell touched", message: "row/column to go here", preferredStyle: .Alert)
//            alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
//            presentViewController(alertView, animated: true, completion: nil)
            if recognizer.view?.backgroundColor != UIColor.lightGrayColor() {
                if recognizer.view?.backgroundColor == UIColor.blueColor() {
                    recognizer.view?.backgroundColor = UIColor.whiteColor()
                } else {
                    recognizer.view?.backgroundColor = UIColor.blueColor()
                }
            }
        }
        return
    }
}