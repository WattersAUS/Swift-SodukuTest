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
    let kCellWidthMargin: CGFloat = 9
    let kCellDepthMargin: CGFloat = 7
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
    // default image set (imagestate == 0)
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
        UIImage(named:"Alt001_default.png")!,
        UIImage(named:"Alt002_default.png")!,
        UIImage(named:"Alt003_default.png")!,
        UIImage(named:"Alt004_default.png")!,
        UIImage(named:"Alt005_default.png")!,
        UIImage(named:"Alt006_default.png")!,
        UIImage(named:"Alt007_default.png")!,
        UIImage(named:"Alt008_default.png")!,
        UIImage(named:"Alt009_default.png")!,
        UIImage(named:"ImageClear_default.png")!,
        UIImage(named:"ImageReverse_default.png")!,
        UIImage(named:"ImageForward_default.png")!
    ]]

    // highlighted image set to use when user has selected 'number' to insert hightlight common images across board (imagestate == 1)
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
        UIImage(named:"Alt001_highlight.png")!,
        UIImage(named:"Alt002_highlight.png")!,
        UIImage(named:"Alt003_highlight.png")!,
        UIImage(named:"Alt004_highlight.png")!,
        UIImage(named:"Alt005_highlight.png")!,
        UIImage(named:"Alt006_highlight.png")!,
        UIImage(named:"Alt007_highlight.png")!,
        UIImage(named:"Alt008_highlight.png")!,
        UIImage(named:"Alt009_highlight.png")!,
        UIImage(named:"ImageClear_highlight.png")!,
        UIImage(named:"ImageReverse_highlight.png")!,
        UIImage(named:"ImageForward_highlight.png")!
    ]]
    
    // when user selects from control panel (imagestate == 2)
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
        UIImage(named:"Alt001_select.png")!,
        UIImage(named:"Alt002_select.png")!,
        UIImage(named:"Alt003_select.png")!,
        UIImage(named:"Alt004_select.png")!,
        UIImage(named:"Alt005_select.png")!,
        UIImage(named:"Alt006_select.png")!,
        UIImage(named:"Alt007_select.png")!,
        UIImage(named:"Alt008_select.png")!,
        UIImage(named:"Alt009_select.png")!,
        UIImage(named:"ImageClear_select.png")!,
        UIImage(named:"ImageReverse_select.png")!,
        UIImage(named:"ImageForward_select.png")!
    ]]
    
    // start of the code!!!!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.sudokuBoard = GameBoard(size: self.boardDimensions, setDifficulty: self.gameDifficulty)
        self.displayBoard = GameBoardImages(size: self.boardDimensions)
        self.controlPanelImages = CellImages(rows: 6, columns: 2)
        //self.view.backgroundColor = UIColor.lightGrayColor()
        self.activeImageSet = 0
        self.initialSudokuBoardDisplay()
        self.initialControlPanelDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //----------------------------------------------------------------------------
    // Handle the board display, setup event handler and detect taps in the board
    //----------------------------------------------------------------------------

    // build the initial board display, with all cells = 0 (ie blank)
    func initialSudokuBoardDisplay() {
        let originX: CGFloat = self.view.bounds.origin.x + self.kMainViewMargin
        let originY: CGFloat = self.kMainViewMargin
        let frameWidth: CGFloat = self.view.bounds.height - (2 * self.kMainViewMargin)
        let frameHeight: CGFloat = self.view.bounds.height - (2 * self.kMainViewMargin)
        self.viewSudokuBoard = UIView(frame: CGRect(x: originX, y: originY, width: frameWidth, height: frameHeight))
        self.view.addSubview(self.viewSudokuBoard)
        self.addImagesViewsToSudokuBoard(self.boardDimensions, boardColumns: self.boardDimensions, cellWidthMargin: self.kCellWidthMargin, cellDepthMargin: self.kCellDepthMargin)
        self.initialiseSudokuBoardUIViewToAcceptTouch(self.viewSudokuBoard)
        return
    }
    
    // add the image containers onto the board by working across until we need to go down a row
    func addImagesViewsToSudokuBoard(boardRows: Int, boardColumns: Int, cellWidthMargin: CGFloat, cellDepthMargin: CGFloat) {
        let cellWidth: CGFloat = self.calculateBoardCellWidth(boardColumns * boardColumns, margin: cellWidthMargin)
        let cellDepth: CGFloat = self.calculateBoardCellWidth(boardRows * boardRows, margin: cellWidthMargin)
        var yStart: CGFloat = cellDepthMargin
        for y: Int in 0 ..< boardRows {
            var jStart: CGFloat = 0
            for j: Int in 0 ..< boardColumns {
                var xStart: CGFloat = cellWidthMargin
                for x: Int in 0 ..< boardRows {
                    var kStart: CGFloat = 0
                    for k: Int in 0 ..< boardColumns {
                        self.displayBoard.gameImages[y][x].cellContents[j][k].imageView.frame = CGRect(x: xStart + kStart, y: yStart + jStart, width: cellWidth, height: cellWidth)
                        self.viewSudokuBoard.addSubview(self.displayBoard.gameImages[y][x].cellContents[j][k].imageView)
                        kStart += cellWidth + cellWidthMargin
                    }
                    xStart += kStart + (cellWidthMargin * 2)
                }
                jStart += cellDepth + cellDepthMargin
            }
            yStart += jStart + (cellDepthMargin * 2)
        }
        return
    }
    
    func calculateBoardCellWidth(boardColumns: Int, margin: CGFloat) -> CGFloat {
        var cellWidth: CGFloat = self.viewSudokuBoard.bounds.width
        cellWidth -= (CGFloat(boardColumns + 1) * margin)
        return cellWidth / CGFloat(boardColumns)
    }
    
    func calculateBoardCellDepth(boardRows: Int, margin: CGFloat) -> CGFloat {
        var cellDepth: CGFloat = self.viewSudokuBoard.bounds.height
        cellDepth -= (CGFloat(boardRows + 1) * margin)
        return cellDepth / CGFloat(boardRows)
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
    
    // handle the user interaction with the game board
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
            self.setCellToBlankImage(cellPosition)
            self.boardSelectedPosition = (-1,-1,-1,-1)
            return
        }
        // if we already have a position and the user had selected another
        if (self.boardSelectedPosition != (-1,-1,-1,-1)) {
            if (self.boardSelectedPosition != cellPosition) {
                self.setCellToBlankImage(self.boardSelectedPosition)
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
                for j: Int in 0 ..< self.displayBoard.gameImages[y][x].cellRows {
                    for k: Int in 0 ..< self.displayBoard.gameImages[y][x].cellColumns {
                        if self.isTapWithinImage(location, image: self.displayBoard.gameImages[y][x].cellContents[j][k].imageView) == true {
                            return(y, x, j, k)
                        }
                    }
                }
            }
        }
        return(-1, -1, -1, -1)
    }
    
    //------------------------------------------------------------------------------------
    // Handle the control panel display, setup event handler and detect taps in the board
    //------------------------------------------------------------------------------------
    func initialControlPanelDisplay() {
        let originX: CGFloat = 813
        let originY: CGFloat = 134
        let frameWidth: CGFloat = 148
        let frameHeight: CGFloat = 430
        self.viewControlPanel = UIView(frame: CGRect(x: originX, y: originY, width: frameWidth, height: frameHeight))
        self.view.addSubview(self.viewControlPanel)
        self.addImageViewsToControlPanelView()
        self.initialiseControlPanelUIViewToAcceptTouch(self.viewControlPanel)
        return
    }
    
    // add the image containers to control panel, set default image, state to 'default'
    func addImageViewsToControlPanelView() {
        let cellWidth: CGFloat = 65
        var yCoord: CGFloat = 0
        var i: Int = 0
        for row: Int in 0 ..< 6 {
            var xCoord: CGFloat = 0
            for column: Int in 0 ..< 2 {
                self.controlPanelImages.cellContents[row][column].imageView.frame = CGRect(x: xCoord, y: yCoord, width: cellWidth, height: cellWidth)
                self.controlPanelImages.cellContents[row][column].imageView.image = self.imageDefaultLibrary[self.activeImageSet][i]
                self.controlPanelImages.cellContents[row][column].state = 0
                self.viewControlPanel.addSubview(self.controlPanelImages.cellContents[row][column].imageView)
                xCoord += cellWidth + 18
                i += 1
            }
            yCoord += cellWidth + 8
        }
        return
    }
    
    // sets up and allows touches to be detected on SudokuBoard view only
    func initialiseControlPanelUIViewToAcceptTouch(view: UIView) {
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.detectedControlPanelUIViewTapped(_:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        view.addGestureRecognizer(singleTap)
        view.userInteractionEnabled = true
        return
    }
    
    // handle user interactiom with the control panel
    func detectedControlPanelUIViewTapped(recognizer: UITapGestureRecognizer) {
        if recognizer.state != UIGestureRecognizerState.Ended {
            return
        }
        // check we have a board in play otherwise ignore (THIS DOEST WORK...NEEDS REWORK)
        if self.sudokuBoard.gameBoardCells.count == 0 {
            return
        }
        // has the user tapped in a control panel icon?
        let panelPosn: (panelRow: Int, panelColumn: Int) = self.getPositionOfControlPanelImageTapped(recognizer.locationInView(recognizer.view))
        if panelPosn == (-1, -1) {
            return
        }
        // always unselect the old position
        if self.panelSelectedPosition != (-1, -1) {
            // control panel is a 2x6 grid
            let pIndex: Int = (self.panelSelectedPosition.panelRow * 2) + self.panelSelectedPosition.panelColumn
            self.controlPanelImages.setImage(panelSelectedPosition.panelRow, column: panelSelectedPosition.panelColumn, imageToSet: self.imageDefaultLibrary[self.activeImageSet][pIndex], imageState: 0)
            self.unsetHighlightedNumbersOnBoard()
        }
        // if not different to previous, set posn as invalid
        if self.panelSelectedPosition == panelPosn {
            self.panelSelectedPosition = (-1, -1)
            return
        }
        // a new position needs to be highlighted
        self.panelSelectedPosition = panelPosn
        let panelIndex: Int = (panelPosn.panelRow * 2) + panelPosn.panelColumn
        self.controlPanelImages.setImage(panelPosn.panelRow, column: panelPosn.panelColumn, imageToSet: self.imageHighlightLibrary[self.activeImageSet][panelIndex], imageState: 1)
        // only need to highlight numbers on the board when the control panel numbers are selected, otherwise another function needs to be performed
        switch panelIndex {
        case 0..<9:
            self.setHighlightedNumbersOnBoard(panelIndex)
        case 9:
            break
        case 10:
            break
        case 11:
            break
        default:
            // should never happen
            break
        }
        return
    }
    
    func getPositionOfControlPanelImageTapped(location: CGPoint) -> (panelRow: Int, panelColumn: Int) {
        for y: Int in 0 ..< self.controlPanelImages.cellRows {
            for x: Int in 0 ..< self.controlPanelImages.cellColumns {
                if self.isTapWithinImage(location, image: self.controlPanelImages.cellContents[y][x].imageView) == true {
                    return(y, x)
                }
            }
        }
        return(-1, -1)
    }

    // traverse game board and 'unset' any highlighted numbers
    // ---->>>> (will be allowed by difficulty setting in later version) <<<<------
    func unsetHighlightedNumbersOnBoard() {
        let locations: [(boardRow: Int, boardColumn: Int, cellRow: Int, cellColumn: Int)] = self.displayBoard.getLocationsOfHighlightedImagesOnBoard()
        if locations.isEmpty == false {
            for coords in locations {
                self.setCellToDefaultImage(coords, number: self.sudokuBoard.gameBoardCells[coords.boardRow][coords.boardColumn].getNumberAtCellPosition(coords.cellRow, column: coords.cellColumn))
            }
        }
        return
    }
    
    // traverse game board and 'set' any selected numbers to highlighted
    // ---->>>> (will be allowed by difficulty setting) <<<<------
    func setHighlightedNumbersOnBoard(index: Int) {
        // index will give the 'number' selected from the control panel
        let locations: [(boardRow: Int, boardColumn: Int, cellRow: Int, cellColumn: Int)] = self.sudokuBoard.getLocationsOfNumberOnBoard(index + 1)
        if locations.isEmpty == false {
            for coord in locations {
                self.setCellToHighlightedImage(coord, number: index + 1)
            }
        }
        return
    }

    // set numbers on the 'game' board to highlighted if the user selects the 'number' from the control panel
    func setCellToHighlightedImage(boardPosition: (boardRow: Int, boardColumn: Int, cellRow: Int, cellColumn: Int), number: Int) {
        self.displayBoard.gameImages[boardPosition.boardRow][boardPosition.boardColumn].setImage(boardPosition.cellRow, column: boardPosition.cellColumn, imageToSet: self.imageHighlightLibrary[self.activeImageSet][number - 1], imageState: 1)
        return
    }
    
    // set numbers on the 'game' board to default if the user selects the 'number' from the control panel
    func setCellToDefaultImage(boardPosition: (boardRow: Int, boardColumn: Int, cellRow: Int, cellColumn: Int), number: Int) {
        self.displayBoard.gameImages[boardPosition.boardRow][boardPosition.boardColumn].setImage(boardPosition.cellRow, column: boardPosition.cellColumn, imageToSet: self.imageDefaultLibrary[self.activeImageSet][number - 1], imageState: 0)
        return
    }

    func updateControlPanelDisplay() {
        return
    }

    // detect if the user has selected within a designated image view
    func isTapWithinImage(location: CGPoint, image: UIImageView) -> Bool {
        if (location.x >= image.frame.origin.x) && (location.x <= (image.frame.origin.x + image.frame.width)) {
            if (location.y >= image.frame.origin.y) && (location.y <= (image.frame.origin.y + image.frame.height)) {
                return true
            }
        }
        return false
    }

    // update cell image, selected or deselected
    func setCellToSelectedImage(boardPosition: (boardRow: Int, boardColumn: Int, cellRow: Int, cellColumn: Int)) {
        self.displayBoard.gameImages[boardPosition.boardRow][boardPosition.boardColumn].setImage(boardPosition.cellRow, column: boardPosition.cellColumn, imageToSet: self.selectedImage, imageState: 0)
        return
    }
    
    func setCellToBlankImage(boardPosition: (boardRow: Int, boardColumn: Int, cellRow: Int, cellColumn: Int)) {
        self.displayBoard.gameImages[boardPosition.boardRow][boardPosition.boardColumn].unsetImage(boardPosition.cellRow, column: boardPosition.cellColumn)
        return
    }
    
    // user presses the 'Start' button
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
                for j: Int in 0 ..< self.displayBoard.gameImages[y][x].cellRows {
                    for k: Int in 0 ..< self.displayBoard.gameImages[y][x].cellColumns {
                        self.displayBoard.gameImages[y][x].unsetImage(j, column: k)
                        let number: Int = self.sudokuBoard.getNumberFromGameBoard(y, boardColumn: x, cellRow: j, cellColumn: k) - 1
                        if (number > -1) {
                            self.displayBoard.gameImages[y][x].setImage(j, column: k, imageToSet: self.imageDefaultLibrary[self.activeImageSet][number], imageState: 0)
                        }
                    }
                }
            }
        }
        return
    }

    // captures user pressing the 'Settings' button
    @IBAction func settingButtonPressed(sender: UIButton) {
        // NEEDS WORK HERE TO DISPLAY AND MANAGE THE SETTINGS DIALOG
    }

}