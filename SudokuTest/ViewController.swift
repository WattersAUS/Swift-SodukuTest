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
    var displayBoard: GameBoardImages!
    var debug: Int = 1
    var boardDimensions: Int = 3
    var gameDifficulty: Int = 7
    
    // where to start drawing the board
    let kMainViewMargin: CGFloat = 80.0

    // game time, hints left, difficulty displayed here
    //var viewStatusPanel: UIView!
    
    // the board to solve
    var viewSudokuBoard: UIView!
    let kCellMargin: CGFloat = 5.0
    
    // numbers to insert into the board, rewind, replay, reset etc
    var defaultImage: UIImage = UIImage(named:"DefaultImage.png")!
    var selectedImage: UIImage = UIImage(named:"SelectedImage.png")!
    var forwardImage: UIImage = UIImage(named:"Forward.png")!
    var rewindImage: UIImage = UIImage(named:"Rewind.png")!
    var imageSetToUse: Int = 0
    var imageLibrary: [[UIImage]] = [[
            UIImage(named:"SelectNumber_1.png")!,
            UIImage(named:"SelectNumber_2.png")!,
            UIImage(named:"SelectNumber_3.png")!,
            UIImage(named:"SelectNumber_4.png")!,
            UIImage(named:"SelectNumber_5.png")!,
            UIImage(named:"SelectNumber_6.png")!,
            UIImage(named:"SelectNumber_7.png")!,
            UIImage(named:"SelectNumber_8.png")!,
            UIImage(named:"SelectNumber_9.png")!
        ],[
            // this would be alternate images list
            UIImage(named:"SelectNumber_9.png")!,
            UIImage(named:"SelectNumber_8.png")!,
            UIImage(named:"SelectNumber_7.png")!,
            UIImage(named:"SelectNumber_6.png")!,
            UIImage(named:"SelectNumber_5.png")!,
            UIImage(named:"SelectNumber_4.png")!,
            UIImage(named:"SelectNumber_3.png")!,
            UIImage(named:"SelectNumber_2.png")!,
            UIImage(named:"SelectNumber_1.png")!
        ],[
            // this would be alternate images 2 list
            UIImage(named:"SelectNumber_9.png")!,
            UIImage(named:"SelectNumber_8.png")!,
            UIImage(named:"SelectNumber_7.png")!,
            UIImage(named:"SelectNumber_6.png")!,
            UIImage(named:"SelectNumber_5.png")!,
            UIImage(named:"SelectNumber_4.png")!,
            UIImage(named:"SelectNumber_3.png")!,
            UIImage(named:"SelectNumber_2.png")!,
            UIImage(named:"SelectNumber_1.png")!
        ]
    ]
    var activeImageSet: Int = 0
    
    // current selected board positiom (if any, -1 if none)
    var currentSelectedPosition: (boardRow: Int, boardColumn: Int, cellRow: Int, cellColumn: Int) = (-1, -1, -1, -1)
    
    // start of the code!!!!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.sudokuBoard = GameBoard(size: self.boardDimensions, setDifficulty: self.gameDifficulty)
        self.displayBoard = GameBoardImages(size: self.boardDimensions)
        self.view.backgroundColor = UIColor.lightGrayColor()
        self.activeImageSet = 0
        self.initialSudokuBoardDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // build the initial board display, with all cells = 0 (ie blank)
    func initialSudokuBoardDisplay() {
        let originX: CGFloat = self.view.bounds.origin.x + self.kMainViewMargin
        let originY: CGFloat = self.kMainViewMargin
        let frameWidth: CGFloat = self.view.bounds.width - (2 * self.kMainViewMargin)
        let frameHeight: CGFloat = self.view.bounds.width - (2 * self.kMainViewMargin)
        self.viewSudokuBoard = UIView(frame: CGRect(x: originX, y: originY, width: frameWidth, height: frameHeight))
        self.view.addSubview(self.viewSudokuBoard)
        self.buildBoardBackground(self.boardDimensions, boardColumns: self.boardDimensions, cellMargin: self.kCellMargin)
        self.drawInitialImagesOnBoard(self.boardDimensions, boardColumns: self.boardDimensions, cellMargin: self.kCellMargin)
        self.initialiseSudokuBoardUIViewToAcceptTouch(self.viewSudokuBoard)
        return
    }
    
    // draw the grid background, into each we will draw a grid of labels
    func buildBoardBackground(boardRows: Int, boardColumns: Int, cellMargin: CGFloat) {
        let cellWidth: CGFloat = self.calculateCellWidth(boardColumns, margin: cellMargin)
        var yStart: CGFloat = cellMargin
        for _: Int in 0 ..< boardRows {
            var xStart: CGFloat = cellMargin
            for _: Int in 0 ..< boardColumns {
                self.viewSudokuBoard.addSubview(UIView(frame: CGRect(x: xStart, y: yStart, width: cellWidth, height: cellWidth)))
                xStart += cellWidth + cellMargin
            }
            yStart += cellWidth + cellMargin
        }
        return
    }
    
    // add the image containers onto the board
    func drawInitialImagesOnBoard(boardRows: Int, boardColumns: Int, cellMargin: CGFloat) {
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
                        let cellImages: CellImages = self.displayBoard.gameImages[y][x]
                        let newImage: UIImageView = cellImages.cellNumbers[j][k]
                        newImage.frame = CGRect(x: xStart + kStart, y: yStart + jStart, width: labelWidth, height: labelWidth)
                        newImage.image = defaultImage
                        self.viewSudokuBoard.addSubview(newImage)
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

    // sets up and allows touches to be detected on SudokuBoard view only
    func initialiseSudokuBoardUIViewToAcceptTouch(view: UIView) {
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.detectedSudokuBoardUIViewTapped(_:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        view.addGestureRecognizer(singleTap)
        view.userInteractionEnabled = true
        return
    }

    func detectedSudokuBoardUIViewTapped(recognizer: UITapGestureRecognizer) {
        if(recognizer.state != UIGestureRecognizerState.Ended) {
            return
        }
        // check we have a board to test ie have we generated one yet?
        if self.sudokuBoard.gameBoardCells.count == 0 {
            return
        }
        // has the user tapped in a cell?
        let cellPosition: (boardRow: Int, boardColumn: Int, cellRow: Int, cellColumn: Int) = self.getPositionOfSudokuBoardLabelTapped(recognizer.locationInView(recognizer.view))
        if cellPosition.boardColumn == -1 {
            return
        }
        // the user cannot select an 'origin' cell
        if self.sudokuBoard.originBoardCells[cellPosition.boardRow][cellPosition.boardColumn].getNumberAtCellPosition(cellPosition.cellRow, column: cellPosition.cellColumn) > 0 {
            return
        }
        // if the user selectd the same position then wipe it out
        if (self.currentSelectedPosition == cellPosition) {
            self.setCellToDefaultImage(cellPosition)
            self.currentSelectedPosition = (-1,-1,-1,-1)
            return
        }
        // if we already have a position and the user had selected another position
        if (self.currentSelectedPosition != (-1,-1,-1,-1)) {
            if (self.currentSelectedPosition != cellPosition) {
                self.setCellToDefaultImage(self.currentSelectedPosition)
            }
        }
        // update currently selected position
        self.currentSelectedPosition = (cellPosition.boardRow, cellPosition.boardColumn, cellPosition.cellRow, cellPosition.cellColumn)
        self.setCellToSelectedImage(self.currentSelectedPosition)
        return
    }
    
    func getPositionOfSudokuBoardLabelTapped(location: CGPoint) -> (boardRow: Int, boardColumn: Int, cellRow: Int, cellColumn: Int) {
        for y: Int in 0 ..< self.displayBoard.boardRows {
            for x: Int in 0 ..< self.displayBoard.boardColumns {
                let cellImages: CellImages = self.displayBoard.gameImages[y][x]
                for j: Int in 0 ..< cellImages.cellRows {
                    for k: Int in 0 ..< cellImages.cellColumns {
                        let cellImage: UIImageView = cellImages.cellNumbers[j][k]
                        if self.isTapWithinSudokuBoardImage(location, image: cellImage) == true {
                            return(y, x, j, k)
                        }
                    }
                }
            }
        }
        return(-1, -1, -1, -1)
    }
    
    func isTapWithinSudokuBoardImage(location: CGPoint, image: UIImageView) -> Bool {
        if (location.x >= image.frame.origin.x) && (location.x <= (image.frame.origin.x + image.frame.width)) {
            if (location.y >= image.frame.origin.y) && (location.y <= (image.frame.origin.y + image.frame.height)) {
                return true
            }
        }
        return false
    }

    // update cell colours when selected or deselected
    func setCellToSelectedImage(boardPosition: (boardRow: Int, boardColumn: Int, cellRow: Int, cellColumn: Int)) {
        let cellImages: CellImages = self.displayBoard.gameImages[boardPosition.boardRow][boardPosition.boardColumn]
        cellImages.setToImage(boardPosition.cellRow, column: boardPosition.cellColumn, imageToSet: self.selectedImage)
        return
    }
    
    func setCellToDefaultImage(boardPosition: (boardRow: Int, boardColumn: Int, cellRow: Int, cellColumn: Int)) {
        let cellImages: CellImages = self.displayBoard.gameImages[boardPosition.boardRow][boardPosition.boardColumn]
        cellImages.setToImage(boardPosition.cellRow, column: boardPosition.cellColumn, imageToSet: self.defaultImage)
        return
    }
    
    @IBAction func resetButtonPressed(sender: UIButton) {
        self.buildSudoku()
        self.updateSudokuBoardDisplay()
    }
    
    func buildSudoku() {
        sudokuBoard.clearBoard()
        sudokuBoard.buildSolution()
        if self.debug > 0 {
            print(sudokuBoard.dumpSolutionBoard())
        }
        sudokuBoard.buildGameBoard()
        sudokuBoard.buildOriginBoard()
        return
    }
    
    func updateSudokuBoardDisplay() {
        for y: Int in 0 ..< self.displayBoard.boardRows {
            for x: Int in 0 ..< self.displayBoard.boardColumns {
                let cellImages: CellImages = self.displayBoard.gameImages[y][x]
                for j: Int in 0 ..< cellImages.cellRows {
                    for k: Int in 0 ..< cellImages.cellColumns {
                        let number: Int = self.sudokuBoard.getNumberFromGameBoard(y, boardColumn: x, cellRow: j, cellColumn: k) - 1
                        if (number > -1) {
                            cellImages.setToImage(j, column: k, imageToSet: self.imageLibrary[self.activeImageSet][number])
                        }
                    }
                }
            }
        }
        return
    }

}