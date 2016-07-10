//
//  ViewController.swift
//  SudokuTest
//
//  Created by Graham Watson on 06/03/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var debug: Int = 1
    var boardDimensions: Int = 3
    var gameDifficulty: Int = 6
    
    //
    // enum for subviews
    //
    enum subViewTags: Int {
        case sudokuBoard = 0
        case controlPanel = 1
        case settingsPanel = 2
    }

    //
    // defaults for positioning UIImageView components
    //
    let kMainViewMargin: CGFloat = 40.0
    let kCellWidthMargin: CGFloat = 9
    let kCellDepthMargin: CGFloat = 7
    
//
//    let originX: CGFloat = 825
//    let originY: CGFloat = 210
//    let frameWidth: CGFloat = 148
//    let frameHeight: CGFloat = 360
//    let cellWidth: CGFloat = 65

    //
    // the board to solve
    //
    var viewSudokuBoard: UIView!
    var sudokuBoard: GameBoard!
    var displayBoard: GameBoardImages!
    // current selected board position (if any, -1 if none)
    var boardPosition: (row: Int, column: Int, cellRow: Int, cellColumn: Int) = (-1, -1, -1, -1)
    // has user started playing?
    var gameBoardInPlay: Bool = false
    // board posn selected (only set if the control panel hasn't been set)
    //var boardSelected: (row: Int, column: Int, cellRow: Int, cellColumn: Int) = (-1, -1, -1, -1)
    
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
    var controlPanelPosition: (row: Int, column: Int) = (-1, -1)

    //
    // settings panel
    //
    var viewSettings: UIView!
    
    //
    // image sets and related vars
    //
    enum imgStates: Int {
        case Default = 0
        case Selected = 1
        case Highlighted = 2
        case Origin = 3
        case Delete = 4
        case Inactive = 5
    }
    enum imageSet: Int {
        case Default = 0
        case Greek = 1
        case Images = 2
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
    // user selects board position
    //
    var userSelectImage: UIImage = UIImage(named:"ImageSpace_default.png")!
    
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
        UIImage(named:"ImageClear_default.png")!
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
        UIImage(named:"ImageClear_default.png")!
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
        UIImage(named:"ImageClear_delete.png")!
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
        UIImage(named:"ImageClear_delete.png")!
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
        UIImage(named:"ImageClear_highlight.png")!
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
        UIImage(named:"ImageClear_highlight.png")!
    ]]
    //
    // inactivee images for when the user has used a number in all cells
    //
    var imageInactiveLibrary: [[UIImage]] = [[
        UIImage(named:"Image001_inactive.png")!,
        UIImage(named:"Image002_inactive.png")!,
        UIImage(named:"Image003_inactive.png")!,
        UIImage(named:"Image004_inactive.png")!,
        UIImage(named:"Image005_inactive.png")!,
        UIImage(named:"Image006_inactive.png")!,
        UIImage(named:"Image007_inactive.png")!,
        UIImage(named:"Image008_inactive.png")!,
        UIImage(named:"Image009_inactive.png")!,
        UIImage(named:"ImageClear_inactive.png")!
    ],[
        UIImage(named:"Alt001_inactive.png")!,
        UIImage(named:"Alt002_inactive.png")!,
        UIImage(named:"Alt003_inactive.png")!,
        UIImage(named:"Alt004_inactive.png")!,
        UIImage(named:"Alt005_inactive.png")!,
        UIImage(named:"Alt006_inactive.png")!,
        UIImage(named:"Alt007_inactive.png")!,
        UIImage(named:"Alt008_inactive.png")!,
        UIImage(named:"Alt009_inactive.png")!,
        UIImage(named:"ImageClear_inactive.png")!
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
        UIImage(named:"ImageClear_origin.png")!
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
        UIImage(named:"ImageClear_origin.png")!
    ]]
    //
    // when user selects from control panel
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
        UIImage(named:"ImageClear_select.png")!
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
        UIImage(named:"ImageClear_select.png")!
    ]]

    //
    // timer display and storage for counter etc
    //
    @IBOutlet weak var gameTimer: UILabel!
    var timer: NSTimer!
    var timerSeconds: Int!
    var countdownSeconds: Int!
    var timerActive: Bool!
    var timerDisplay: Bool!
    
    //
    // sound handling
    //
    var userPlacementSounds: [AVAudioPlayer!] = []
    var userErrorSound: AVAudioPlayer!
    var userRuboutSound: AVAudioPlayer!
    var playSounds: Bool!
    
    //
    // prefs
    //
    var userPrefs, savePrefs: PreferencesHandler!
    
    //----------------------------------------------------------------------------
    // start of the code!!!!
    //----------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.sudokuBoard = GameBoard(size: self.boardDimensions, setDifficulty: self.gameDifficulty)
        self.displayBoard = GameBoardImages(size: self.boardDimensions)
        self.controlPanelImages = CellImages(rows: 5, columns: 2)
        self.userSolution = TrackSolution(row: self.boardDimensions, column: self.boardDimensions, cellRow: self.boardDimensions, cellColumn: self.boardDimensions)
        // use default char set to start with
        self.activeImageSet = imageSet.Greek.rawValue
        // now setup displays
        self.setupSudokuBoardDisplay()
        self.setupControlPanelDisplay()
        // set time to start
        self.initialiseGameTimer()
        // load sounds
        self.initialiseGameSounds()
        // prefs
        self.userPrefs = PreferencesHandler()
        return
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //----------------------------------------------------------------------------
    // load/play sounds
    //----------------------------------------------------------------------------
    func initialiseGameSounds() {
        self.userPlacementSounds.append(self.loadSound("Chalk_001.aiff"))
        self.userPlacementSounds.append(self.loadSound("Chalk_002.aiff"))
        self.userErrorSound = self.loadSound("Mistake_001.aiff")
        self.userRuboutSound = self.loadSound("RubOut_001.aiff")
        self.playSounds = false
        return
    }
    
    func loadSound(soundName: String) -> AVAudioPlayer! {
        var value: AVAudioPlayer!
        do {
            value = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(soundName, ofType:nil)!))
        } catch {
            return nil
        }
        return value
    }
    
    func playErrorSound() {
        if self.userErrorSound == nil || self.playSounds == false {
            return
        }
        self.userErrorSound.play()
        return
    }

    func playPlacementSound() {
        if self.userPlacementSounds.count == 0 || self.playSounds == false {
            return
        }
        let playSound: Int = Int(arc4random_uniform(UInt32(self.userPlacementSounds.count)))
        if self.userPlacementSounds[playSound] == nil {
            return
        }
        self.userPlacementSounds[playSound].play()
        return
    }
    
    func playRuboutSound() {
        if self.userRuboutSound == nil || self.playSounds == false {
            return
        }
        self.userRuboutSound.play()
        return
    }
    
    //----------------------------------------------------------------------------
    // timer display handling
    //----------------------------------------------------------------------------
    func initialiseGameTimer() {
        self.timer = NSTimer()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: #selector(ViewController.updateGameTime), userInfo: nil, repeats: true)
        self.stopGameTimer()
        self.resetGameTimer()
        return
    }
    
    func resetGameTimer() {
        self.timerSeconds = 0
        self.gameTimer.text = ""
        return
    }
    
    func startGameTimer() {
        self.timerActive = true
        self.timerDisplay = true
        return
    }
    
    func stopGameTimer() {
        self.timerActive = false
        self.timerDisplay = false
        return
    }

    func updateGameTime() {
        if self.timerActive == true {
            self.timerSeconds = self.timerSeconds + 1
            if self.timerDisplay == true {
                self.gameTimer.text = String(format: "%02d", self.timerSeconds / 60) + ":" + String(format: "%02d", self.timerSeconds % 60)
            }
        }
        return
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
            if self.debug == 1 {
                print(self.sudokuBoard.dumpSolutionBoard())
            }
            self.sudokuBoard.buildOriginBoard()
            self.sudokuBoard.initialiseGameBoard()
            self.userSolution.clearCoordinates()
            self.updateSudokuBoardDisplay()
            self.controlPanelPosition = (-1, -1)
            self.boardPosition = (-1, -1, -1, -1)
            self.gameBoardInPlay = true
            self.resetGameTimer()
            self.startGameTimer()
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
            let resetAction = UIAlertAction(title: "Restart this puzzle!", style: .Default) { (action:UIAlertAction!) in
                self.resetControlPanelSelection()
                self.sudokuBoard.initialiseGameBoard()
                self.userSolution.clearCoordinates()
                self.updateSudokuBoardDisplay()
                self.controlPanelPosition = (-1, -1)
                self.boardPosition = (-1, -1, -1, -1)
                self.gameBoardInPlay = true
                self.resetGameTimer()
                self.startGameTimer()
            }
            alertController.addAction(resetAction)
            let restartAction = UIAlertAction(title: "New Puzzle!", style: .Default) { (action:UIAlertAction!) in
                self.resetControlPanelSelection()
                self.sudokuBoard.clearBoard()
                self.sudokuBoard.buildSolution()
                if self.debug == 1 {
                    print(self.sudokuBoard.dumpSolutionBoard())
                }
                self.sudokuBoard.buildOriginBoard()
                self.sudokuBoard.initialiseGameBoard()
                self.userSolution.clearCoordinates()
                self.updateSudokuBoardDisplay()
                self.controlPanelPosition = (-1, -1)
                self.boardPosition = (-1, -1, -1, -1)
                self.gameBoardInPlay = true
                self.resetGameTimer()
                self.startGameTimer()
            }
            alertController.addAction(restartAction)
            self.presentViewController(alertController, animated: true, completion:nil)
        }
    }
    
    //
    // clear any selection the user might have left in the control panel
    //
    func resetControlPanelSelection() {
        if self.controlPanelPosition != (-1, -1) {
            let index: Int = (self.controlPanelPosition.row * 2) + self.controlPanelPosition.column
            self.controlPanelImages.setImage(self.controlPanelPosition.row, column: self.controlPanelPosition.column, imageToSet: self.imageOriginLibrary[self.activeImageSet][index], imageState: imgStates.Origin.rawValue)
        }
        return
    }
    
    //
    // redisplay the whole current board
    //
    func updateSudokuBoardDisplay() {
        for y: Int in 0 ..< self.displayBoard.boardRows {
            for x: Int in 0 ..< self.displayBoard.boardColumns {
                for j: Int in 0 ..< self.displayBoard.gameImages[y][x].cellRows {
                    for k: Int in 0 ..< self.displayBoard.gameImages[y][x].cellColumns {
                        self.setCellToBlankImage((y, column: x, cellRow: j, cellColumn: k))
                        let number: Int = self.sudokuBoard.getNumberFromGameBoard((y, column: x, cellRow: j, cellColumn: k))
                        if (number > 0) {
                            self.setCoordToOriginImage((y, column: x, cellRow: j, cellColumn: k), number: number)
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
    func setupControlPanelDisplay() {
        let originX: CGFloat = 825
        let originY: CGFloat = 210
        let frameWidth: CGFloat = 148
        let frameHeight: CGFloat = 360
        self.viewControlPanel = UIView(frame: CGRect(x: originX, y: originY, width: frameWidth, height: frameHeight))
        self.viewControlPanel.tag = subViewTags.controlPanel.rawValue
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
        for row: Int in 0 ..< 5 {
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
        // only worried if a board is in play
        if self.gameBoardInPlay == false {
            return
        }
        // has the user tapped in a control panel icon?
        let posn: (row: Int, column: Int) = self.getPositionOfControlPanelImageTapped(recognizer.locationInView(recognizer.view))
        if posn == (-1, -1) {
            return
        }
        if self.boardPosition.row == -1 {
            self.controlPanelPosition = self.userSelectedControlPanelFirst(posn, previousPosn: self.controlPanelPosition)
        } else {
            self.controlPanelPosition = self.userSelectBoardBeforeControlPanel(posn, previousPosn: self.controlPanelPosition, boardPosn: self.boardPosition)
        }
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
    
    //
    // the user came straight to the control panel and hasn't selected a board position yet
    //
    func userSelectedControlPanelFirst(currentPosn: (row: Int, column: Int), previousPosn: (row: Int, column: Int)) -> (row: Int, column: Int) {
        let index: Int = (currentPosn.row * 2) + currentPosn.column
        var pIndex: Int = -1
        if previousPosn != (-1, -1) {
            pIndex = (previousPosn.row * 2) + previousPosn.column
            self.controlPanelImages.setImage(previousPosn.row, column: previousPosn.column, imageToSet: self.imageOriginLibrary[self.activeImageSet][pIndex], imageState: imgStates.Origin.rawValue)
        }
        switch index {
        case 0..<9:
            // revert any previously selected positions
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
            // if the posn selected is the same as before then bail, we want the user to select a new one.
            if currentPosn == previousPosn {
                return (-1, -1)
            }
            self.controlPanelImages.setImage(currentPosn.row, column: currentPosn.column, imageToSet: self.imageSelectLibrary[self.activeImageSet][index], imageState: imgStates.Selected.rawValue)
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
                    return (-1, -1)
                case 10:
                    break
                case 11:
                    break
                default:
                    break
                }
            }
            self.controlPanelImages.setImage(currentPosn.row, column: currentPosn.column, imageToSet: self.imageDeleteLibrary[self.activeImageSet][index], imageState: imgStates.Delete.rawValue)
            self.setDeleteLocationsOnBoard(self.userSolution.getCoordinatesInSolution())
            break
        default:
            // this should never happen
            break
        }
        return currentPosn
    }
    
    //
    // we have an active board position selected before the user used the control panel
    //
    func userSelectBoardBeforeControlPanel(currentPosn: (row: Int, column: Int), previousPosn: (row: Int, column: Int), boardPosn: (row: Int, column: Int, cellRow: Int, cellColumn: Int)) -> (row: Int, column: Int) {
        let index: Int = (currentPosn.row * 2) + currentPosn.column
        switch index {
        case 0..<9:
            // place the selected number on the board if we can put it there
            if self.sudokuBoard.isNumberValidOnGameBoard(boardPosn, number: index + 1) == false {
                self.playErrorSound()
                return (-1, -1)
            }
            if self.sudokuBoard.isGameBoardCellUsed(boardPosn) == true {
                self.sudokuBoard.clearNumberOnGameBoard(boardPosn)
            }
            if self.sudokuBoard.setNumberOnGameBoard(boardPosn, number: index + 1) {
                self.setCoordToOriginImage(boardPosn, number: index + 1)
                self.userSolution.addCoordinate(boardPosn)
                self.playPlacementSound()
                self.boardPosition = (-1, -1, -1, -1)
            }
            break;
        case 9:
            if self.sudokuBoard.isGameBoardCellUsed(boardPosn) == true {
                self.playRuboutSound()
                self.sudokuBoard.clearNumberOnGameBoard(boardPosn)
                self.setCellToBlankImage(boardPosn)
                self.userSolution.removeCoordinate(boardPosn)
                self.boardPosition = (-1, -1, -1, -1)
            }
            break
        default:
            // this should never happen
            break
        }
        return currentPosn
    }
    
    //----------------------------------------------------------------------------
    // Handle the board display, setup event handler and detect taps in the board
    //----------------------------------------------------------------------------

    //
    // build the initial board display, we only do this once!
    //
    func setupSudokuBoardDisplay() {
        let originX: CGFloat = self.view.bounds.origin.x + self.kMainViewMargin
        let originY: CGFloat = self.kMainViewMargin
        let frameWidth: CGFloat = self.view.bounds.height - (2 * self.kMainViewMargin)
        let frameHeight: CGFloat = self.view.bounds.height - (2 * self.kMainViewMargin)
        self.viewSudokuBoard = UIView(frame: CGRect(x: originX, y: originY, width: frameWidth, height: frameHeight))
        self.viewSudokuBoard.tag = subViewTags.sudokuBoard.rawValue
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
        // we're only interested if the board is in play
        if self.gameBoardInPlay == false {
            return
        }
        // has the user tapped in a cell?
        let posn: (row: Int, column: Int, cellRow: Int, cellColumn: Int) = self.getPositionOfSudokuBoardImageTapped(recognizer.locationInView(recognizer.view))
        if posn.column == -1 {
            return
        }
        // ignore those positions that were those at the start of the user solving the board, then reset the control and board positions
        if self.sudokuBoard.isOriginBoardCellUsed(posn) {
            return
        }
        // if there's no action to process from the control panel, store the board posn, highlight it and leave
        if self.controlPanelPosition.row == -1 {
            self.boardPosition = self.userSelectedBoardFirst(posn, previousPosn: self.boardPosition)
            return
        }
        let index: Int = (self.controlPanelPosition.row * 2) + self.controlPanelPosition.column
        switch index {
        case 0..<9:
            if self.sudokuBoard.isGameBoardCellUsed(posn) {
                return
            }
            if self.sudokuBoard.setNumberOnGameBoard(posn, number: index + 1) {
                self.setCoordToSelectImage(posn, number: index + 1)
                self.userSolution.addCoordinate(posn)
                self.playPlacementSound()
            }
        case 9:
            // when user selects posn on board and it's populated by a user solution, clear it!
            if self.sudokuBoard.isGameBoardCellUsed(posn) == false {
                return
            }
            self.playRuboutSound()
            self.sudokuBoard.clearNumberOnGameBoard(posn)
            self.setCellToBlankImage(posn)
            self.userSolution.removeCoordinate(posn)
            self.boardPosition = (-1, -1, -1, -1)
            break
        default:
            // this should never happen
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
    
    //
    // if the user selects the board first
    //
    func userSelectedBoardFirst(currentPosn: (row: Int, column: Int, cellRow: Int, cellColumn: Int), previousPosn: (row: Int, column: Int, cellRow: Int, cellColumn: Int)) -> (row: Int, column: Int, cellRow: Int, cellColumn: Int) {
        if currentPosn == previousPosn {
            if self.sudokuBoard.isGameBoardCellUsed(currentPosn) == false {
                self.setCellToBlankImage(currentPosn)
            } else {
                self.setCoordToOriginImage(currentPosn, number: self.sudokuBoard.getNumberFromGameBoard(currentPosn))
            }
            return (-1, -1, -1, -1)
        }
        if previousPosn.row != -1 {
            if self.sudokuBoard.isGameBoardCellUsed(previousPosn) == false {
                self.setCellToBlankImage(previousPosn)
            } else {
                self.setCoordToOriginImage(previousPosn, number: self.sudokuBoard.getNumberFromGameBoard(previousPosn))
            }
        }
            if self.sudokuBoard.isGameBoardCellUsed(currentPosn) == false {
            self.setCoordToTouchedImage(currentPosn)
        } else {
            self.setCoordToSelectImage(currentPosn, number: self.sudokuBoard.getNumberFromGameBoard(currentPosn))
        }
        return currentPosn
    }
    
    //----------------------------------------------------------------------------
    // all image setting routines live here!
    //----------------------------------------------------------------------------

    // traverse game board and 'unset' any 'select' numbers
    func unsetDeleteNumbersOnBoard() {
        let locations: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] = self.displayBoard.getLocationsOfImages(imgStates.Delete.rawValue)
        self.unsetDeleteLocationsOnBoard(locations)
        return
    }
    
    // traverse game board and 'set' any 'select' numbers to selected
    func unsetDeleteLocationsOnBoard(locations: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)]) {
        if locations.isEmpty == false {
            for coord in locations {
                self.setCoordToOriginImage(coord, number: self.sudokuBoard.getNumberFromGameBoard(coord))
            }
        }
        return
    }
    
    // traverse game board and 'set' all numbers to 'delete'
    func setDeleteLocationsOnBoard(locations: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)]) {
        if locations.isEmpty == false {
            for coord in locations {
                self.setCoordToDeleteImage(coord, number: self.sudokuBoard.getNumberFromGameBoard(coord))
            }
        }
        return
    }
    
    // traverse game board and 'unset' any 'inactive' numbers
    func unsetInactiveNumbersOnBoard() {
        let locations: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] = self.displayBoard.getLocationsOfImages(imgStates.Inactive.rawValue)
        self.unsetInactiveLocationsOnBoard(locations)
        return
    }
    
    // traverse game board and 'set' any 'inactive' numbers to selected
    func unsetInactiveLocationsOnBoard(locations: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)]) {
        if locations.isEmpty == false {
            for coord in locations {
                self.setCoordToOriginImage(coord, number: self.sudokuBoard.getNumberFromGameBoard(coord))
            }
        }
        return
    }
    
    // traverse game board and 'set' all numbers to 'delete'
    func setInactiveLocationsOnBoard(locations: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)]) {
        if locations.isEmpty == false {
            for coord in locations {
                self.setCoordToInactiveImage(coord, number: self.sudokuBoard.getNumberFromGameBoard(coord))
            }
        }
        return
    }
    
    // traverse game board and 'unset' any 'select' numbers
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
                self.setCoordToOriginImage(coord, number: self.sudokuBoard.getNumberFromGameBoard(coord))
            }
        }
        return
    }
    
    // traverse game board and 'set' any 'select' numbers
    func setSelectNumbersOnBoard(index: Int) {
        // index will give the 'number' selected from the control panel
        let locations: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] = self.sudokuBoard.getLocationsOfNumberOnBoard(index + 1)
        self.setSelectLocationsOnBoard(locations)
        return
    }

    // traverse game board and 'set' any selected numbers to selected
    func setSelectLocationsOnBoard(locations: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)]) {
        if locations.isEmpty == false {
            for coord in locations {
                self.setCoordToSelectImage(coord, number: self.sudokuBoard.getNumberFromGameBoard(coord))
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
    // set space on board to cell having been 'touched', we use this when the user selectes the board cell first and not the control panel
    //
    func setCoordToTouchedImage(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int)) {
        self.displayBoard.gameImages[coord.row][coord.column].setImage(coord.cellRow, column: coord.cellColumn, imageToSet: self.userSelectImage, imageState: imgStates.Default.rawValue)
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
    // set numbers on the 'game' board to inactive when all of that number has been used
    //
    func setCoordToInactiveImage(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int), number: Int) {
        self.displayBoard.gameImages[coord.row][coord.column].setImage(coord.cellRow, column: coord.cellColumn, imageToSet: self.imageInactiveLibrary[self.activeImageSet][number - 1], imageState: imgStates.Inactive.rawValue)
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
        // first save the current preferences
        self.savePrefs = self.userPrefs.copy() as! PreferencesHandler
        let pViewController: Preferences = Preferences()
        pViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        pViewController.delegate = self.userPrefs
        self.presentViewController(pViewController, animated: true, completion: nil)
        return
    }

}