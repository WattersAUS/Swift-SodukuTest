//
//  SudokuTestGameBoardTests.swift
//  SudokuTest
//
//  Created by Graham Watson on 21/04/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import XCTest
@testable import SudokuTest

class SudokuTestGameBoardTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGameBoardInitialSizeCorrectlyWithoutParameters() {
        var testBoard: GameBoard!
        testBoard = GameBoard()
        // we should see a boardwidth = 9 and difficulty = 7 where no initial values are passed
        XCTAssertEqual(testBoard.getBoardWidthInCells(), 9, "Incorrect Board cells width reported")
        XCTAssertEqual(testBoard.getGameDifficulty(), 7, "Incorrect Difficulty reported")
        XCTAssertEqual(testBoard.getBoardRows(), 3, "Incorrect Board Rows reported")
        XCTAssertEqual(testBoard.getBoardColumns(), 3, "Incorrect Board Columns reported")
    }

    func testGameBoardInitialSizeCorrectlyWithParametersOverridden() {
        var testBoard: GameBoard!
        testBoard = GameBoard(size: 5, setDifficulty: 10)
        // we should see a boardwidth = 9 and difficulty = 7 along with rows and columns = 3 where initial values get overriden
        XCTAssertEqual(testBoard.getBoardWidthInCells(), 9, "Incorrect Board cells width reported")
        XCTAssertEqual(testBoard.getGameDifficulty(), 7, "Incorrect Difficulty reported")
        XCTAssertEqual(testBoard.getBoardRows(), 3, "Incorrect Board Rows reported")
        XCTAssertEqual(testBoard.getBoardColumns(), 3, "Incorrect Board Columns reported")
    }
    
    func testGameBoardInitialSizeSetCorrectlyWithParameters() {
        var testBoard: GameBoard!
        testBoard = GameBoard(size: 3, setDifficulty: 8)
        // we should see a boardwidth = 9 and difficulty = 8 where initial values are passed correctly
        XCTAssertEqual(testBoard.getBoardWidthInCells(), 9, "Incorrect initial Board width reported")
        XCTAssertEqual(testBoard.getGameDifficulty(), 8, "Incorrect initial Difficulty reported")
        XCTAssertEqual(testBoard.getBoardRows(), 3, "Incorrect initial Difficulty reported")
        XCTAssertEqual(testBoard.getBoardColumns(), 3, "Incorrect initial Difficulty reported")
    }
    
    func testGameBoardInitialisedAsIncomplete() {
        var testBoard: GameBoard!
        testBoard = GameBoard(size: 3)
        // and board should be set to incomplete
        XCTAssertNotEqual(testBoard.isSolutionCompleted(), true, "Incorrect initial Cell state reported")
    }
    
    func testGameBoardInitialisedToZero() {
        var testBoard: GameBoard!
        testBoard = GameBoard(size: 3)
        // check the array entries are all set to 0
        for bRows: Int in 0 ..< testBoard.getBoardRows() {
            for bColumns: Int in 0 ..< testBoard.getBoardColumns() {
                for cRows: Int in 0 ..< testBoard.getBoardRows() {
                    for cColumns: Int in 0 ..< testBoard.getBoardColumns() {
                        XCTAssertEqual(testBoard.getNumberFromGameBoard((bRows, column: bColumns, cellRow: cRows, cellColumn: cColumns)), 0, "Cell not initialised correctly")
                    }
                }
            }
        }
    }
    
    func testGameBoard_IsNumberFullyUsedOnBoard() {
        
    }
    
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
