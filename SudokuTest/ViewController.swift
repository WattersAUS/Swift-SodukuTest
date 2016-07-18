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
    var gameDifficulty: Int = gameDiff.Easy.rawValue
    
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
    // the board to solve
    //
    var viewSudokuBoard: UIView!
    var sudokuBoard: GameBoard!
    var displayBoard: GameBoardImages!
    // current selected board position (if any, -1 if none)
    var boardPosition: (row: Int, column: Int, cellRow: Int, cellColumn: Int) = (-1, -1, -1, -1)
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
    var controlPanelPosition: (row: Int, column: Int) = (-1, -1)

    //
    // settings panel
    //
    var viewSettings: UIView!

    //
    // images that will be swapped on starting/reseting board
    //
    var startImage: UIImage = UIImage(named:"ImageStart.png")!
    var resetImage: UIImage = UIImage(named:"ImageReset.png")!
    //
    // user selects board position
    //
    var userSelectImage: UIImage = UIImage(named:"ImageSpace_default.png")!
    
    //
    // app settings dialog
    //
    var preferencesImage: UIImage = UIImage(named:"ImagePreferences.png")!
    
    //
    // image library referenced [state][image set][number]
    //
    // State:
    //
    // 0 = Origin
    //      used as the default display image
    // 1 = select
    //      when the user selects via the control panel
    // 2 = delete
    //      users chooses the 'bin' to delete so we highlight the images using this set
    // 3 = inactive
    //      if the user has completed adding the 'number' to all nine cells
    // 4 = highlight
    //      used in conjunction with inactive. for a moment highlight the images
    //
    // Image Set:
    //
    // 0 = Numbers
    // 1 = Greek
    // 2 = Alpha (these are inprogress)
    //
    var imageLibrary: [[[UIImage]]] = [
        [[
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
        ],[
            UIImage(named:"Alpha001_origin.png")!,
            UIImage(named:"Alpha002_origin.png")!,
            UIImage(named:"Alpha003_origin.png")!,
            UIImage(named:"Alpha004_origin.png")!,
            UIImage(named:"Alpha005_origin.png")!,
            UIImage(named:"Alpha006_origin.png")!,
            UIImage(named:"Alpha007_origin.png")!,
            UIImage(named:"Alpha008_origin.png")!,
            UIImage(named:"Alpha009_origin.png")!,
            UIImage(named:"ImageClear_origin.png")!
        ]],
        [[
            UIImage(named:"Image001_select.png")!,
            UIImage(named:"Image002_select.png")!,
            UIImage(named:"Image003_select.png")!,
            UIImage(named:"Image004_select.png")!,
            UIImage(named:"Image005_select.png")!,
            UIImage(named:"Image006_select.png")!,
            UIImage(named:"Image007_select.png")!,
            UIImage(named:"Image008_select.png")!,
            UIImage(named:"Image009_select.png")!,
            UIImage(named:"ImageClear_origin.png")!
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
            UIImage(named:"ImageClear_origin.png")!
        ],[
            UIImage(named:"Alpha001_select.png")!,
            UIImage(named:"Alpha002_select.png")!,
            UIImage(named:"Alpha003_select.png")!,
            UIImage(named:"Alpha004_select.png")!,
            UIImage(named:"Alpha005_select.png")!,
            UIImage(named:"Alpha006_select.png")!,
            UIImage(named:"Alpha007_select.png")!,
            UIImage(named:"Alpha008_select.png")!,
            UIImage(named:"Alpha009_select.png")!,
            UIImage(named:"ImageClear_origin.png")!
        ]],
        [[
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
        ],[
            UIImage(named:"Alpha001_delete.png")!,
            UIImage(named:"Alpha002_delete.png")!,
            UIImage(named:"Alpha003_delete.png")!,
            UIImage(named:"Alpha004_delete.png")!,
            UIImage(named:"Alpha005_delete.png")!,
            UIImage(named:"Alpha006_delete.png")!,
            UIImage(named:"Alpha007_delete.png")!,
            UIImage(named:"Alpha008_delete.png")!,
            UIImage(named:"Alpha009_delete.png")!,
            UIImage(named:"ImageClear_delete.png")!
        ]],
        [[
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
        ],[
            UIImage(named:"Alpha001_inactive.png")!,
            UIImage(named:"Alpha002_inactive.png")!,
            UIImage(named:"Alpha003_inactive.png")!,
            UIImage(named:"Alpha004_inactive.png")!,
            UIImage(named:"Alpha005_inactive.png")!,
            UIImage(named:"Alpha006_inactive.png")!,
            UIImage(named:"Alpha007_inactive.png")!,
            UIImage(named:"Alpha008_inactive.png")!,
            UIImage(named:"Alpha009_inactive.png")!,
            UIImage(named:"ImageClear_inactive.png")!
        ]],
        [[
            UIImage(named:"Image001_highlight.png")!,
            UIImage(named:"Image002_highlight.png")!,
            UIImage(named:"Image003_highlight.png")!,
            UIImage(named:"Image004_highlight.png")!,
            UIImage(named:"Image005_highlight.png")!,
            UIImage(named:"Image006_highlight.png")!,
            UIImage(named:"Image007_highlight.png")!,
            UIImage(named:"Image008_highlight.png")!,
            UIImage(named:"Image009_highlight.png")!,
            UIImage(named:"ImageClear_delete.png")!
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
            UIImage(named:"ImageClear_delete.png")!
        ],[
            UIImage(named:"Alpha001_highlight.png")!,
            UIImage(named:"Alpha002_highlight.png")!,
            UIImage(named:"Alpha003_highlight.png")!,
            UIImage(named:"Alpha004_highlight.png")!,
            UIImage(named:"Alpha005_highlight.png")!,
            UIImage(named:"Alpha006_highlight.png")!,
            UIImage(named:"Alpha007_highlight.png")!,
            UIImage(named:"Alpha008_highlight.png")!,
            UIImage(named:"Alpha009_highlight.png")!,
            UIImage(named:"ImageClear_delete.png")!
        ]]
    ]

    //
    // timer display and storage for counter etc
    //
    @IBOutlet weak var gameTimer: UILabel!
    var timer: NSTimer!
    var timerSeconds: Int!
    var totalSeconds: Int!
    var countdownSeconds: Int!
    var timerActive: Bool!
    var timerDisplay: Bool!
    
    
    //
    // sound handling
    //
    var userPlacementSounds: [AVAudioPlayer!] = []
    var userErrorSound: AVAudioPlayer!
    var userRuboutSound: AVAudioPlayer!
    var userVictorySound: AVAudioPlayer!
    
    //
    // prefs
    //
    var userPrefs: PreferencesHandler!
    
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
        // prefs (save copy of prefs to use later, in case we need to refresh the screen etc)
        self.userPrefs = PreferencesHandler(charSet: imageSet.Default.rawValue, difficulty: gameDiff.Easy.rawValue, mode: gameMode.Normal.rawValue, sound: true, level: 0, hints: true, highlight: true, redrawFunctions: [])
        // now setup displays
        self.setupSudokuBoardDisplay()
        self.setupControlPanelDisplay()
        // set time to start
        self.initialiseGameTimer()
        //** NEEDS TO BE LOADED FROM CORE DATA**//
        self.totalSeconds = 0
        // load sounds
        self.initialiseGameSounds()
        // can only add the function call backs here for redraws used within pref panel
        self.userPrefs.drawFunctions = [self.updateControlPanelDisplay, self.updateSudokuBoardDisplay]
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
        self.userVictorySound = self.loadSound("Triumph_001.aiff")
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
        if self.userErrorSound == nil || self.userPrefs.soundOn == false {
            return
        }
        self.userErrorSound.play()
        return
    }

    func playPlacementSound() {
        if self.userPlacementSounds.count == 0 || self.userPrefs.soundOn == false {
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
        if self.userRuboutSound == nil || self.userPrefs.soundOn == false {
            return
        }
        self.userRuboutSound.play()
        return
    }
    
    func playVictorySound() {
        if self.userVictorySound == nil || self.userPrefs.soundOn == false {
            return
        }
        self.userVictorySound.play()
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
            self.totalSeconds = self.totalSeconds + 1
            if self.timerDisplay == true {
                self.timerSeconds = self.timerSeconds + 1
                self.gameTimer.text = String(format: "%02d", self.timerSeconds / 60) + ":" + String(format: "%02d", self.timerSeconds % 60)
            }
        }
        return
    }
    
    func addPenaltyToGameTime(timePenalty: Int) {
        self.totalSeconds = self.totalSeconds + timePenalty
        self.timerSeconds = self.timerSeconds + timePenalty
        return
    }
    
    //----------------------------------------------------------------------------
    // user presses the 'Start' or 'Reset' button
    //----------------------------------------------------------------------------
    @IBAction func resetButtonPressed(sender: UIButton) {
        //
        // if we have 'Start' button, build the board
        //
        if UIImagePNGRepresentation((sender.imageView?.image)!)!.isEqual(UIImagePNGRepresentation(self.startImage)) == true {
            sender.setImage(self.resetImage, forState: UIControlState.Normal)
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
                self.displayBoard.setImageStates(imgStates.Origin.rawValue)
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
                self.sudokuBoard.setGameDifficulty(self.userPrefs.difficultySet)
                self.sudokuBoard.buildSolution()
                if self.debug == 1 {
                    print(self.sudokuBoard.dumpSolutionBoard())
                }
                self.sudokuBoard.buildOriginBoard()
                self.sudokuBoard.initialiseGameBoard()
                self.userSolution.clearCoordinates()
                self.displayBoard.setImageStates(imgStates.Origin.rawValue)
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
        for location: (cellRow:Int, cellColumn: Int) in self.controlPanelImages.getLocationsOfCellsStateNotEqualTo(imgStates.Origin.rawValue) {
            let index: Int = (location.cellRow * 2) + location.cellColumn
            self.controlPanelImages.setImage(location.cellRow, column: location.cellColumn, imageToSet: self.imageLibrary[imgStates.Origin.rawValue][self.userPrefs.characterSetInUse][index], imageState: imgStates.Origin.rawValue)
        }
        return
    }
    
    //
    // redisplay the control panel (needed if the user changes the char set in the pref panel)
    //
    func updateControlPanelDisplay() {
        for y: Int in 0 ..< self.controlPanelImages.cellRows {
            for x: Int in 0 ..< self.controlPanelImages.cellColumns {
                self.setControlPanelToCurrentImageValue((y, column: x))
            }
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
                        self.redrawCurrentCoordImage((y, column: x, cellRow: j, cellColumn: k))
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
                self.controlPanelImages.cellContents[row][column].imageView.image = self.imageLibrary[imgStates.Origin.rawValue][self.userPrefs.characterSetInUse][i]
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
        let currentState: Int = self.controlPanelImages.getImageState(currentPosn.row, column: currentPosn.column)
        var pIndex: Int = -1
        if previousPosn.row != -1 {
            pIndex = (previousPosn.row * 2) + previousPosn.column
        }
        // has the user selected the same control panel posn in succession
        if index == pIndex {
            switch index {
                case 0..<9:
                    if currentState == imgStates.Selected.rawValue {
                        if self.sudokuBoard.isNumberFullyUsedOnGameBoard(index + 1) == true {
                            self.setControlPanelToInactiveImageValue((index / 2, column: index % 2))
                        } else {
                            self.setControlPanelToOriginImageValue((index / 2, column: index % 2))
                        }
                        self.unsetSelectNumbersOnBoard()
                        return (-1, -1)
                    }
                    self.setControlPanelToSelectedImageValue((index / 2, column: index % 2))
                    self.setSelectNumbersOnBoard(index)
                    break
                case 9:
                    if currentState == imgStates.Delete.rawValue {
                        self.setControlPanelToOriginImageValue((index / 2, column: index % 2))
                        self.unsetDeleteNumbersOnBoard()
                        return(-1, -1)
                    } else {
                        self.setControlPanelToDeleteImageValue((index / 2, column: index % 2))
                        self.setDeleteLocationsOnBoard(self.userSolution.getCoordinatesInSolution())
                    }
                    break
                default:
                    break
            }
            return(currentPosn)
        }
        // cleanup from previous selected ctrl panel posn
        switch pIndex {
            case 0..<9:
                if self.sudokuBoard.isNumberFullyUsedOnGameBoard(pIndex + 1) == true {
                    self.setControlPanelToInactiveImageValue((pIndex / 2, column: pIndex % 2))
                } else {
                    self.setControlPanelToOriginImageValue((pIndex / 2, column: pIndex % 2))
                }
                self.unsetSelectNumbersOnBoard()
                break
            case 9:
                self.unsetDeleteNumbersOnBoard()
                break
            default:
                break
        }
        // process the current posn
        switch index {
        case 0..<9:
            self.setControlPanelToSelectedImageValue((index / 2, column: index % 2))
            self.setSelectNumbersOnBoard(index)
            break;
        case 9:
            self.setControlPanelToDeleteImageValue((index / 2, column: index % 2))
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
                if self.sudokuBoard.isNumberFullyUsedOnGameBoard(index + 1) == true {
                    self.setControlPanelToInactiveImageValue((index / 2, column: index % 2))
                    if self.sudokuBoard.isGameCompleted() {
                        // AND OTHER STUFF NEEDS TO HAPPEN OFC!!!!!
                        self.stopGameTimer()
                        self.playVictorySound()
                    }
                    return (-1, -1)
                }
            }
            break;
        case 9:
            let number: Int = self.sudokuBoard.getNumberFromGameBoard(boardPosn)
            if number > 0 {
                self.playRuboutSound()
                self.sudokuBoard.clearNumberOnGameBoard(boardPosn)
                self.setCellToBlankImage(boardPosn)
                self.userSolution.removeCoordinate(boardPosn)
                self.boardPosition = (-1, -1, -1, -1)
                // may need to reactivate 'inactive' control panel posn
                self.resetInactiveNumberOnBoard(number)
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
        let number: Int = self.sudokuBoard.getNumberFromGameBoard(posn)
        switch index {
        case 0..<9:
            if self.sudokuBoard.isGameBoardCellUsed(posn) {
                if index != (number - 1) {
                    return
                }
                self.playRuboutSound()
                self.sudokuBoard.clearNumberOnGameBoard(posn)
                self.setCellToBlankImage(posn)
                self.userSolution.removeCoordinate(posn)
                self.boardPosition = (-1, -1, -1, -1)
                return
            }
            if self.sudokuBoard.setNumberOnGameBoard(posn, number: index + 1) {
                self.userSolution.addCoordinate(posn)
                // do we need to make number 'inactive'?
                if self.sudokuBoard.isNumberFullyUsedOnGameBoard(index + 1) == false {
                    self.setCoordToSelectImage(posn, number: index + 1)
                    self.playPlacementSound()
                } else {
                    self.setCoordToOriginImage(posn, number: index + 1)
                    self.setControlPanelToInactiveImageValue((index / 2, column: index % 2))
                    self.unsetSelectNumbersOnBoard()
                    self.controlPanelPosition = (-1, -1)
                    self.playPlacementSound()
                    // have we completed the game
                    if self.sudokuBoard.isGameCompleted() {
                        // AND OTHER STUFF NEEDS TO HAPPEN OFC!!!!!
                        self.stopGameTimer()
                        self.playVictorySound()
                    }
                }
            }
        case 9:
            if number == 0 {
                return
            }
            // when user selects posn on board and it's populated by a user solution, clear it!
            self.playRuboutSound()
            self.sudokuBoard.clearNumberOnGameBoard(posn)
            self.setCellToBlankImage(posn)
            self.userSolution.removeCoordinate(posn)
            self.boardPosition = (-1, -1, -1, -1)
            // may need to reactivate 'inactive' control panel posn
            self.resetInactiveNumberOnBoard(number)
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
        // if we've previously selected the same cell, if it was blank then remove the highlight otherwise revert to the original state
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
    // check if the user has complete the game!
    //----------------------------------------------------------------------------
    
    func isTheGameCompleted() -> Bool {
        
        return true
    }
    
    //----------------------------------------------------------------------------
    // routines to make numbers inactive/active if all are completed on board
    //----------------------------------------------------------------------------
    
    func resetInactiveNumberOnBoard(number: Int) {
        let index: Int = number - 1
        self.setControlPanelToOriginImageValue((index / 2, column: index % 2))
        return
    }
    
    //----------------------------------------------------------------------------
    // all image setting routines live here!
    //----------------------------------------------------------------------------

    func unsetDeleteNumbersOnBoard() {
        let locations: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] = self.displayBoard.getLocationsOfImages(imgStates.Delete.rawValue)
        self.unsetDeleteLocationsOnBoard(locations)
        return
    }
    
    func unsetDeleteLocationsOnBoard(locations: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)]) {
        if locations.isEmpty == false {
            for coord in locations {
                self.setCoordToOriginImage(coord, number: self.sudokuBoard.getNumberFromGameBoard(coord))
            }
        }
        return
    }
    
    func setDeleteLocationsOnBoard(locations: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)]) {
        if locations.isEmpty == false {
            for coord in locations {
                self.setCoordToDeleteImage(coord, number: self.sudokuBoard.getNumberFromGameBoard(coord))
            }
        }
        return
    }
    
    func unsetSelectNumbersOnBoard() {
        let locations: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] = self.displayBoard.getLocationsOfImages(imgStates.Selected.rawValue)
        self.unsetSelectLocationsOnBoard(locations)
        return
    }

    func unsetSelectLocationsOnBoard(locations: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)]) {
        if locations.isEmpty == true {
            return
        }
        for coord in locations {
            self.setCoordToOriginImage(coord, number: self.sudokuBoard.getNumberFromGameBoard(coord))
        }
        return
    }
    
    func setSelectNumbersOnBoard(index: Int) {
        // index will give the 'number' selected from the control panel
        let locations: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] = self.sudokuBoard.getLocationsOfNumberOnGameBoard(index + 1)
        self.setSelectLocationsOnBoard(locations)
        return
    }

    func setSelectLocationsOnBoard(locations: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)]) {
        if locations.isEmpty == true {
            return
        }
        for coord in locations {
            self.setCoordToSelectImage(coord, number: self.sudokuBoard.getNumberFromGameBoard(coord))
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
        self.displayBoard.gameImages[coord.row][coord.column].setImage(coord.cellRow, column: coord.cellColumn, imageToSet: self.userSelectImage, imageState: imgStates.Origin.rawValue)
        return
    }
    
    //
    // set numbers on the 'game' board to inactive when all of that number has been used
    //
    func setCoordToInactiveImage(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int), number: Int) {
        self.displayBoard.gameImages[coord.row][coord.column].setImage(coord.cellRow, column: coord.cellColumn, imageToSet: self.imageLibrary[imgStates.Inactive.rawValue][self.userPrefs.characterSetInUse][number - 1], imageState: imgStates.Inactive.rawValue)
        return
    }
    
    //
    // set numbers on the 'game' board to origin if they are also part of the origin board
    //
    func setCoordToOriginImage(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int), number: Int) {
        self.displayBoard.gameImages[coord.row][coord.column].setImage(coord.cellRow, column: coord.cellColumn, imageToSet: self.imageLibrary[imgStates.Origin.rawValue][self.userPrefs.characterSetInUse][number - 1], imageState: imgStates.Origin.rawValue)
        return
    }
    
    //
    // set numbers on the 'game' board to highlighted if the user selects the 'number' from the control panel
    //
    func setCoordToSelectImage(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int), number: Int) {
        self.displayBoard.gameImages[coord.row][coord.column].setImage(coord.cellRow, column: coord.cellColumn, imageToSet: self.imageLibrary[imgStates.Selected.rawValue][self.userPrefs.characterSetInUse][number - 1], imageState: imgStates.Selected.rawValue)
        return
    }
    
    //
    // set numbers on the 'game' board to highlighted if the user selects the 'number' from the control panel
    //
    func setCoordToDeleteImage(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int), number: Int) {
        self.displayBoard.gameImages[coord.row][coord.column].setImage(coord.cellRow, column: coord.cellColumn, imageToSet: self.imageLibrary[imgStates.Delete.rawValue][self.userPrefs.characterSetInUse][number - 1], imageState: imgStates.Delete.rawValue)
        return
    }
    
    //
    // set numbers on the 'game' board to highlighted if the user selects the 'number' from the control panel
    //
    func redrawCurrentCoordImage(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int)) {
        let number: Int = self.sudokuBoard.getNumberFromGameBoard(coord)
        if number == 0 {
            self.setCellToBlankImage(coord)
        } else {
            var imgState: Int = self.displayBoard.gameImages[coord.row][coord.column].getImageState(coord.cellRow, column: coord.cellColumn)
            if imgState == -1 {
                imgState = imgStates.Origin.rawValue
            }
            self.displayBoard.gameImages[coord.row][coord.column].setImage(coord.cellRow, column: coord.cellColumn, imageToSet: self.imageLibrary[imgState][self.userPrefs.characterSetInUse][number - 1], imageState: imgState)
        }
        return
    }

    //
    // set numbers on the control panel to whatever 'state' is stored (used when we swap char sets)
    //
    func setControlPanelToCurrentImageValue(coord: (row: Int, column: Int)) {
        let imgState: Int = self.controlPanelImages.getImageState(coord.row, column: coord.column)
        self.controlPanelImages.setImage(coord.row, column: coord.column, imageToSet: self.imageLibrary[imgState][self.userPrefs.characterSetInUse][(coord.row * 2) + coord.column], imageState: imgState)
        return
    }
    
    //
    // set numbers on the control panel to 'inactive' 'state'
    //
    func setControlPanelToInactiveImageValue(coord: (row: Int, column: Int)) {
        self.controlPanelImages.setImage(coord.row, column: coord.column, imageToSet: self.imageLibrary[imgStates.Inactive.rawValue][self.userPrefs.characterSetInUse][(coord.row * 2) + coord.column], imageState: imgStates.Inactive.rawValue)
        return
    }

    //
    // set numbers on the control panel to 'origin' 'state'
    //
    func setControlPanelToOriginImageValue(coord: (row: Int, column: Int)) {
        self.controlPanelImages.setImage(coord.row, column: coord.column, imageToSet: self.imageLibrary[imgStates.Origin.rawValue][self.userPrefs.characterSetInUse][(coord.row * 2) + coord.column], imageState: imgStates.Origin.rawValue)
        return
    }
    
    //
    // set numbers on the control panel to 'selected' 'state'
    //
    func setControlPanelToSelectedImageValue(coord: (row: Int, column: Int)) {
        self.controlPanelImages.setImage(coord.row, column: coord.column, imageToSet: self.imageLibrary[imgStates.Selected.rawValue][self.userPrefs.characterSetInUse][(coord.row * 2) + coord.column], imageState: imgStates.Selected.rawValue)
        return
    }
    
    //
    // set numbers on the control panel to 'selected' 'state'
    //
    func setControlPanelToDeleteImageValue(coord: (row: Int, column: Int)) {
        self.controlPanelImages.setImage(coord.row, column: coord.column, imageToSet: self.imageLibrary[imgStates.Delete.rawValue][self.userPrefs.characterSetInUse][(coord.row * 2) + coord.column], imageState: imgStates.Delete.rawValue)
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
    // captures user pressing the 'Hints' button / if it is active
    //----------------------------------------------------------------------------
    @IBAction func hintsButtonPressed(sender: UIButton) {
        if self.userPrefs.hintsOn == false {
            self.playErrorSound()
        } else {
            let alertController = UIAlertController(title: "Hint Options", message: "So you want to use a hint, this will add some time to your game clock. Ok?", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action:UIAlertAction!) in //action -> Void in
                // nothing to do here, user bailed on using a hint
            }
            alertController.addAction(cancelAction)
            let useHintAction = UIAlertAction(title: "Give me a hint!", style: .Default) { (action:UIAlertAction!) in
                // code to add a hint result here
                self.addPenaltyToGameTime(20)
            }
            alertController.addAction(useHintAction)
            self.presentViewController(alertController, animated: true, completion:nil)
        }
        return
    }
    
    func addHintToSolution() {
        return
    }
    
    //----------------------------------------------------------------------------
    // captures user pressing the 'Settings' button
    //----------------------------------------------------------------------------
    @IBAction func settingButtonPressed(sender: UIButton) {
        // first save the current preferences
        let pViewController: Preferences = Preferences()
        pViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        pViewController.delegate = self.userPrefs
        self.presentViewController(pViewController, animated: true, completion: nil)
        return
    }

}