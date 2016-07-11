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
    var highlightOn: Bool { get set }
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

class PreferencesHandler: NSObject, NSCopying, PreferencesDelegate {
    var characterSetInUse: Int
    var difficultySet: Int
    var gameModeInUse: Int
    var soundOn: Bool
    var highlightOn : Bool
    
    var drawFunctions: [(Void) -> ()] = []

    init(charSet: Int, difficulty: Int, mode: Int, sound: Bool, highlight: Bool, redrawFunctions: [(Void) -> ()]) {
        self.characterSetInUse = charSet
        self.difficultySet = difficulty
        self.gameModeInUse = 0
        self.soundOn = sound
        self.highlightOn = highlight
        for functionName: (Void) -> () in redrawFunctions {
            self.drawFunctions.append(functionName)
        }
        return
    }

    //
    // copy object operation
    //
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = PreferencesHandler(charSet: self.characterSetInUse, difficulty: self.difficultySet, mode: self.gameModeInUse, sound: self.soundOn, highlight: self.highlightOn, redrawFunctions: self.drawFunctions)
        return copy
    }
}


