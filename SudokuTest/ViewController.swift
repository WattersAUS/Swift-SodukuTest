//
//  ViewController.swift
//  SudokuTest
//
//  Created by Graham Watson on 06/03/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var debug: Int = 1
    var boardDimensions: Int = 3
    var gameDifficulty: Int = 5
    
    // where to start drawing the board
    let kMainViewMargin: CGFloat = 40.0

    // the board to solve
    var viewSudokuBoard: UIView!
    let kCellMargin: CGFloat = 5
    var sudokuBoard: GameBoard!
    var displayBoard: GameBoardImages!
    // current selected board position (if any, -1 if none)
    var boardSelectedPosition: (boardRow: Int, boardColumn: Int, cellRow: Int, cellColumn: Int) = (-1, -1, -1, -1)
    
    // the control panel
    var viewControlPanel: UIView!
    let kPanelMargin: CGFloat = 5
    var controlPanelImages: CellImages!
    // current selected board position (if any, -1 if none)
    var panelSelectedPosition: (panelRow: Int, panelColumn: Int) = (-1, -1)

    // numbers to insert into the board, rewind, replay, reset etc
    var selectedImage: UIImage = UIImage(named:"Selected.png")!

    // which set of images is currently active
    var activeImageSet: Int = 0
    // default image set
    var imageDefaultLibrary: [[UIImage]] = [[
        UIImage(named:"Image001_default.png")!,
        UIImage(named:"Image002_default.png")!,
        UIImage(named:"Image003_default.png")!,
        UIImage(named:"Image004_default.png")!,
        UIImage(named:"Image005_default.png")!,
        UIImage(named:"Image006_default.png")!,
        UIImage(named:"Image007_default.png")!,
        UIImage(named:"Image008_default.png")!,
        UIImage(named:"Image009_default.png")!,
        UIImage(named:"ImageClear_default.png")!,
        UIImage(named:"ImageReverse_default.png")!,
        UIImage(named:"ImageForward_default.png")!
        ],[
        ]]

    // highlighted image set to use when user has selected 'number' to insert hightlight common images across board
    var imageHighlightLibrary: [[UIImage]] = [[
        UIImage(named:"Image001_highlight.png")!,
        UIImage(named:"Image002_highlight.png")!,
        UIImage(named:"Image003_highlight.png")!,
        UIImage(named:"Image004_highlight.png")!,
        UIImage(named:"Image005_highlight.png")!,
        UIImage(named:"Image006_highlight.png")!,
        UIImage(named:"Image007_highlight.png")!,
        UIImage(named:"Image008_highlight.png")!,
        UIImage(named:"Image009_highlight.png")!,
        UIImage(named:"ImageClear_highlight.png")!,
        UIImage(named:"ImageReverse_highlight.png")!,
        UIImage(named:"ImageForward_highlight.png")!
        ],[
        ]]
    
    // when user selects from control panel
    var imageSelectLibrary: [[UIImage]] = [[
        UIImage(named:"Image001_select.png")!,
        UIImage(named:"Image002_select.png")!,
        UIImage(named:"Image003_select.png")!,
        UIImage(named:"Image004_select.png")!,
        UIImage(named:"Image005_select.png")!,
        UIImage(named:"Image006_select.png")!,
        UIImage(named:"Image007_select.png")!,
        UIImage(named:"Image008_select.png")!,
        UIImage(named:"Image009_select.png")!,
        UIImage(named:"ImageClear_select.png")!,
        UIImage(named:"ImageReverse_select.png")!,
        UIImage(named:"ImageForward_select.png")!
        ],[
        ]]
    
    // start of the code!!!!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.sudokuBoard = GameBoard(size: self.boardDimensions, setDifficulty: self.gameDifficulty)
        self.displayBoard = GameBoardImages(size: self.boardDimensions)
        self.controlPanelImages = CellImages(rows: 6, columns: 2)
        self.view.backgroundColor = UIColor.lightGrayColor()
        self.activeImageSet = 0
        self.initialSudokuBoardDisplay()
        self.initialControlPanelDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //
    // Handle the board display, setup event handler and detect taps in the board
    //
    
    // build the initial board display, with all cells = 0 (ie blank)
    func initialSudokuBoardDisplay() {
        let originX: CGFloat = self.view.bounds.origin.x + self.kMainViewMargin
        let originY: CGFloat = self.kMainViewMargin
        let frameWidth: CGFloat = self.view.bounds.height - (2 * self.kMainViewMargin)
        let frameHeight: CGFloat = self.view.bounds.height - (2 * self.kMainViewMargin)
        self.viewSudokuBoard = UIView(frame: CGRect(x: originX, y: originY, width: frameWidth, height: frameHeight))
        self.view.addSubview(self.viewSudokuBoard)
        self.addInitialImagesToSudokuBoardView(self.boardDimensions, boardColumns: self.boardDimensions, cellMargin: self.kCellMargin)
        self.initialiseSudokuBoardUIViewToAcceptTouch(self.viewSudokuBoard)
        return
    }
    
    // add the image containers onto the board by working across until we need to go down a row
    func addInitialImagesToSudokuBoardView(boardRows: Int, boardColumns: Int, cellMargin: CGFloat) {
        let cellWidth: CGFloat = self.calculateBoardCellWidth(boardColumns * boardColumns, margin: cellMargin)
        var yStart: CGFloat = cellMargin
        for y: Int in 0 ..< boardRows {
            var jStart: CGFloat = 0
            for j: Int in 0 ..< boardColumns {
                var xStart: CGFloat = cellMargin
                for x: Int in 0 ..< boardRows {
                    var kStart: CGFloat = 0
                    for k: Int in 0 ..< boardColumns {
                        let xCoord: CGFloat = xStart + kStart
                        let yCoord: CGFloat = yStart + jStart
                        let cellImages: CellImages = self.displayBoard.gameImages[y][x]
                        let content: CellContent = cellImages.cellContents[j][k]
                        let imageContent: UIImageView = content.cellImageView
                        imageContent.frame = CGRect(x: xCoord, y: yCoord, width: cellWidth, height: cellWidth)
                        self.viewSudokuBoard.addSubview(imageContent)
                        kStart += cellWidth + cellMargin
                    }
                    xStart += kStart + (cellMargin * 2)
                }
                jStart += cellWidth + cellMargin
            }
            yStart += jStart + (cellMargin * 2)
        }
        return
    }
    
    func calculateBoardCellWidth(boardColumns: Int, margin: CGFloat) -> CGFloat {
        var cellWidth: CGFloat = self.viewSudokuBoard.bounds.width
        cellWidth -= (CGFloat(boardColumns + 1) * margin)
        return cellWidth / CGFloat(boardColumns)
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
        let cellPosition: (boardRow: Int, boardColumn: Int, cellRow: Int, cellColumn: Int) = self.getPositionOfSudokuBoardImageTapped(recognizer.locationInView(recognizer.view))
        if cellPosition.boardColumn == -1 {
            return
        }
        // the user cannot select an 'origin' cell
        if self.sudokuBoard.originBoardCells[cellPosition.boardRow][cellPosition.boardColumn].getNumberAtCellPosition(cellPosition.cellRow, column: cellPosition.cellColumn) > 0 {
            return
        }
        // if the user selected the same position, clear it
        if (self.boardSelectedPosition == cellPosition) {
            self.setCellToDefaultImage(cellPosition)
            self.boardSelectedPosition = (-1,-1,-1,-1)
            return
        }
        // if we already have a position and the user had selected another
        if (self.boardSelectedPosition != (-1,-1,-1,-1)) {
            if (self.boardSelectedPosition != cellPosition) {
                self.setCellToDefaultImage(self.boardSelectedPosition)
            }
        }
        // update currently selected position
        self.boardSelectedPosition = (cellPosition.boardRow, cellPosition.boardColumn, cellPosition.cellRow, cellPosition.cellColumn)
        self.setCellToSelectedImage(self.boardSelectedPosition)
        return
    }
    
    func getPositionOfSudokuBoardImageTapped(location: CGPoint) -> (boardRow: Int, boardColumn: Int, cellRow: Int, cellColumn: Int) {
        for y: Int in 0 ..< self.displayBoard.boardRows {
            for x: Int in 0 ..< self.displayBoard.boardColumns {
                let cellImages: CellImages = self.displayBoard.gameImages[y][x]
                for j: Int in 0 ..< cellImages.cellRows {
                    for k: Int in 0 ..< cellImages.cellColumns {
                        let cellContent: CellContent = cellImages.cellContents[j][k]
                        let cellImage: UIImageView = cellContent.cellImageView
                        if self.isTapWithinImage(location, image: cellImage) == true {
                            return(y, x, j, k)
                        }
                    }
                }
            }
        }
        return(-1, -1, -1, -1)
    }
    
//    func isTapWithinSudokuBoardImage(location: CGPoint, image: UIImageView) -> Bool {
//        if (location.x >= image.frame.origin.x) && (location.x <= (image.frame.origin.x + image.frame.width)) {
//            if (location.y >= image.frame.origin.y) && (location.y <= (image.frame.origin.y + image.frame.height)) {
//                return true
//            }
//        }
//        return false
//    }

    func isTapWithinImage(location: CGPoint, image: UIImageView) -> Bool {
        if (location.x >= image.frame.origin.x) && (location.x <= (image.frame.origin.x + image.frame.width)) {
            if (location.y >= image.frame.origin.y) && (location.y <= (image.frame.origin.y + image.frame.height)) {
                return true
            }
        }
        return false
    }
    
    //
    // end of board display code
    //
    
    //
    // Handle the control panel display, setup event handler and detect taps in the board
    //
    
    func initialControlPanelDisplay() {
        let originX: CGFloat = 813
        let originY: CGFloat = 134
        let frameWidth: CGFloat = 148
        let frameHeight: CGFloat = 430
        self.viewControlPanel = UIView(frame: CGRect(x: originX, y: originY, width: frameWidth, height: frameHeight))
        self.view.addSubview(self.viewControlPanel)
        self.addInitialImagesToControlPanelView()
        self.initialiseControlPanelUIViewToAcceptTouch(self.viewControlPanel)
        return
    }
    
    // add the image containers onto the control panel
    func addInitialImagesToControlPanelView() {
        let cellWidth: CGFloat = 65
        var yCoord: CGFloat = 0
        var i: Int = 0
        for row: Int in 0 ..< 6 {
            var xCoord: CGFloat = 0
            for column: Int in 0 ..< 2 {
                let cellContent: CellContent = self.controlPanelImages.cellContents[row][column]
                let imageView: UIImageView = cellContent.cellImageView
                imageView.frame = CGRect(x: xCoord, y: yCoord, width: cellWidth, height: cellWidth)
                imageView.image = self.imageDefaultLibrary[self.activeImageSet][i]
                self.viewControlPanel.addSubview(imageView)
                xCoord += cellWidth + 18
                i += 1
            }
            yCoord += cellWidth + 8
        }
        return
    }
    
//    func calculateControlPanelCellWidth(boardColumns: Int, margin: CGFloat) -> CGFloat {
//        var cellWidth: CGFloat = self.viewControlPanel.bounds.width
//        cellWidth -= (CGFloat(boardColumns + 1) * margin)
//        return cellWidth / CGFloat(boardColumns)
//    }
    
    // sets up and allows touches to be detected on SudokuBoard view only
    func initialiseControlPanelUIViewToAcceptTouch(view: UIView) {
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.detectedControlPanelUIViewTapped(_:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        view.addGestureRecognizer(singleTap)
        view.userInteractionEnabled = true
        return
    }
    
    func detectedControlPanelUIViewTapped(recognizer: UITapGestureRecognizer) {
        if(recognizer.state != UIGestureRecognizerState.Ended) {
            return
        }
        // check we have a board in play otherwise ignore
        if self.sudokuBoard.gameBoardCells.count == 0 {
            return
        }
        // has the user tapped in a control panel icon?
        let panelPosition: (panelRow: Int, panelColumn: Int) = self.getPositionOfControlPanelImageTapped(recognizer.locationInView(recognizer.view))
        if panelPosition.panelColumn == -1 {
            return
        }
        
        // REVAMP for CONTROL HANDLING
//        // if the user selectd the same position then wipe it out
//        if (self.currentSelectedPosition == cellPosition) {
//            self.setCellToDefaultImage(cellPosition)
//            self.currentSelectedPosition = (-1,-1,-1,-1)
//            return
//        }
//        // if we already have a position and the user had selected another position
//        if (self.currentSelectedPosition != (-1,-1,-1,-1)) {
//            if (self.currentSelectedPosition != cellPosition) {
//                self.setCellToDefaultImage(self.currentSelectedPosition)
//            }
//        }
        
        // update currently selected position
        self.panelSelectedPosition = panelPosition
        //self.setCellToSelectedImage(self.currentSelectedPosition)
        return
    }
    
    func getPositionOfControlPanelImageTapped(location: CGPoint) -> (panelRow: Int, panelColumn: Int) {
        for y: Int in 0 ..< self.controlPanelImages.cellRows {
            for x: Int in 0 ..< self.controlPanelImages.cellColumns {
                let cellContent: CellContent = self.controlPanelImages.cellContents[y][x]
                let panelImage: UIImageView = cellContent.cellImageView
                if self.isTapWithinImage(location, image: panelImage) == true {
                    return(y, x)
                }
            }
        }
        return(-1, -1)
    }
    
    //
    // end of control panel code
    //
    
    // update cell colours when selected or deselected
    func setCellToSelectedImage(boardPosition: (boardRow: Int, boardColumn: Int, cellRow: Int, cellColumn: Int)) {
        let cellImages: CellImages = self.displayBoard.gameImages[boardPosition.boardRow][boardPosition.boardColumn]
        cellImages.setToImage(boardPosition.cellRow, column: boardPosition.cellColumn, imageToSet: self.selectedImage, imageState: 0)
        return
    }
    
    func setCellToDefaultImage(boardPosition: (boardRow: Int, boardColumn: Int, cellRow: Int, cellColumn: Int)) {
        let cellImages: CellImages = self.displayBoard.gameImages[boardPosition.boardRow][boardPosition.boardColumn]
        cellImages.unsetToImage(boardPosition.cellRow, column: boardPosition.cellColumn)
        return
    }
    
    @IBAction func resetButtonPressed(sender: UIButton) {
        self.buildSudoku()
        self.updateSudokuBoardDisplay()
        self.updateControlPanelDisplay()
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
                        cellImages.unsetToImage(j, column: k)
                        let number: Int = self.sudokuBoard.getNumberFromGameBoard(y, boardColumn: x, cellRow: j, cellColumn: k) - 1
                        if (number > -1) {
                            cellImages.setToImage(j, column: k, imageToSet: self.imageDefaultLibrary[self.activeImageSet][number], imageState: 0)
                        }
                    }
                }
            }
        }
        return
    }

    func updateControlPanelDisplay() {
        return
    }

    
}