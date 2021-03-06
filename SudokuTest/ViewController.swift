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
    //var gameDifficulty: Int = gameDiff.Medium.rawValue
    
    //
    // enum for subviews (internal to this ViewController only)
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
    // 0 = origin
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
    // 2 = Alpha
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
    
    //
    // set in the Hint option dialog, allow the user a one off cell uncover
    //
    var giveHint: Bool!
    
    //
    // timer display and storage for counter etc
    //
    @IBOutlet weak var gameTimer: UILabel!
    var timer: NSTimer!
    var timerActive: Bool!
    var timerDisplay: Bool!

    //
    // time added to timer on using hint during game
    //
    //var penaltyStart: Int = 10
    
    //
    // state of game (so we can save if we get told the app is to close)
    //
    var userGame: GameStateHandler!
    
    //----------------------------------------------------------------------------
    // start of the code!!!!
    //----------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.userPrefs = PreferencesHandler(redrawFunctions: [])
        
        //** NEEDS TO BE LOADED FROM SAVE GAME**//
        self.userGame = GameStateHandler()
        //**

        self.sudokuBoard = GameBoard(size: self.boardDimensions, setDifficulty: self.userPrefs.difficultySet)
        self.displayBoard = GameBoardImages(size: self.boardDimensions)
        self.controlPanelImages = CellImages(rows: 5, columns: 2)
        self.userSolution = TrackSolution(row: self.boardDimensions, column: self.boardDimensions, cellRow: self.boardDimensions, cellColumn: self.boardDimensions)
        // now setup displays
        self.setupSudokuBoardDisplay()
        self.setupControlPanelDisplay()
        // setup the timer but dont let game time start yet
        self.initialiseGameTimer()
        self.stopGameTimer()
        // load sounds
        self.initialiseGameSounds()
        // set Hint override to off
        self.giveHint = false
        // add the function call backs for redraws used exiting pref panel
        self.userPrefs.drawFunctions = [self.updateControlPanelDisplay, self.updateSudokuBoardDisplay]
        // register routine for app transiting to b/g
        self.setupApplicationNotifications()
        return
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //----------------------------------------------------------------------------
    // app transition events
    //----------------------------------------------------------------------------
    func setupApplicationNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(applicationMovingToBackground), name: UIApplicationWillResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(applicationMovingToForeground), name: UIApplicationDidBecomeActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(applicationToClose), name: UIApplicationWillTerminateNotification, object: nil)
        return
    }
    
    func applicationToClose() {
        self.userGame.setGameCells(self.getCurrentGameBoardState())
        self.userGame.saveGame()
        return
    }
    
    func applicationMovingToForeground() {
        if self.userGame.getGameInPlay() {
            self.startGameTimer()
        }
        return
    }

    func applicationMovingToBackground() {
        self.stopGameTimer()
        self.userGame.setGameCells(self.getCurrentGameBoardState())
        self.userGame.saveGame()
        return
    }

    //----------------------------------------------------------------------------
    // load/play sounds
    //----------------------------------------------------------------------------
    func initialiseGameSounds() {
        self.userPlacementSounds.append(self.loadSound("Write_001.aiff"))
        self.userPlacementSounds.append(self.loadSound("Write_002.aiff"))
        self.userPlacementSounds.append(self.loadSound("Write_003.aiff"))
        self.userPlacementSounds.append(self.loadSound("Write_004.aiff"))
        self.userPlacementSounds.append(self.loadSound("Write_005.aiff"))
        self.userPlacementSounds.append(self.loadSound("Write_006.aiff"))
        self.userPlacementSounds.append(self.loadSound("Write_007.aiff"))
        self.userPlacementSounds.append(self.loadSound("Write_008.aiff"))
        self.userPlacementSounds.append(self.loadSound("Write_009.aiff"))
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
        guard self.userErrorSound != nil && self.userPrefs.soundOn == true else {
            return
        }
        self.userErrorSound.play()
        return
    }

    func playPlacementSound(number: Int) {
        guard (self.userPlacementSounds.count) > 0 && (self.userPrefs.soundOn == true) && (1..<(self.userPlacementSounds.count + 1)) ~= number else {
            return
        }
        if self.userPlacementSounds[number - 1] == nil {
            return
        }
        self.userPlacementSounds[number - 1].play()
        return
    }
    
    func playRuboutSound() {
        guard self.userRuboutSound != nil && self.userPrefs.soundOn == true else {
            return
        }
        self.userRuboutSound.play()
        return
    }
    
    func playVictorySound() {
        guard self.userVictorySound != nil && self.userPrefs.soundOn == true else {
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
        return
    }
    
    func resetGameTimer() {
        self.userGame.resetCurrentGameTimePlayed()
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
            self.userGame.incrementTotalGameTimePlayed(1)
            if self.timerDisplay == true {
                let time: Int = self.userGame.incrementCurrentGameTimePlayed(1)
                self.gameTimer.text = String(format: "%02d", time / 60) + ":" + String(format: "%02d", time % 60)
            }
        }
        return
    }
    
    //----------------------------------------------------------------------------
    // penalty timer additions
    //----------------------------------------------------------------------------
    func addPenaltyToGameTime() {
        self.userGame.incrementTotalGameTimePlayed(self.userGame.getGamePenaltyTime())
        self.userGame.incrementCurrentGameTimePlayed(self.userGame.getGamePenaltyTime())
        self.userGame.incrementGamePenaltyTime(self.userGame.incrementGamePenaltyIncrementTime(1))
        return
    }
    
    //----------------------------------------------------------------------------
    // load/save game state
    //----------------------------------------------------------------------------
    
    // TO GO HERE!!!!!!!!!
    
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
            self.finalPreparationForGameStart()
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
                self.finalPreparationForGameStart()
            }
            alertController.addAction(resetAction)
            let restartAction = UIAlertAction(title: "New Puzzle!", style: .Default) { (action:UIAlertAction!) in
                self.resetControlPanelSelection()
                self.sudokuBoard.clearBoard()
                self.sudokuBoard.setBoardDifficulty(self.userPrefs.difficultySet)
                self.sudokuBoard.buildSolution()
                if self.debug == 1 {
                    print(self.sudokuBoard.dumpSolutionBoard())
                }
                self.sudokuBoard.buildOriginBoard()
                self.finalPreparationForGameStart()
            }
            alertController.addAction(restartAction)
            self.presentViewController(alertController, animated: true, completion:nil)
        }
    }
    
    //
    // standard prep and setup for final game start/re-start
    //
    func finalPreparationForGameStart() {
        self.sudokuBoard.initialiseGameBoard()
        self.userSolution.clearCoordinates()
        self.displayBoard.setImageStates(imgStates.Origin.rawValue)
        self.updateSudokuBoardDisplay()
        self.controlPanelPosition = (-1, -1)
        self.boardPosition = (-1, -1, -1, -1)
        self.resetGameTimer()
        self.startGameTimer()
        self.userGame.setGameInPlay(true)
        self.userGame.setGamePenaltyTime(self.setInitialPenalty())
        self.userGame.resetGamePenaltyIncrementTime(self.setInitialPenaltyIncrement())
        self.userGame.resetGamePlayerMovesMade()
        self.userGame.resetGamePlayerMovesDeleted()
        self.userGame.incrementStartedGames()
        self.userGame.setGameCells(self.getCurrentGameBoardState())
        self.userGame.setOriginCells(self.getCurrentOriginBoardState())
        self.userGame.setSolutionCells(self.getCurrentSolutionBoardState())
        return
    }

    func setInitialPenalty() -> Int {
        switch self.userPrefs.difficultySet {
        case gameDiff.Easy.rawValue:
            return initialHintPenalty.Easy.rawValue
        case gameDiff.Medium.rawValue:
            return initialHintPenalty.Medium.rawValue
        case gameDiff.Hard.rawValue:
            return initialHintPenalty.Hard.rawValue
        default:
            break
        }
        return initialHintPenalty.Medium.rawValue
    }
    
    func setInitialPenaltyIncrement() -> Int {
        switch self.userPrefs.difficultySet {
        case gameDiff.Easy.rawValue:
            return initialPenaltyIncrement.Easy.rawValue
        case gameDiff.Medium.rawValue:
            return initialPenaltyIncrement.Medium.rawValue
        case gameDiff.Hard.rawValue:
            return initialPenaltyIncrement.Hard.rawValue
        default:
            break
        }
        return initialPenaltyIncrement.Medium.rawValue
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
        if self.userGame.getGameInPlay() == false {
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
                self.setControlPanelToOriginImageValue((pIndex / 2, column: pIndex % 2))
                self.unsetDeleteNumbersOnBoard()
                break
            default:
                // if we have a highlighted number (prob) from a hint, reset it!
                self.unsetSelectNumbersOnBoard()
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
                self.sudokuBoard.clearLocationOnGameBoard(boardPosn)
            }
            if self.sudokuBoard.setNumberOnGameBoard(boardPosn, number: index + 1) == false {
                self.playErrorSound()
            } else {
                self.setCoordToOriginImage(boardPosn, number: index + 1)
                self.userSolution.addCoordinate(boardPosn)
                self.userGame.incrementGamePlayerMovesMade()
                self.playPlacementSound(index + 1)
                self.boardPosition = (-1, -1, -1, -1)
                if self.sudokuBoard.isNumberFullyUsedOnGameBoard(index + 1) == true {
                    self.setControlPanelToInactiveImageValue((index / 2, column: index % 2))
                    if self.sudokuBoard.isGameCompleted() {
                        self.userCompletesGame()
                    }
                    return (-1, -1)
                }
            }
            break;
        case 9:
            let number: Int = self.sudokuBoard.getNumberFromGameBoard(boardPosn)
            if number > 0 {
                self.playRuboutSound()
                self.sudokuBoard.clearLocationOnGameBoard(boardPosn)
                self.setCellToBlankImage(boardPosn)
                self.userSolution.removeCoordinate(boardPosn)
                self.userGame.incrementGamePlayerMovesDeleted()
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
        if self.userGame.getGameInPlay() == false {
            return
        }
        // has the user tapped in a cell?
        let posn: (row: Int, column: Int, cellRow: Int, cellColumn: Int) = self.getPositionOfSudokuBoardImageTapped(recognizer.locationInView(recognizer.view))
        if posn.column == -1 {
            return
        }
        // ignore the 'origin' positions
        if self.sudokuBoard.isOriginBoardCellUsed(posn) {
            return
        }
        // if we have an acive Hint to place see if the board cell is clear and fill it!
        if self.giveHint == true {
            self.placeUserHintOnBoard(posn)
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
                self.sudokuBoard.clearLocationOnGameBoard(posn)
                self.setCellToBlankImage(posn)
                self.userSolution.removeCoordinate(posn)
                self.userGame.incrementGamePlayerMovesDeleted()
                self.boardPosition = (-1, -1, -1, -1)
                return
            }
            if self.sudokuBoard.setNumberOnGameBoard(posn, number: index + 1) == false {
                self.playErrorSound()
            } else {
                self.userSolution.addCoordinate(posn)
                self.userGame.incrementGamePlayerMovesMade()
                // do we need to make number 'inactive'?
                if self.sudokuBoard.isNumberFullyUsedOnGameBoard(index + 1) == false {
                    self.setCoordToSelectImage(posn, number: index + 1)
                    self.playPlacementSound(index + 1)
                } else {
                    self.setCoordToOriginImage(posn, number: index + 1)
                    self.setControlPanelToInactiveImageValue((index / 2, column: index % 2))
                    self.unsetSelectNumbersOnBoard()
                    self.controlPanelPosition = (-1, -1)
                    self.playPlacementSound(index + 1)
                    // have we completed the game
                    if self.sudokuBoard.isGameCompleted() {
                        self.userCompletesGame()
                    }
                }
            }
        case 9:
            if number == 0 {
                return
            }
            // when user selects posn on board and it's populated by a user solution, clear it if it's set to 'delete' state!
            if self.displayBoard.getImageState(posn) != imgStates.Delete.rawValue {
                self.playErrorSound()
                return
            }
            self.playRuboutSound()
            self.sudokuBoard.clearLocationOnGameBoard(posn)
            self.setCellToBlankImage(posn)
            self.userSolution.removeCoordinate(posn)
            self.userGame.incrementGamePlayerMovesDeleted()
            self.boardPosition = (-1, -1, -1, -1)
            // may need to reactivate 'inactive' control panel posn
            self.resetInactiveNumberOnBoard(number)
            // if we have exhausted all 'delete' options, then reset the control panel icon, and selected ctrl panel posn
            if self.displayBoard.getLocationsOfImages(imgStates.Delete.rawValue).count == 0 {
                self.setControlPanelToSelectedImageValue((index / 2, column: index % 2))
                self.controlPanelPosition = (-1, -1)
            }
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
    // place users hint on the board, if we can
    //
    func placeUserHintOnBoard(position: (row: Int, column: Int, cellRow: Int, cellColumn: Int)) {
        if self.sudokuBoard.isGameBoardCellUsed(position) == true {
            self.playErrorSound()
        } else {
            let number: Int = self.sudokuBoard.getNumberFromSolutionBoard(position)
            if self.sudokuBoard.setNumberOnGameBoard(position, number: number) == false {
                self.playErrorSound()
            } else {
                // we need to clear any selected numbers on the board and any reset control panel icons if selected
                self.unsetDeleteNumbersOnBoard()
                self.unsetSelectNumbersOnBoard()
                if self.controlPanelPosition.row != -1 {
                    let index: Int = (self.controlPanelPosition.row * 2) + self.controlPanelPosition.column
                    switch index {
                        case 0..<9:
                            if self.sudokuBoard.isNumberFullyUsedOnGameBoard(index + 1) == true {
                                self.setControlPanelToInactiveImageValue(self.controlPanelPosition)
                            } else {
                                self.setControlPanelToOriginImageValue(self.controlPanelPosition)
                            }
                            break
                        case 9:
                            self.setControlPanelToOriginImageValue(self.controlPanelPosition)
                            break
                        default:
                        break
                    }
                    self.controlPanelPosition = (-1, -1)
                }
                // then we can add the number
                self.userSolution.addCoordinate(position)
                self.userGame.incrementGamePlayerMovesMade()
                // do we need to make number 'inactive'?
                if self.sudokuBoard.isNumberFullyUsedOnGameBoard(number) == false {
                    self.setCoordToSelectImage(position, number: number)
                    self.playPlacementSound(number)
                } else {
                    self.setCoordToOriginImage(position, number: number)
                    self.setControlPanelToInactiveImageValue(((number - 1) / 2, column: (number - 1) % 2))
                    self.unsetSelectNumbersOnBoard()
                    self.controlPanelPosition = (-1, -1)
                    self.playPlacementSound(number)
                    // have we completed the game
                    if self.sudokuBoard.isGameCompleted() {
                        self.userCompletesGame()
                    }
                }
            }
            self.giveHint = false
        }
        return
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
    // routines to make numbers inactive/active if all are completed on board
    //----------------------------------------------------------------------------

    func resetInactiveNumberOnBoard(number: Int) {
        let index: Int = number - 1
        self.setControlPanelToOriginImageValue((index / 2, column: index % 2))
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
        var alertController: UIAlertController!
        if self.userGame.getGameInPlay() == false {
            self.playErrorSound()
            alertController = UIAlertController(title: "Hint Options", message: "Hints are only useful when you have a game in progress!", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action:UIAlertAction!) in //action -> Void in
                // nothing to do here, user bailed on using a hint
            }
            alertController.addAction(cancelAction)
            return
        }
        if self.userPrefs.hintsOn == false {
            self.playErrorSound()
            alertController = UIAlertController(title: "Hint Options", message: "Hints have been turned off! You can turn them back on in the prefs panel.", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action:UIAlertAction!) in //action -> Void in
                // nothing to do here, user bailed on using a hint
            }
            alertController.addAction(cancelAction)
        } else {
            alertController = UIAlertController(title: "Hint Options", message: "So you want to use a hint, this will add some time to your game clock. Ok?",preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action:UIAlertAction!) in //action -> Void in
                // nothing to do here, user bailed on using a hint
            }
            alertController.addAction(cancelAction)
            let useHintAction = UIAlertAction(title: "Give me a hint!", style: .Default) { (action:UIAlertAction!) in
                if self.addHintToBoard() {
                    self.addPenaltyToGameTime()
                }
            }
            alertController.addAction(useHintAction)
            let userSelectAction = UIAlertAction(title: "Let me select a cell to uncover!", style: .Default) { (action:UIAlertAction!) in
                self.giveHint = true
            }
            alertController.addAction(userSelectAction)
            //
            // if we have detected numbers placed incorrectly give option to highlight (then pretend bin has been selected with restricted set)
            //
            let incorrectPlacements: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] = self.incorrectNumbersPlacedOnBoard()
            if incorrectPlacements.count > 0 {
                var msg: String = ""
                if incorrectPlacements.count == 1 {
                    msg = "There is an incorrect number, show it!"
                } else {
                    msg = "\(incorrectPlacements.count) incorrect numbers, show them!"
                }
                let useHighlightAction = UIAlertAction(title: msg, style: .Default) { (action:UIAlertAction!) in
                    //
                    // need to clear any ctrl posn and board cells already highlighted
                    //
                    if self.controlPanelPosition.row != -1 {
                        let index: Int = (self.controlPanelPosition.row * 2) + self.controlPanelPosition.column
                        switch index {
                            case 0..<9:
                                if self.sudokuBoard.isNumberFullyUsedOnGameBoard(index + 1) == true {
                                    self.setControlPanelToInactiveImageValue((index / 2, column: index % 2))
                                } else {
                                    self.setControlPanelToOriginImageValue((index / 2, column: index % 2))
                                }
                                self.unsetSelectNumbersOnBoard()
                                break
                            case 9:
                                self.setControlPanelToOriginImageValue((index / 2, column: index % 2))
                                self.unsetDeleteNumbersOnBoard()
                                break
                            default:
                                // if we have a highlighted number (prob) from a hint, reset it!
                                self.unsetSelectNumbersOnBoard()
                                break
                        }
                    }
                    //
                    // highlight the incorrect numbers and the 'bin' as though the user had done it!
                    //
                    self.setControlPanelToDeleteImageValue((4, column: 1))
                    self.controlPanelPosition = (4, 1)
                    self.setDeleteLocationsOnBoard(incorrectPlacements)
                    self.boardPosition = (-1, -1, -1, -1)
                }
                alertController.addAction(useHighlightAction)
            }
        }
        self.presentViewController(alertController, animated: true, completion:nil)
        return
    }
    
    //
    // If they have a 'selected' number highlighted use that!, then failover to a random hint
    //
    func addHintToBoard() -> Bool {
        var optionsToRemove: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] = []
        if self.controlPanelPosition.row == -1 {
            optionsToRemove = self.sudokuBoard.getFreeLocationsOnGameBoard()
        } else {
            let index: Int = (self.controlPanelPosition.row * 2) + self.controlPanelPosition.column
            if index > 8 {
                optionsToRemove = self.sudokuBoard.getFreeLocationsOnGameBoard()
            } else {
                optionsToRemove = self.sudokuBoard.getFreeLocationsForNumberOnGameBoard(index + 1)
            }
        }
        // if we found none to remove (shouldn't happen though) escape cleanly
        if optionsToRemove.count == 0 {
            return false
        }
        // choose a random hint
        let posnToRemove: Int = Int(arc4random_uniform(UInt32(optionsToRemove.count)))
        let number: Int = self.sudokuBoard.getNumberFromSolutionBoard(optionsToRemove[posnToRemove])
        if self.sudokuBoard.setNumberOnGameBoard(optionsToRemove[posnToRemove], number: number) {
            self.userSolution.addCoordinate(optionsToRemove[posnToRemove])
            self.userGame.incrementGamePlayerMovesMade()
            // do we need to make number 'inactive'?
            if self.sudokuBoard.isNumberFullyUsedOnGameBoard(number) == false {
                self.setCoordToSelectImage(optionsToRemove[posnToRemove], number: number)
                self.playPlacementSound(number)
            } else {
                self.setCoordToOriginImage(optionsToRemove[posnToRemove], number: number)
                self.setControlPanelToInactiveImageValue(((number - 1) / 2, column: (number - 1) % 2))
                self.unsetSelectNumbersOnBoard()
                self.controlPanelPosition = (-1, -1)
                self.playPlacementSound(number)
                // have we completed the game
                if self.sudokuBoard.isGameCompleted() {
                    self.userCompletesGame()
                }
            }
        }
        return true
    }
    
    //
    // use the userSolution and compare against the 'Origin' board to see if we have incorrect placements
    //
    func incorrectNumbersPlacedOnBoard() -> [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] {
        var incorrectCoords: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] = []
        let coordsInSolution: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] = self.userSolution.getCoordinatesInSolution()
        for coord in coordsInSolution {
            if self.sudokuBoard.getNumberFromGameBoard(coord) != self.sudokuBoard.getNumberFromSolutionBoard(coord) {
                incorrectCoords.append(coord)
            }
        }
        return incorrectCoords
    }
    
    //----------------------------------------------------------------------------
    // things to do when the user completes the game
    //----------------------------------------------------------------------------
    func userCompletesGame() {
        self.stopGameTimer()
        self.playVictorySound()
        //
        // set up a customised message for the user
        //
        var completedMsg: String = ""
        if self.userGame.setCurrentFastestPlayerTime() == true {
           completedMsg.appendContentsOf("Wow! You have just set your fastest time of " + self.timeInText(self.userGame.getCurrentGameTimePlayed()) + ", do")
        } else {
           completedMsg.appendContentsOf("Do")
        }
        completedMsg.appendContentsOf(" you want to start again with another puzzle?")
        //
        // save things about the game we care about
        //
        self.userGame.incrementTotalPlayerMovesMade(self.userGame.getGamePlayerMovesMade())
        self.userGame.incrementTotalPlayerMovesDeleted(self.userGame.getGamePlayerMovesDeleted())
        self.userGame.incrementCompletedGames()
        self.userGame.setGameInPlay(false)
        //
        // go again?
        //
        let alertController = UIAlertController(title: "Congratulations", message: completedMsg, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action:UIAlertAction!) in //action -> Void in
            // nothing to do here, user bailed on reseting the game (why???????)
        }
        alertController.addAction(cancelAction)
        let restartAction = UIAlertAction(title: "New Puzzle!", style: .Default) { (action:UIAlertAction!) in
            self.resetControlPanelSelection()
            self.sudokuBoard.clearBoard()
            self.sudokuBoard.setBoardDifficulty(self.userPrefs.difficultySet)
            self.sudokuBoard.buildSolution()
            if self.debug == 1 {
                print(self.sudokuBoard.dumpSolutionBoard())
            }
            self.sudokuBoard.buildOriginBoard()
            self.finalPreparationForGameStart()
        }
        alertController.addAction(restartAction)
        self.presentViewController(alertController, animated: true, completion:nil)
        return
    }
    
    func timeInText(time:Int) -> String {
        return String(format: "%d", time / 60) + " minutes and " + String(format: "%d", time % 60) + " seconds"
    }

    //----------------------------------------------------------------------------
    // captures user pressing the 'Settings' button
    //----------------------------------------------------------------------------
    @IBAction func settingButtonPressed(sender: UIButton) {
        // first save the current preferences
        let pViewController: Preferences = Preferences()
        pViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
        pViewController.prefs = self.userPrefs
        pViewController.state = self.userGame
        self.presentViewController(pViewController, animated: true, completion: nil)
        let popoverController = pViewController.popoverPresentationController
        popoverController?.sourceView = sender
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
    
    //----------------------------------------------------------------------------
    // translate game to/from GameStateHandler
    //----------------------------------------------------------------------------
    func loadGameState() {
        return
    }
    
    //
    // Game cells linked to the solution tracker
    //
    func getCurrentGameBoardState() -> [BoardCell] {
        var cells: [BoardCell] = []
        let coordsInGame: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] = self.userSolution.getCoordinatesInSolution()
        for coord in coordsInGame {
            let number: Int = self.sudokuBoard.getNumberFromGameBoard(coord)
            var cell: BoardCell = BoardCell()
            cell.row   = coord.row
            cell.col   = coord.column
            cell.crow  = coord.cellRow
            cell.ccol  = coord.cellColumn
            cell.value = number
            cell.state = self.displayBoard.getImageState(coord)
            cells.append(cell)
        }
        return cells
    }

    //
    // Only populated origin cells
    //
    func getCurrentOriginBoardState() -> [BoardCell] {
        var cells: [BoardCell] = []
        for y: Int in 0 ..< self.displayBoard.boardRows {
            for x: Int in 0 ..< self.displayBoard.boardColumns {
                for j: Int in 0 ..< self.displayBoard.gameImages[y][x].cellRows {
                    for k: Int in 0 ..< self.displayBoard.gameImages[y][x].cellColumns {
                        let coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int) = (y, x, j, k)
                        let number: Int = self.sudokuBoard.getNumberFromOriginBoard(coord)
                        if number > 0 {
                            var cell: BoardCell = BoardCell()
                            cell.row   = coord.row
                            cell.col   = coord.column
                            cell.crow  = coord.cellRow
                            cell.ccol  = coord.cellColumn
                            cell.value = number
                            cell.state = self.displayBoard.getImageState(coord)
                            cells.append(cell)
                        }
                    }
                }
            }
        }
        return cells
    }

    //
    // All solution cells
    //
    func getCurrentSolutionBoardState() -> [BoardCell] {
        var cells: [BoardCell] = []
        for y: Int in 0 ..< self.displayBoard.boardRows {
            for x: Int in 0 ..< self.displayBoard.boardColumns {
                for j: Int in 0 ..< self.displayBoard.gameImages[y][x].cellRows {
                    for k: Int in 0 ..< self.displayBoard.gameImages[y][x].cellColumns {
                        let coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int) = (y, x, j, k)
                        var cell: BoardCell = BoardCell()
                        cell.row   = coord.row
                        cell.col   = coord.column
                        cell.crow  = coord.cellRow
                        cell.ccol  = coord.cellColumn
                        cell.value = self.sudokuBoard.getNumberFromSolutionBoard(coord)
                        cell.state = self.displayBoard.getImageState(coord)
                        cells.append(cell)
                    }
                }
            }
        }
        return cells
    }
    
}

