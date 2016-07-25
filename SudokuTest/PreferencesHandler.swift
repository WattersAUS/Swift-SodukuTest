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
    var characterSetInUse: Int
    var difficultySet: Int
    var gameModeInUse: Int
    var soundOn: Bool
    var hintsOn: Bool
    
    var drawFunctions: [(Void) -> ()] = []

    //init(charSet: Int, difficulty: Int, mode: Int, sound: Bool, hints: Bool, redrawFunctions: [(Void) -> ()]) {
    init(redrawFunctions: [(Void) -> ()]) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        self.characterSetInUse = userDefaults.integerForKey("charset") ?? 0
        self.difficultySet = userDefaults.integerForKey("difficulty") ?? 5
        self.gameModeInUse = userDefaults.integerForKey("gamemode") ?? 0
        self.soundOn = userDefaults.boolForKey("sound") ?? true
        self.hintsOn = userDefaults.boolForKey("hint") ?? false
        for functionName: (Void) -> () in redrawFunctions {
            self.drawFunctions.append(functionName)
        }
        return
    }
}


