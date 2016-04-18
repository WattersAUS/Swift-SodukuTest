//
//  SudokuTestCellTests.swift
//  SudokuTestCellTests
//
//  Created by Graham Watson on 06/03/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import XCTest
@testable import SudokuTest

class SudokuTestCellTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCellInitialSizeOverriddenCorrectly() {
        var testCell: Cell!
        testCell = Cell(size: 7)
        // we should see a size == 3 for width and depth where we passed value not = 3
        XCTAssertEqual(testCell.cellDepth(), 3, "Incorrect initial Cell depth reported")
        XCTAssertEqual(testCell.cellWidth(), 3, "Incorrect initial Cell width reported")
    }

    func testCellInitialSizeSetCorrectly() {
        var testCell: Cell!
        testCell = Cell(size: 3)
        // we should see a size == 3 for width
        XCTAssertEqual(testCell.cellDepth(), 3, "Incorrect initial Cell depth reported")
        XCTAssertEqual(testCell.cellWidth(), 3, "Incorrect initial Cell width reported")
    }
    
    func testCellInitialisedAsImcomplete() {
        var testCell: Cell!
        testCell = Cell(size: 3)
        // and cell should be set to incomplete
        XCTAssertNotEqual(testCell.isCellCompleted(), true, "Incorrect initial Cell state reported")
    }

    func testCellArrayEntriesSetToZero() {
        var testCell: Cell!
        testCell = Cell(size: 3)
        // the array entries are all set to 0
        for row: Int in 0 ..< testCell.cellDepth() {
            for column: Int in 0 ..< testCell.cellWidth() {
                XCTAssertEqual(testCell.getNumberAtCellPosition(row, column: column), 0, "Incorrect initial Cell value reported")
            }
        }
    }
    
    func testCellUsedArrayPositionsReturnedCorrectly() {
        var testCell: Cell!
        testCell = Cell(size: 3)
        // test for setting to an row/column illegal position
        XCTAssertEqual(testCell.setNumberAtCellPosition(3, column: 0, number: 5), false, "Allowed to update outside of bounds of array")
        XCTAssertEqual(testCell.setNumberAtCellPosition(0, column: 3, number: 5), false, "Allowed to update outside of bounds of array")
        XCTAssertEqual(testCell.setNumberAtCellPosition(0, column: 0, number: 10), false, "Update value beyond allowed maximum")
        // row 0
        // coord 0,0
        XCTAssertEqual(testCell.getNumberAtCellPosition(0, column: 0), 0, "Incorrect Cell value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(0, column: 0, number: 5), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.getNumberAtCellPosition(0, column: 0), 5, "Incorrect Cell value reported")
        // coord 0,1
        XCTAssertEqual(testCell.getNumberAtCellPosition(0, column: 1), 0, "Incorrect Cell value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(0, column: 1, number: 7), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.getNumberAtCellPosition(0, column: 1), 7, "Incorrect Cell value reported")
        // coord 0,2
        XCTAssertEqual(testCell.getNumberAtCellPosition(0, column: 2), 0, "Incorrect Cell value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(0, column: 2, number: 1), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.getNumberAtCellPosition(0, column: 2), 1, "Incorrect Cell value reported")
        // row 1
        // coord 1,0
        XCTAssertEqual(testCell.getNumberAtCellPosition(1, column: 0), 0, "Incorrect Cell value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(1, column: 0, number: 2), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.getNumberAtCellPosition(1, column: 0), 2, "Incorrect Cell value reported")
        // coord 1,1
        XCTAssertEqual(testCell.getNumberAtCellPosition(1, column: 1), 0, "Incorrect Cell value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(1, column: 1, number: 3), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.getNumberAtCellPosition(1, column: 1), 3, "Incorrect Cell value reported")
        // coord 1,2
        XCTAssertEqual(testCell.getNumberAtCellPosition(1, column: 2), 0, "Incorrect Cell value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(1, column: 2, number: 8), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.getNumberAtCellPosition(1, column: 2), 8, "Incorrect Cell value reported")
        // row 2
        // coord 2,0
        XCTAssertEqual(testCell.getNumberAtCellPosition(2, column: 0), 0, "Incorrect Cell value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(2, column: 0, number: 6), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.getNumberAtCellPosition(2, column: 0), 6, "Incorrect Cell value reported")
        // coord 2,1
        XCTAssertEqual(testCell.getNumberAtCellPosition(2, column: 1), 0, "Incorrect Cell value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(2, column: 1, number: 4), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.getNumberAtCellPosition(2, column: 1), 4, "Incorrect Cell value reported")
        // coord 2,2
        XCTAssertEqual(testCell.getNumberAtCellPosition(2, column: 2), 0, "Incorrect Cell value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(2, column: 2, number: 9), true, "Incorrect Cell complete value reported")
        XCTAssertEqual(testCell.getNumberAtCellPosition(2, column: 2), 9, "Incorrect Cell value reported")
        // test cell is completed
        XCTAssertEqual(testCell.isCellCompleted(), true, "Incorrect Cell complete value reported")
        // remove value from array and test cell is incomplete
        testCell.clearNumberAtCellPosition(1, column: 1)
        XCTAssertEqual(testCell.getNumberAtCellPosition(1, column: 1), 0, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.isCellCompleted(), false, "Incorrect Cell incomplete value reported")
        // reset and complete the cell
        XCTAssertEqual(testCell.setNumberAtCellPosition(1, column: 1, number: 3), true, "Incorrect Cell complete value reported")
        XCTAssertEqual(testCell.isCellCompleted(), true, "Incorrect Cell complete value reported")
    }
    
//    func testCellInitialisedCorrectlyWithSize() {
//        var testCell: Cell!
//        testCell = Cell(size: 3)
//        // we should see a size == 3 for width and depth
//        XCTAssertEqual(testCell.cellDepth(), 3, "Incorrect initial Cell depth reported")
//        XCTAssertEqual(testCell.cellWidth(), 3, "Incorrect initial Cell width reported")
//        // and cell should be set to incomplete
//        XCTAssertNotEqual(testCell.isCellCompleted(), true, "Incorrect initial Cell state reported")
//    }
    
//    func testBoardCleared() {
//        self.testBoard.clearBoard()
//    }
//
//    func testBoardBuilt() {
//        self.testBoard.buildSolution()
//    }
//    
//    func testGameBoardBuilt() {
//        self.testBoard.buildGameBoard()
//    }
//
//    func testOriginBoardBuilt() {
//        self.testBoard.buildOriginBoard()
//    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
