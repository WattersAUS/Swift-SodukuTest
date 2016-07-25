//
//  PreferencesHandler.swift
//  SudokuTest
//
//  Created by Graham Watson on 10/07/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

protocol PreferencesDelegate: class {
    // what we use to populate the pref dialog
    var characterSetInUse: Int { get set }
    var difficultySet: Int { get set }
    var gameModeInUse: Int { get set }
    var soundOn: Bool { get set }
    var hintsOn: Bool { get set }
    // if we swap the char set redraw the board
    var drawFunctions: [(Void) -> ()] { get set }
    var saveFunctions: [(Void) -> ()] { get set }

// game stats
//    var gamesStarted: Int { get }
//    var gamesCompleted: Int { get }
//    var timePlayed: Int { get }
//    var movesMade: Int { get }
//    var movesDeleted: Int { get }
//    var highScore: Int { get }
//    var averageScore: Int { get }
//    var fastestGame: Int { get }
    
//    func setCharacterSetToUse(characterSetToUse: Int)
//    func setGameDifficultyToUse(gameDifficulty: Int)
//    func setGameModeToUse(gameModeToSet: Int)
//    func setSounds(soundOn: Bool)
//    func setHighlight(highlightOn: Bool)
}

class PreferencesHandler: NSObject, PreferencesDelegate {
    var characterSetInUse: Int = 0
    var difficultySet: Int = 0
    var gameModeInUse: Int = 0
    var soundOn: Bool = true
    var hintsOn: Bool = false
    var drawFunctions: [(Void) -> ()] = []
    var saveFunctions: [(Void) -> ()] = []
    
    let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()

    //init(charSet: Int, difficulty: Int, mode: Int, sound: Bool, hints: Bool, redrawFunctions: [(Void) -> ()]) {
    init(redrawFunctions: [(Void) -> ()]) {
        super.init()
        //let self.userDefaults = NSUserDefaults.standardUserDefaults()
        // get the difficulty first, if we get 0 then the prefs have never been saved. so save them
        self.difficultySet = self.userDefaults.integerForKey("difficulty")
        if self.difficultySet != 0 {
            self.characterSetInUse = self.userDefaults.integerForKey("charset")
            self.gameModeInUse = self.userDefaults.integerForKey("gamemode")
            self.soundOn = self.userDefaults.boolForKey("sound")
            self.hintsOn = self.userDefaults.boolForKey("hint")
        } else {
            self.characterSetInUse = imageSet.Default.rawValue
            self.difficultySet = gameDiff.Medium.rawValue
            self.gameModeInUse = gameMode.Normal.rawValue
            self.soundOn = true
            self.hintsOn = false
            // store for the first time
            self.savePreferences()
        }
        for functionName: (Void) -> () in redrawFunctions {
            self.drawFunctions.append(functionName)
        }
        self.saveFunctions = [ self.savePreferences ]
        return
    }

    func savePreferences() -> (Void) {
        self.userDefaults.setInteger(self.characterSetInUse, forKey: "charset")
        self.userDefaults.setInteger(self.difficultySet, forKey: "difficulty")
        self.userDefaults.setInteger(self.gameModeInUse, forKey: "gamemode")
        self.userDefaults.setBool(self.soundOn, forKey: "sound")
        self.userDefaults.setBool(self.hintsOn, forKey: "hint")
        return
    }
    
}


