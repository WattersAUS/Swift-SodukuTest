//
//  SaveGameHandler.swift
//  SudokuTest
//
//  Created by Graham Watson on 27/07/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//
//----------------------------------------------------------------------------
// this class defines the 'protocol' used to allow the settings dialog to
// delegate the responsibility of keeping the defaults updated and including
// ensuring they are updated through the NSUserDefaults interface
//----------------------------------------------------------------------------

import Foundation

protocol GameStateDelegate: class {
    // game stats
    var currentGame: GameState { get set }
}

class GameStateHandler: NSObject, GameStateDelegate {
    private var gameSave: [String: AnyObject]!
    internal var currentGame: GameState = GameState()
    
    override init() {
        super.init()
        self.currentGame.startedGames          = 0
        self.currentGame.completedGames        = 0
        self.currentGame.totalTimePlayed       = 0
        self.currentGame.totalMovesMade        = 0
        self.currentGame.totalMovesDeleted     = 0
        self.currentGame.highScore             = 0
        self.currentGame.lowScore              = 0
        self.currentGame.fastestGame           = 0
        self.currentGame.slowestGame           = 0
        self.currentGame.gameInPlay            = false
        self.currentGame.penaltyValue          = 0
        self.currentGame.penaltyIncrementValue = 0
        self.currentGame.currentGameTime       = 0
        self.currentGame.gameMovesMade         = 0
        self.currentGame.gameMovesDeleted      = 0
        self.currentGame.cells                 = []
        self.gameSave                          = [:]
        // build initial save dictionary
        self.prepareGameSaveObjects()
        return
    }

    //-------------------------------------------------------------------------------
    // load/save to/from internal 'currentgame' state and save dictionary 'gameSave'
    //-------------------------------------------------------------------------------
    private func updateGameSaveValue(keyValue: String, value: AnyObject) {
        self.gameSave[keyValue] = value
        return
    }

    func prepareGameSaveObjects() {
        self.updateGameSaveValue(saveGameDictionary.GamesStarted.rawValue,      value: self.currentGame.startedGames)
        self.updateGameSaveValue(saveGameDictionary.GamesCompleted.rawValue,    value: self.currentGame.completedGames)
        self.updateGameSaveValue(saveGameDictionary.TotalTimePlayed.rawValue,   value: self.currentGame.totalTimePlayed)
        self.updateGameSaveValue(saveGameDictionary.TotalMovesMade.rawValue,    value: self.currentGame.totalMovesMade)
        self.updateGameSaveValue(saveGameDictionary.TotalMovesDeleted.rawValue, value: self.currentGame.totalMovesDeleted)
        self.updateGameSaveValue(saveGameDictionary.HighScore.rawValue,         value: self.currentGame.highScore)
        self.updateGameSaveValue(saveGameDictionary.LowScore.rawValue,          value: self.currentGame.lowScore)
        self.updateGameSaveValue(saveGameDictionary.FastestGameTime.rawValue,   value: self.currentGame.fastestGame)
        self.updateGameSaveValue(saveGameDictionary.SlowestGameTime.rawValue,   value: self.currentGame.slowestGame)
        self.updateGameSaveValue(saveGameDictionary.GameInPlay.rawValue,        value: self.currentGame.gameInPlay)
        self.updateGameSaveValue(saveGameDictionary.PenaltyValue.rawValue,      value: self.currentGame.penaltyValue)
        self.updateGameSaveValue(saveGameDictionary.CurrentGameTime.rawValue,   value: self.currentGame.currentGameTime)
        self.updateGameSaveValue(saveGameDictionary.GameMovesMade.rawValue,     value: self.currentGame.gameMovesMade)
        self.updateGameSaveValue(saveGameDictionary.GameMovesDeleted.rawValue,  value: self.currentGame.gameMovesDeleted)
        var cellArray: [AnyObject] = []
        for cell: BoardCell in self.currentGame.cells {
            cellArray.append(["row": cell.row, "col": cell.col, "crow": cell.crow, "ccol": cell.ccol, "value": cell.value, "state": cell.state])
        }
        self.updateGameSaveValue(saveGameDictionary.GameBoard.rawValue,         value: cellArray)
        return
    }

    private func getGameStateValue(keyValue: String) -> AnyObject {
        return self.gameSave[keyValue]!
    }
    
    func loadGameSaveObjects() {
        self.currentGame.startedGames          = self.getGameStateValue(saveGameDictionary.GamesStarted.rawValue) as! Int
        self.currentGame.completedGames        = self.getGameStateValue(saveGameDictionary.GamesCompleted.rawValue) as! Int
        self.currentGame.totalTimePlayed       = self.getGameStateValue(saveGameDictionary.TotalTimePlayed.rawValue) as! Int
        self.currentGame.totalMovesMade        = self.getGameStateValue(saveGameDictionary.TotalMovesMade.rawValue) as! Int
        self.currentGame.totalMovesDeleted     = self.getGameStateValue(saveGameDictionary.TotalMovesDeleted.rawValue) as! Int
        self.currentGame.highScore             = self.getGameStateValue(saveGameDictionary.HighScore.rawValue) as! Int
        self.currentGame.lowScore              = self.getGameStateValue(saveGameDictionary.LowScore.rawValue) as! Int
        self.currentGame.fastestGame           = self.getGameStateValue(saveGameDictionary.FastestGameTime.rawValue) as! Int
        self.currentGame.slowestGame           = self.getGameStateValue(saveGameDictionary.SlowestGameTime.rawValue) as! Int
        self.currentGame.gameInPlay            = self.getGameStateValue(saveGameDictionary.GameInPlay.rawValue) as! Bool
        self.currentGame.penaltyValue          = self.getGameStateValue(saveGameDictionary.PenaltyValue.rawValue) as! Int
        self.currentGame.penaltyIncrementValue = self.getGameStateValue(saveGameDictionary.PenaltyIncrementValue.rawValue) as! Int
        self.currentGame.currentGameTime       = self.getGameStateValue(saveGameDictionary.CurrentGameTime.rawValue)  as! Int
        self.currentGame.gameMovesMade         = self.getGameStateValue(saveGameDictionary.GameMovesMade.rawValue) as! Int
        self.currentGame.gameMovesDeleted      = self.getGameStateValue(saveGameDictionary.GameMovesDeleted.rawValue) as! Int
        for cell: [String: Int] in self.getGameStateValue(saveGameDictionary.GameBoard.rawValue) as! [[String: Int]] {
            for (key, value) in cell {
                var bCell: BoardCell = BoardCell()
                switch key {
                case cellDictionary.row.rawValue:
                    bCell.row = value
                    break
                case cellDictionary.col.rawValue:
                    bCell.col = value
                    break
                case cellDictionary.crow.rawValue:
                    bCell.crow = value
                    break
                case cellDictionary.ccol.rawValue:
                    bCell.ccol = value
                    break
                case cellDictionary.value.rawValue:
                    bCell.value = value
                    break
                case cellDictionary.state.rawValue:
                    bCell.state = value
                    break
                default:
                    break
                }
            }
        }
        return
    }

    //-------------------------------------------------------------------------------
    // update/access to internal 'currentgame' and the outside world
    //-------------------------------------------------------------------------------
    //
    // gets first
    //
    func getStartedGames() -> Int {
        return self.currentGame.startedGames
    }
    
    func getCompletedGames() -> Int {
        return self.currentGame.completedGames
    }

    func getTotalGameTimePlayed() -> Int {
        return self.currentGame.totalTimePlayed
    }
    
    func getTotalPlayerMovesMade() -> Int {
        return self.currentGame.totalMovesMade
    }
    
    func getTotalPlayerMovesDeleted() -> Int {
        return self.currentGame.totalMovesDeleted
    }
    
    func getGameInPlay() -> Bool {
        return self.currentGame.gameInPlay
    }
    
    func getGamePenaltyTime() -> Int {
        return self.currentGame.penaltyValue
    }
    
    func getCurrentGameTimePlayed() -> Int {
        return self.currentGame.currentGameTime
    }
    
    func getGamePlayerMovesMade() -> Int {
        return self.currentGame.gameMovesMade
    }
    
    func getGamePlayerMovesDeleted() -> Int {
        return self.currentGame.gameMovesDeleted
    }
    
    //
    // sets if needed
    //
    func setGameInPlay(value: Bool) {
        self.currentGame.gameInPlay = value
        return
    }
    
    func setCurrentGameTimePlayed(value: Int) -> Int {
        self.currentGame.currentGameTime = value
        return self.currentGame.currentGameTime
    }
    
    func setGamePenaltyTime(value: Int) -> Int {
        self.currentGame.penaltyValue = value
        return self.currentGame.penaltyValue
    }

    func resetGamePenaltyIncrementTime(value: Int) {
        self.currentGame.penaltyIncrementValue = value
        return
    }
    
    func resetGamePlayerMovesMade() {
        self.currentGame.gameMovesMade = 0
        return
    }
    
    func resetGamePlayerMovesDeleted() {
        self.currentGame.gameMovesDeleted = 0
        return
    }
    
    func setCurrentBestWorstPlayerTimes() {
        if (self.currentGame.fastestGame == 0) || (self.currentGame.currentGameTime < self.currentGame.fastestGame) {
            self.currentGame.fastestGame = self.currentGame.currentGameTime
        }
        if self.currentGame.currentGameTime > self.currentGame.slowestGame {
            self.currentGame.slowestGame = self.currentGame.currentGameTime
        }
        return
    }
    
    //
    // increments
    //
    func incrementStartedGames() {
        self.currentGame.startedGames = self.currentGame.startedGames + 1
        return
    }
    
    func incrementCompletedGames() {
        self.currentGame.completedGames = self.currentGame.completedGames + 1
        return
    }
    
    func incrementTotalGameTimePlayed(increment: Int) -> Int {
        self.currentGame.totalTimePlayed = self.currentGame.totalTimePlayed + increment
        return self.currentGame.totalTimePlayed
    }
    
    func incrementTotalPlayerMovesMade(increment: Int) -> Int {
        self.currentGame.totalMovesMade = self.currentGame.totalMovesMade + increment
        return self.currentGame.totalMovesMade
    }
    
    func incrementTotalPlayerMovesDeleted(increment: Int) -> Int {
        self.currentGame.totalMovesDeleted = self.currentGame.totalMovesDeleted + increment
        return self.currentGame.totalMovesDeleted
    }
    
    func incrementGamePenaltyTime(increment: Int) -> Int {
        self.currentGame.penaltyValue = self.currentGame.penaltyValue + increment
        return self.currentGame.penaltyValue
    }

    func incrementGamePenaltyIncrementTime(increment: Int) -> Int {
        self.currentGame.penaltyIncrementValue = self.currentGame.penaltyIncrementValue + increment
        return self.currentGame.penaltyIncrementValue
    }
    
    func incrementCurrentGameTimePlayed(increment: Int) -> Int {
        self.currentGame.currentGameTime = self.currentGame.currentGameTime + increment
        return self.currentGame.currentGameTime
    }
    
    func incrementGamePlayerMovesMade() -> Int {
        self.currentGame.gameMovesMade = self.currentGame.gameMovesMade + 1
        return self.currentGame.gameMovesMade
    }
    
    func incrementGamePlayerMovesDeleted() -> Int {
        self.currentGame.gameMovesDeleted = self.currentGame.gameMovesDeleted + 1
        return self.currentGame.gameMovesDeleted
    }
    
}


