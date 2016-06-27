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
    var gameDifficulty: Int = 6

    //
    // defaults for positioning UIImageView components
    //
    let kMainViewMargin: CGFloat = 40.0
    let kCellWidthMargin: CGFloat = 9
    let kCellDepthMargin: CGFloat = 7

    //
    // the board to solve
    //
    var viewSudokuBoard: UIView!
    var sudokuBoard: GameBoard!
    var displayBoard: GameBoardImages!
    // current selected board position (if any, -1 if none)
    var boardSelectedPosition: (row: Int, column: Int, cellRow: Int, cellColumn: Int) = (-1, -1, -1, -1)
    // has user started playing?
    var gameBoardInPlay: Bool = false
    
    //
    // user progress through puzzle
    //
    var userSolution: TrackSolution!
    
    //
    // the control panel
    //
    var viewControlPanel: UIView!
    let kPanelMargin: CGFloat = 5
    var controlPanelImages: CellImages!
    // current crtl panel position (if any)
    var controlSelected: (row: Int, column: Int) = (-1, -1)

    //
    // image sets and related vars
    //
    enum imgStates: Int {
        case Default = 0
        case Selected = 1
        case Highlighted = 2
        case Origin = 3
        case Delete = 4
    }
    enum imageSet: Int {
        case Default = 0
        case Greek = 1
        case Images = 3
    }
    var activeImageSet: Int = imageSet.Default.rawValue
    //
    // images that will be swapped on starting/reseting board
    //
    var startImageLibrary: [UIImage] = [
        UIImage(named:"ImageStart_default.png")!,
        UIImage(named:"ImageStart_select.png")!,
        UIImage(named:"ImageStart_select.png")!
    ]
    var resetImageLibrary: [UIImage] = [
        UIImage(named:"ImageReset_default.png")!,
        UIImage(named:"ImageReset_select.png")!,
        UIImage(named:"ImageReset_select.png")!
    ]
    //
    // app settings dialog
    //
    var settingsImageLibrary: [UIImage] = [
        UIImage(named:"AltSpanner_default.png")!,
        UIImage(named:"AltSpanner_select.png")!,
        UIImage(named:"AltSpanner_select.png")!
    ]
    //
    // default image set (imagestate == 0)
    //
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
    //
    // when user selects from control panel (imagestate == 1)
    //
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
    //
    // highlighted images to use when the user wants to see the puzzle start position
    //
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
    //
    // images to highlight origin positions that cannot be deleted
    //
    var imageOriginLibrary: [[UIImage]] = [[
        UIImage(named:"Image001_origin.png")!,
        UIImage(named:"Image002_origin.png")!,
        UIImage(named:"Image003_origin.png")!,
        UIImage(named:"Image004_origin.png")!,
        UIImage(named:"Image005_origin.png")!,
        UIImage(named:"Image006_origin.png")!,
        UIImage(named:"Image007_origin.png")!,
        UIImage(named:"Image008_origin.png")!,
        UIImage(named:"Image009_origin.png")!,
        UIImage(named:"ImageClear_origin.png")!,
        UIImage(named:"ImageReverse_origin.png")!,
        UIImage(named:"ImageForward_origin.png")!
    ],[
        UIImage(named:"Alt001_origin.png")!,
        UIImage(named:"Alt002_origin.png")!,
        UIImage(named:"Alt003_origin.png")!,
        UIImage(named:"Alt004_origin.png")!,
        UIImage(named:"Alt005_origin.png")!,
        UIImage(named:"Alt006_origin.png")!,
        UIImage(named:"Alt007_origin.png")!,
        UIImage(named:"Alt008_origin.png")!,
        UIImage(named:"Alt009_origin.png")!,
        UIImage(named:"ImageClear_origin.png")!,
        UIImage(named:"ImageReverse_origin.png")!,
        UIImage(named:"ImageForward_origin.png")!
    ]]
    //
    // images to highlight origin positions that cannot be deleted
    //
    var imageDeleteLibrary: [[UIImage]] = [[
        UIImage(named:"Image001_delete.png")!,
        UIImage(named:"Image002_delete.png")!,
        UIImage(named:"Image003_delete.png")!,
        UIImage(named:"Image004_delete.png")!,
        UIImage(named:"Image005_delete.png")!,
        UIImage(named:"Image006_delete.png")!,
        UIImage(named:"Image007_delete.png")!,
        UIImage(named:"Image008_delete.png")!,
        UIImage(named:"Image009_delete.png")!,
        UIImage(named:"ImageClear_delete.png")!,
        UIImage(named:"ImageReverse_delete.png")!,
        UIImage(named:"ImageForward_delete.png")!
    ],[
        UIImage(named:"Alt001_delete.png")!,
        UIImage(named:"Alt002_delete.png")!,
        UIImage(named:"Alt003_delete.png")!,
        UIImage(named:"Alt004_delete.png")!,
        UIImage(named:"Alt005_delete.png")!,
        UIImage(named:"Alt006_delete.png")!,
        UIImage(named:"Alt007_delete.png")!,
        UIImage(named:"Alt008_delete.png")!,
        UIImage(named:"Alt009_delete.png")!,
        UIImage(named:"ImageClear_delete.png")!,
        UIImage(named:"ImageReverse_delete.png")!,
        UIImage(named:"ImageForward_delete.png")!
    ]]
    
    //----------------------------------------------------------------------------
    // start of the code!!!!
    //----------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.sudokuBoard = GameBoard(size: self.boardDimensions, setDifficulty: self.gameDifficulty)
        self.displayBoard = GameBoardImages(size: self.boardDimensions)
        self.controlPanelImages = CellImages(rows: 6, columns: 2)
        self.userSolution = TrackSolution(row: self.boardDimensions, column: self.boardDimensions, cellRow: self.boardDimensions, cellColumn: self.boardDimensions)
        self.activeImageSet = 0
        self.initialSudokuBoardDisplay()
        self.initialControlPanelDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //----------------------------------------------------------------------------
    // user presses the 'Start' or 'Reset' button
    //----------------------------------------------------------------------------
    @IBAction func resetButtonPressed(sender: UIButton) {
        //
        // if we have 'Start' button, build the board
        //
        if UIImagePNGRepresentation((sender.imageView?.image)!)!.isEqual(UIImagePNGRepresentation(self.startImageLibrary[imgStates.Default.rawValue])) == true {
            sender.setImage(self.resetImageLibrary[imgStates.Default.rawValue], forState: UIControlState.Normal)
            self.sudokuBoard.clearBoard()
            self.sudokuBoard.buildSolution()
            if self.debug > 0 {
                print(sudokuBoard.dumpSolutionBoard())
            }
            self.sudokuBoard.buildOriginBoard()
            self.sudokuBoard.initialiseGameBoard()
            self.userSolution.clearCoordinates()
            self.updateSudokuBoardDisplay()
            self.controlSelected = (-1, -1)
            self.boardSelectedPosition = (-1, -1, -1, -1)
            self.gameBoardInPlay = true
        } else {
            //
            // then we can:
            //
            //      1. cancel and forget the user asked to reset
            //      2. go back to the start of the current game
            //      3. restart the game
            //
            let alertController = UIAlertController(title: "Reset Options", message: "So you want to reset the puzzle?", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action:UIAlertAction!) in //action -> Void in
                // nothing to do here, user bailed on reseting the game
            }
            alertController.addAction(cancelAction)
            let resetAction = UIAlertAction(title: "Reset the board to the beginning", style: .Default) { (action:UIAlertAction!) in
                self.resetControlPanelSelection()
                self.sudokuBoard.initialiseGameBoard()
                self.userSolution.clearCoordinates()
                self.updateSudokuBoardDisplay()
                self.controlSelected = (-1, -1)
                self.boardSelectedPosition = (-1, -1, -1, -1)
                self.gameBoardInPlay = true
            }
            alertController.addAction(resetAction)
            let restartAction = UIAlertAction(title: "Restart the puzzle to blank", style: .Default) { (action:UIAlertAction!) in
                self.resetControlPanelSelection()
                sender.setImage(self.startImageLibrary[imgStates.Default.rawValue], forState: UIControlState.Normal)
                self.sudokuBoard.clearBoard()
                self.userSolution.clearCoordinates()
                self.updateSudokuBoardDisplay()
                self.controlSelected = (-1, -1)
                self.boardSelectedPosition = (-1, -1, -1, -1)
                self.gameBoardInPlay = false
            }
            alertController.addAction(restartAction)
            self.presentViewController(alertController, animated: true, completion:nil)
        }
    }
    
    //
    // clear any selection the user might have left in the control panel
    //
    func resetControlPanelSelection() {
        if self.controlSelected != (-1, -1) {
            let index: Int = (self.controlSelected.row * 2) + self.controlSelected.column
            self.controlPanelImages.setImage(self.controlSelected.row, column: self.controlSelected.column, imageToSet: self.imageOriginLibrary[self.activeImageSet][index], imageState: imgStates.Origin.rawValue)
        }
        return
    }
    
    //
    // redisplay the whole current board, remember origin cells look different
    //
    func updateSudokuBoardDisplay() {
        for y: Int in 0 ..< self.displayBoard.boardRows {
            for x: Int in 0 ..< self.displayBoard.boardColumns {
                for j: Int in 0 ..< self.displayBoard.gameImages[y][x].cellRows {
                    for k: Int in 0 ..< self.displayBoard.gameImages[y][x].cellColumns {
                        self.setCellToBlankImage((y, column: x, cellRow: j, cellColumn: k))
                        let number: Int = self.sudokuBoard.getNumberFromGameBoard((y, column: x, cellRow: j, cellColumn: k))
                        if (number > 0) {
                            if self.sudokuBoard.isOriginBoardCellUsed((y, column: x, cellRow: j, cellColumn: k)) {
                                self.setCoordToOriginImage((y, column: x, cellRow: j, cellColumn: k), number: number)
                            } else {
                                self.setCoordToDefaultImage((y, column: x, cellRow: j, cellColumn: k), number: number)
                            }
                        }
                    }
                }
            }
        }
        return
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
    
    //
    // add the image containers to the control panel, set default image, state to 'default'
    //
    func addImageViewsToControlPanelView() {
        let cellWidth: CGFloat = 65
        var yCoord: CGFloat = 0
        var i: Int = 0
        for row: Int in 0 ..< 6 {
            var xCoord: CGFloat = 0
            for column: Int in 0 ..< 2 {
                self.controlPanelImages.cellContents[row][column].imageView.frame = CGRect(x: xCoord, y: yCoord, width: cellWidth, height: cellWidth)
                self.controlPanelImages.cellContents[row][column].imageView.image = self.imageOriginLibrary[self.activeImageSet][i]
                self.controlPanelImages.cellContents[row][column].state = imgStates.Origin.rawValue
                self.viewControlPanel.addSubview(self.controlPanelImages.cellContents[row][column].imageView)
                xCoord += cellWidth + 18
                i += 1
            }
            yCoord += cellWidth + 8
        }
        return
    }
    
    //
    // sets up and allows touches to be detected on SudokuBoard view only
    //
    func initialiseControlPanelUIViewToAcceptTouch(view: UIView) {
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.detectedControlPanelUIViewTapped(_:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        view.addGestureRecognizer(singleTap)
        view.userInteractionEnabled = true
        return
    }
    
    //
    // user interactiom with the control panel
    //
    func detectedControlPanelUIViewTapped(recognizer: UITapGestureRecognizer) {
        if recognizer.state != UIGestureRecognizerState.Ended {
            return
        }
        //
        // only worried if a board is in play
        //
        if self.gameBoardInPlay == false {
            return
        }
        //
        // has the user tapped in a control panel icon?
        //
        let posn: (row: Int, column: Int) = self.getPositionOfControlPanelImageTapped(recognizer.locationInView(recognizer.view))
        if posn == (-1, -1) {
            return
        }
        let index: Int = (posn.row * 2) + posn.column
        //
        // if we need to blank out the previous selected control panel icon
        //
        var pIndex: Int = -1
        if self.controlSelected != (-1, -1) {
            pIndex = (self.controlSelected.row * 2) + self.controlSelected.column
            self.controlPanelImages.setImage(controlSelected.row, column: controlSelected.column, imageToSet: self.imageOriginLibrary[self.activeImageSet][pIndex], imageState: imgStates.Origin.rawValue)
        }
        switch index {
        case 0..<9:
            //
            // revert any previously selected positions
            //
            if pIndex > -1 {
                switch pIndex {
                case 0..<9:
                    self.unsetSelectNumbersOnBoard()
                    break
                case 9:
                    self.unsetDeleteNumbersOnBoard()
                    break
                case 10:
                    break
                case 11:
                    break
                default:
                    break
                }
            }
            //
            // if the posn selected is the same as before then bail, we want the user to select a new one. Otherwise highlight the panel number and the board numbers
            //
            if posn == self.controlSelected {
                self.controlSelected = (-1, -1)
                return
            }
            self.controlPanelImages.setImage(posn.row, column: posn.column, imageToSet: self.imageSelectLibrary[self.activeImageSet][index], imageState: imgStates.Selected.rawValue)
            self.setSelectNumbersOnBoard(index)
            break;
        case 9:
            if pIndex > -1 {
                switch pIndex {
                case 0..<9:
                    self.unsetSelectNumbersOnBoard()
                    break
                case 9:
                    self.unsetDeleteNumbersOnBoard()
                    self.controlSelected = (-1, -1)
                    return
                case 10:
                    break
                case 11:
                    break
                default:
                    break
                }
            }
            self.controlPanelImages.setImage(posn.row, column: posn.column, imageToSet: self.imageDeleteLibrary[self.activeImageSet][index], imageState: imgStates.Delete.rawValue)
            self.setDeleteLocationsOnBoard(self.userSolution.getCoordinatesInSolution())
            break
        case 10:
            //
            // rewind up to the first user solution
            //
            self.controlPanelImages.setImage(posn.row, column: posn.column, imageToSet: self.imageSelectLibrary[self.activeImageSet][index], imageState: imgStates.Selected.rawValue)
            break
        case 11:
            //
            // fast forward (if user has rewound solution) to the last user solution
            //
            self.controlPanelImages.setImage(posn.row, column: posn.column, imageToSet: self.imageSelectLibrary[self.activeImageSet][index], imageState: imgStates.Selected.rawValue)
            break
        default:
            //
            // should never happen
            //
            break
        }
        self.controlSelected = posn
        self.boardSelectedPosition = (-1, -1, -1, -1)
        return
    }
    
    func getPositionOfControlPanelImageTapped(location: CGPoint) -> (row: Int, column: Int) {
        for y: Int in 0 ..< self.controlPanelImages.cellRows {
            for x: Int in 0 ..< self.controlPanelImages.cellColumns {
                if self.isTapWithinImage(location, image: self.controlPanelImages.cellContents[y][x].imageView) == true {
                    return(y, x)
                }
            }
        }
        return(-1, -1)
    }
    
    //----------------------------------------------------------------------------
    // Handle the board display, setup event handler and detect taps in the board
    //----------------------------------------------------------------------------

    //
    // build the initial board display, we only do this once!
    //
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
    
    //
    // add the image containers onto the board row by row
    //
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
    
    //
    // sets up and allows touches to be detected on SudokuBoard view only
    //
    func initialiseSudokuBoardUIViewToAcceptTouch(view: UIView) {
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.detectedSudokuBoardUIViewTapped(_:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        view.addGestureRecognizer(singleTap)
        view.userInteractionEnabled = true
        return
    }
    
    //
    // handle user interaction with the game board
    //
    func detectedSudokuBoardUIViewTapped(recognizer: UITapGestureRecognizer) {
        if(recognizer.state != UIGestureRecognizerState.Ended) {
            return
        }
        //
        // we're only interested if the board is in play
        //
        if self.gameBoardInPlay == false {
            return
        }
        //
        // has the user tapped in a cell?
        //
        let posn: (row: Int, column: Int, cellRow: Int, cellColumn: Int) = self.getPositionOfSudokuBoardImageTapped(recognizer.locationInView(recognizer.view))
        if posn.column == -1 {
            return
        }
        //
        // and not an 'origin' cell, that's from before the user started solving, so ignore those
        //
        if self.sudokuBoard.isOriginBoardCellUsed(posn) {
            return
        }
        //
        // we process depending on the control panel posn selected
        //
        if self.controlSelected.row == -1 {
            return
        }
        let index: Int = (self.controlSelected.row * 2) + self.controlSelected.column
        switch index {
        case 0..<9:
            if self.sudokuBoard.isGameBoardCellUsed(posn) {
                return
            }
            if self.sudokuBoard.setNumberOnGameBoard(posn, number: index + 1) {
                self.setCoordToSelectImage(posn, number: index + 1)
                self.userSolution.addCoordinate(posn)
            }
        case 9:
            //
            // when user selects posn on board an it's populated by a user solution, clear it!
            //
            if self.sudokuBoard.isGameBoardCellUsed(posn) == false {
                return
            }
            self.sudokuBoard.clearNumberOnGameBoard(posn)
            self.setCellToBlankImage(posn)
            self.userSolution.removeCoordinate(posn)
            self.boardSelectedPosition = (-1, -1, -1, -1)
            break
        default:
            //
            // should never happen
            //
            break
        }
        return
    }
    
    func getPositionOfSudokuBoardImageTapped(location: CGPoint) -> (row: Int, column: Int, cellRow: Int, cellColumn: Int) {
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
    
    //----------------------------------------------------------------------------
    // all image setting routines live here!
    //----------------------------------------------------------------------------

    // traverse game board and 'unset' any 'select' numbers
    // ---->>>> (will be allowed by difficulty setting in later version) <<<<------
    func unsetSelectNumbersOnBoard() {
        let locations: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] = self.displayBoard.getLocationsOfImages(imgStates.Selected.rawValue)
        self.unsetSelectLocationsOnBoard(locations)
        return
    }

    // traverse game board and 'set' any 'select' numbers to selected
    // ---->>>> (will be allowed by difficulty setting) <<<<------
    func unsetSelectLocationsOnBoard(locations: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)]) {
        if locations.isEmpty == false {
            for coord in locations {
                if self.sudokuBoard.isOriginBoardCellUsed(coord) {
                    self.setCoordToOriginImage(coord, number: self.sudokuBoard.getNumberFromGameBoard(coord))
                } else {
                    self.setCoordToDefaultImage(coord, number: self.sudokuBoard.getNumberFromGameBoard(coord))
                }
            }
        }
        return
    }
    
    // traverse game board and 'set' any 'select' numbers
    // ---->>>> (will be allowed by difficulty setting) <<<<------
    func setSelectNumbersOnBoard(index: Int) {
        // index will give the 'number' selected from the control panel
        let locations: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] = self.sudokuBoard.getLocationsOfNumberOnBoard(index + 1)
        self.setSelectLocationsOnBoard(locations)
        return
    }

    // traverse game board and 'set' any selected numbers to selected
    // ---->>>> (will be allowed by difficulty setting) <<<<------
    func setSelectLocationsOnBoard(locations: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)]) {
        if locations.isEmpty == false {
            for coord in locations {
                self.setCoordToSelectImage(coord, number: self.sudokuBoard.getNumberFromGameBoard(coord))
            }
        }
        return
    }

    // traverse game board and 'unset' any 'select' numbers
    // ---->>>> (will be allowed by difficulty setting in later version) <<<<------
    func unsetDeleteNumbersOnBoard() {
        let locations: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] = self.displayBoard.getLocationsOfImages(imgStates.Delete.rawValue)
        self.unsetDeleteLocationsOnBoard(locations)
        return
    }
    
    // traverse game board and 'set' any 'select' numbers to selected
    // ---->>>> (will be allowed by difficulty setting) <<<<------
    func unsetDeleteLocationsOnBoard(locations: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)]) {
        if locations.isEmpty == false {
            for coord in locations {
                if self.sudokuBoard.isOriginBoardCellUsed(coord) {
                    self.setCoordToOriginImage(coord, number: self.sudokuBoard.getNumberFromGameBoard(coord))
                } else {
                    self.setCoordToDefaultImage(coord, number: self.sudokuBoard.getNumberFromGameBoard(coord))
                }
            }
        }
        return
    }
    
    // traverse game board and 'set' all numbers to 'delete'
    // ---->>>> (will be allowed by difficulty setting) <<<<------
    func setDeleteLocationsOnBoard(locations: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)]) {
        if locations.isEmpty == false {
            for coord in locations {
                self.setCoordToDeleteImage(coord, number: self.sudokuBoard.getNumberFromGameBoard(coord))
            }
        }
        return
    }
    
    //
    // clear the current image at the coord
    //
    func setCellToBlankImage(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int)) {
        self.displayBoard.gameImages[coord.row][coord.column].unsetImage(coord.cellRow, column: coord.cellColumn)
        return
    }
    
    //
    // set numbers on the 'game' board to default if the user selects the 'number' from the control panel
    //
    func setCoordToDefaultImage(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int), number: Int) {
        self.displayBoard.gameImages[coord.row][coord.column].setImage(coord.cellRow, column: coord.cellColumn, imageToSet: self.imageDefaultLibrary[self.activeImageSet][number - 1], imageState: imgStates.Default.rawValue)
        return
    }

    //
    // set numbers on the 'game' board to highlight if the user selects the number from the control panel
    //
    func setCoordToHighlightImage(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int), number: Int) {
        self.displayBoard.gameImages[coord.row][coord.column].setImage(coord.cellRow, column: coord.cellColumn, imageToSet: self.imageHighlightLibrary[self.activeImageSet][number - 1], imageState: imgStates.Highlighted.rawValue)
        return
    }

    //
    // set numbers on the 'game' board to origin if they are also part of the origin board
    //
    func setCoordToOriginImage(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int), number: Int) {
        self.displayBoard.gameImages[coord.row][coord.column].setImage(coord.cellRow, column: coord.cellColumn, imageToSet: self.imageOriginLibrary[self.activeImageSet][number - 1], imageState: imgStates.Origin.rawValue)
        return
    }
    
    //
    // set numbers on the 'game' board to highlighted if the user selects the 'number' from the control panel
    //
    func setCoordToSelectImage(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int), number: Int) {
        self.displayBoard.gameImages[coord.row][coord.column].setImage(coord.cellRow, column: coord.cellColumn, imageToSet: self.imageSelectLibrary[self.activeImageSet][number - 1], imageState: imgStates.Selected.rawValue)
        return
    }
    
    //
    // set numbers on the 'game' board to highlighted if the user selects the 'number' from the control panel
    //
    func setCoordToDeleteImage(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int), number: Int) {
        self.displayBoard.gameImages[coord.row][coord.column].setImage(coord.cellRow, column: coord.cellColumn, imageToSet: self.imageDeleteLibrary[self.activeImageSet][number - 1], imageState: imgStates.Delete.rawValue)
        return
    }
    
    //
    // detect if the user has selected within a designated image view
    //
    func isTapWithinImage(location: CGPoint, image: UIImageView) -> Bool {
        if (location.x >= image.frame.origin.x) && (location.x <= (image.frame.origin.x + image.frame.width)) {
            if (location.y >= image.frame.origin.y) && (location.y <= (image.frame.origin.y + image.frame.height)) {
                return true
            }
        }
        return false
    }

    //----------------------------------------------------------------------------
    // captures user pressing the 'Settings' button
    //----------------------------------------------------------------------------
    @IBAction func settingButtonPressed(sender: UIButton) {
        // NEEDS WORK HERE TO DISPLAY AND MANAGE THE SETTINGS DIALOG
    }

}