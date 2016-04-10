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
    
    let kMainViewStatusBarHeight: CGFloat = 20.0
    let kMainViewMargin: CGFloat = 35.0

    // game time, hints left, difficulty displayed here
    var viewStatusPanel: UIView!
    
    // the board to solve
    var viewSudokuBoard: UIView!
    let kCellMargin: CGFloat = 5.0
    
    // numbers to insert into the board, rewind, replay, reset
    var viewControlPanel: UIView!
    var ctrlLabels: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.sudokuBoard = GameBoard(size: boardDimensions, setDifficulty: self.gameDifficulty)
        self.displayBoard = GameBoardLabels(size: boardDimensions)
        self.view.backgroundColor = UIColor.lightGrayColor()
        self.initialStatusPanelDisplay()
        self.initialSudokuBoardDisplay()
        self.initialControlPanelDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetButtonPressed(sender: UIButton) {
        self.buildSudoku()
        self.updateBoardDisplay()
    }
    
    // build status panel for the top of the screen
    func initialStatusPanelDisplay() {
        let originX: CGFloat = self.view.bounds.origin.x + self.kMainViewMargin
        let originY: CGFloat = self.view.bounds.origin.y + self.kMainViewMargin
        let frameWidth: CGFloat = self.view.bounds.width - (2 * self.kMainViewMargin)
        let frameHeight: CGFloat = kMainViewStatusBarHeight
        self.viewStatusPanel = UIView(frame: CGRect(x: originX, y: originY, width: frameWidth, height: frameHeight))
        self.viewStatusPanel.backgroundColor = UIColor.blueColor()
        self.view.addSubview(self.viewStatusPanel)
        return
    }
    
    // build the initial board display, with all cells = 0 (ie blank)
    func initialSudokuBoardDisplay() {
        let originX: CGFloat = self.view.bounds.origin.x + self.kMainViewMargin
        let originY: CGFloat = self.view.bounds.origin.y + self.kMainViewMargin + self.kMainViewStatusBarHeight + (2 * self.kMainViewStatusBarHeight)
        let frameWidth: CGFloat = self.view.bounds.width - (2 * self.kMainViewMargin)
        let frameHeight: CGFloat = self.view.bounds.width - (2 * self.kMainViewMargin)
        self.viewSudokuBoard = UIView(frame: CGRect(x: originX, y: originY, width: frameWidth, height: frameHeight))
        self.viewSudokuBoard.backgroundColor = UIColor.blackColor()
        self.view.addSubview(self.viewSudokuBoard)
        self.setupSudokuBoardContainerDisplay()
        self.initialiseUIViewToAcceptTouch(self.viewSudokuBoard)
        return
    }
    
    // build the initial control panel
    func initialControlPanelDisplay() {
        let originX: CGFloat = self.view.bounds.origin.x + self.kMainViewMargin
        let originY: CGFloat = self.view.bounds.origin.y + self.kMainViewMargin + (2 * self.kMainViewStatusBarHeight) + self.viewSudokuBoard.frame.height
        let frameWidth: CGFloat = self.view.bounds.width - (2 * self.kMainViewMargin)
        let frameHeight: CGFloat = kMainViewStatusBarHeight
        self.viewControlPanel = UIView(frame: CGRect(x: originX, y: originY, width: frameWidth, height: frameHeight))
        self.viewControlPanel.backgroundColor = UIColor.greenColor()
        self.view.addSubview(self.viewControlPanel)
        return
    }
    
    func setupSudokuBoardContainerDisplay() {
        self.buildBoardBackground(self.boardDimensions, boardColumns: self.boardDimensions, cellMargin: self.kCellMargin)
        self.drawLabelsOnBoard(self.boardDimensions, boardColumns: self.boardDimensions, cellMargin: self.kCellMargin)
        return
    }

    // draw the grid background, into each we will draw a grid of labels
    func buildBoardBackground(boardRows: Int, boardColumns: Int, cellMargin: CGFloat) {
        let cellWidth: CGFloat = self.calculateCellWidth(boardColumns, margin: cellMargin)
        var yStart: CGFloat = cellMargin
        for _: Int in 0 ..< boardRows {
            var xStart: CGFloat = cellMargin
            for _: Int in 0 ..< boardColumns {
                let cellUI: UIView = UIView(frame: CGRect(x: xStart, y: yStart, width: cellWidth, height: cellWidth))
                cellUI.backgroundColor = UIColor.blackColor()
                self.viewSudokuBoard.addSubview(cellUI)
                xStart += cellWidth + cellMargin
            }
            yStart += cellWidth + cellMargin
        }
        return
    }
    
    // draw out the labels onto the board
    func drawLabelsOnBoard(boardRows: Int, boardColumns: Int, cellMargin: CGFloat) {
        let cellWidth: CGFloat = self.calculateCellWidth(boardColumns, margin: cellMargin)
        let labelWidth: CGFloat = calculateLabelWidth(boardColumns, cellWidth: cellWidth, margin: cellMargin)
        var yStart: CGFloat = cellMargin * 1.5
        for y: Int in 0 ..< boardRows {
            var xStart: CGFloat = cellMargin * 1.5
            for x: Int in 0 ..< boardColumns {
                let labelMargin: CGFloat = cellMargin
                var jStart: CGFloat = 0
                for j: Int in 0 ..< boardRows {
                    var kStart: CGFloat = 0
                    for k: Int in 0 ..< boardColumns {
                        let cellLabels: CellLabels = self.displayBoard.solutionLabels[y][x]
                        let newLabel: UILabel = cellLabels.cellNumbers[j][k]
                        newLabel.frame = CGRect(x: xStart + kStart, y: yStart + jStart, width: labelWidth, height: labelWidth)
                        cellLabels.setLabelToNumber(j, column: k, number: 0)
                        self.viewSudokuBoard.addSubview(newLabel)
                        kStart += labelWidth + labelMargin
                    }
                    jStart += labelWidth + labelMargin
                }
                xStart += cellWidth + cellMargin
            }
            yStart += cellWidth + cellMargin
        }
        return
    }
    
    func calculateCellWidth(boardColumns: Int, margin: CGFloat) -> CGFloat {
        var cellWidth: CGFloat = self.viewSudokuBoard.bounds.width
        cellWidth -= (CGFloat(boardColumns + 1) * margin)
        return cellWidth / CGFloat(boardColumns)
    }
    
    func calculateLabelWidth(labelColumns: Int, cellWidth: CGFloat, margin: CGFloat) -> CGFloat {
        // number of columns on board define number of margins cell is drawn with
        let marginsWidth: CGFloat = CGFloat(labelColumns) * margin
        return (cellWidth - marginsWidth) / CGFloat(labelColumns)
    }
    
    func buildSudoku() {
        sudokuBoard.clearBoard()
        sudokuBoard.buildSolution()
        if self.debug > 0 {
            print(sudokuBoard.dumpBoard())
        }
        sudokuBoard.buildGame()
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
                // if the posn is filled and not a user filled selected answer do nothing
                let cellPosn: String = "y=\(labelPosition.boardRow) x=\(labelPosition.boardColumn) j=\(labelPosition.cellRow) k=\(labelPosition.cellColumn)"
                let alertView = UIAlertController(title: "View touched", message: cellPosn, preferredStyle: .Alert)
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
                        if self.isTapWithinLabel(location, label: cellLabel) == true {
                            return(y, x, j, k)
                        }
                    }
                }
            }
        }
        return(-1, -1, -1, -1)
    }
    
    func isTapWithinLabel(location: CGPoint, label: UILabel) -> Bool {
        print("x = \(location.x) y = \(location.y) label: x = \(label.frame.origin.x) y = \(label.frame.origin.y) w = \(label.frame.width) h = \(label.frame.height)")
        if (location.x >= label.frame.origin.x) && (location.x <= (label.frame.origin.x + label.frame.width)) {
            if (location.y >= label.frame.origin.y) && (location.y <= (label.frame.origin.y + label.frame.height)) {
                return true
            }
        }
        return false
    }
}