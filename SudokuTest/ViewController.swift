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
    var boardDimensions: Int = 3
    var gameDifficulty: Int = 7
    
    var viewBoard: UIView!
    let kViewStatusBarHeight: CGFloat = 5.0
    let kViewBoardMargin: CGFloat = 35.0
    
    var viewCells: [[UIView]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.sudokuBoard = GameBoard(size: boardDimensions, setDifficulty: self.gameDifficulty)
        self.displayBoard = GameBoardLabels(size: boardDimensions)
        //self.buildSudoku()
        self.initialBoardDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetButtonPressed(sender: UIButton) {
        self.buildSudoku()
    }
    
    // build the initial board display, with all cells = 0 (ie blank)
    func initialBoardDisplay() {
        self.view.backgroundColor = UIColor.lightGrayColor()
        self.viewBoard = UIView(frame: CGRect(x: self.view.bounds.origin.x + self.kViewBoardMargin, y: self.view.bounds.origin.y + self.kViewBoardMargin + self.kViewStatusBarHeight + 20, width: self.view.bounds.width - (2 * self.kViewBoardMargin), height: self.view.bounds.width - (2 * self.kViewBoardMargin)))
        self.viewBoard.backgroundColor = UIColor.blackColor()
        self.view.addSubview(self.viewBoard)
        self.setupBoardContainerDisplay()
        self.initialiseUIViewToAcceptTouch(self.viewBoard)
        return
    }
    
    func setupBoardContainerDisplay() {
        let cellMargin: CGFloat = 5.0
        let cellWidth: CGFloat = (self.viewBoard.bounds.width - (4 * cellMargin)) / 3
        
        var yStart: CGFloat = cellMargin
        for y: Int in 0 ..< self.boardDimensions {
            var rowCells: [UIView] = []
            var xStart: CGFloat = cellMargin
            for x: Int in 0 ..< self.boardDimensions {
                let cellUI: UIView = UIView(frame: CGRect(x: xStart, y: yStart, width: cellWidth, height: cellWidth))
                cellUI.backgroundColor = UIColor.blackColor()
                
                let labelMargin: CGFloat = 5.0
                let labelWidth: CGFloat = (cellUI.bounds.width - (4 * labelMargin)) / 3
                var jStart: CGFloat = 5.0
                for j: Int in 0 ..< self.boardDimensions {
                    var kStart: CGFloat = 5.0
                    for k: Int in 0 ..< self.boardDimensions {
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
        for y: Int in 0 ..< self.displayBoard.boardRows {
            for x: Int in 0 ..< self.displayBoard.boardColumns {
                let cellLabels: CellLabels = self.displayBoard.solutionLabels[y][x]
                for j: Int in 0 ..< cellLabels.cellRows {
                    for k: Int in 0 ..< cellLabels.cellColumns {
                        cellLabels.setLabelToNumber(j, column: k, number: sudokuBoard.getNumberFromGameBoard(y, boardColumn: x, cellRow: j, cellColumn: k))
                    }
                }
            }
        }
        return
    }

    func initialiseUIViewToAcceptTouch(view: UIView) {
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.detectedUIViewTapped(_:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        view.addGestureRecognizer(singleTap)
        view.userInteractionEnabled = true
        return
    }

    func detectedUIViewTapped(recognizer: UITapGestureRecognizer) {
        if(recognizer.state == UIGestureRecognizerState.Ended) {
            let labelPosition: (boardRow: Int, boardColumn: Int, cellRow: Int, cellColumn: Int) = self.getPositionOfLabelTapped(recognizer.locationInView(recognizer.view))
            if labelPosition.boardColumn != -1 {
                let alertView = UIAlertController(title: "View touched", message: "row/column of cell to go here", preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                presentViewController(alertView, animated: true, completion: nil)
            }
        }
        return
    }
    
    func getPositionOfLabelTapped(location: CGPoint) -> (boardRow: Int, boardColumn: Int, cellRow: Int, cellColumn: Int) {
        for y: Int in 0 ..< self.displayBoard.boardRows {
            for x: Int in 0 ..< self.displayBoard.boardColumns {
                let cellLabels: CellLabels = self.displayBoard.solutionLabels[y][x]
                for j: Int in 0 ..< cellLabels.cellRows {
                    for k: Int in 0 ..< cellLabels.cellColumns {
                        let cellLabel: UILabel = cellLabels.cellNumbers[j][k]
                        if cellLabel.frame.contains(location) == true {
                            return(y, x, j, k)
                        }
                    }
                }
            }
        }
        return(-1, -1, -1, -1)
    }
}