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
        XCTAssertNotEqual(testCell.isCellCompleted(), true, "Incorrect initial Cell state reported")
    }

    func testCellInitialSizeSetCorrectly() {
        var testCell: Cell!
        testCell = Cell(size: 3)
        // we should see a size == 3 for width
        XCTAssertEqual(testCell.cellDepth(), 3, "Incorrect initial Cell depth reported")
        XCTAssertEqual(testCell.cellWidth(), 3, "Incorrect initial Cell width reported")
        XCTAssertNotEqual(testCell.isCellCompleted(), true, "Incorrect initial Cell state reported")
    }
    
    func testCellArrayEntriesInitialisedToZero() {
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
    
    func testCellClearWorksAsExpected() {
        var testCell: Cell!
        testCell = Cell(size: 3)
        // populate cell array
        XCTAssertEqual(testCell.setNumberAtCellPosition(0, column: 0, number: 5), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(0, column: 1, number: 7), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(0, column: 2, number: 1), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(1, column: 0, number: 2), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(1, column: 1, number: 3), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(1, column: 2, number: 8), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(2, column: 0, number: 6), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(2, column: 1, number: 4), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(2, column: 2, number: 9), true, "Incorrect Cell complete value reported")
        XCTAssertEqual(testCell.isCellCompleted(), true, "Incorrect Cell complete value reported")
        // now clear cell and make sure all values are set to 0
        testCell.clearCell()
        // test cell is set to cleared
        XCTAssertEqual(testCell.isCellCompleted(), false, "Incorrect Cell incomplete value reported")
        // now check the cells set to 0
        XCTAssertEqual(testCell.getNumberAtCellPosition(0, column: 0), 0, "Cell value not initialised")
        XCTAssertEqual(testCell.getNumberAtCellPosition(0, column: 1), 0, "Cell value not initialised")
        XCTAssertEqual(testCell.getNumberAtCellPosition(0, column: 2), 0, "Cell value not initialised")
        XCTAssertEqual(testCell.getNumberAtCellPosition(1, column: 0), 0, "Cell value not initialised")
        XCTAssertEqual(testCell.getNumberAtCellPosition(1, column: 1), 0, "Cell value not initialised")
        XCTAssertEqual(testCell.getNumberAtCellPosition(1, column: 2), 0, "Cell value not initialised")
        XCTAssertEqual(testCell.getNumberAtCellPosition(2, column: 0), 0, "Cell value not initialised")
        XCTAssertEqual(testCell.getNumberAtCellPosition(2, column: 1), 0, "Cell value not initialised")
        XCTAssertEqual(testCell.getNumberAtCellPosition(2, column: 2), 0, "Cell value not initialised")
    }
    
    func testCellNumberUsedInRow() {
        var testCell: Cell!
        testCell = Cell(size: 3)
        // populate cell array row
        XCTAssertEqual(testCell.setNumberAtCellPosition(0, column: 0, number: 5), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(0, column: 1, number: 7), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(0, column: 2, number: 1), false, "Incorrect Cell incomplete value reported")
        // test correct value found in row and incorrect value not found in row
        XCTAssertEqual(testCell.isNumberUsedInRow(5, row: 0), true, "Not detected value in row")
        XCTAssertEqual(testCell.isNumberUsedInRow(8, row: 0), false, "Not detected value not in row")
        // test row limits work
        XCTAssertEqual(testCell.isNumberUsedInRow(5, row: -1), false, "Not detected incorrect row")
        XCTAssertEqual(testCell.isNumberUsedInRow(5, row: 3), false, "Not detected incorrect row")
    }
    
    func testCellNumberUsedInColumn() {
        var testCell: Cell!
        testCell = Cell(size: 3)
        // populate cell array column
        XCTAssertEqual(testCell.setNumberAtCellPosition(0, column: 0, number: 5), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(1, column: 1, number: 7), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(2, column: 2, number: 1), false, "Incorrect Cell incomplete value reported")
        // test correct value found in row and incorrect value not found in row
        XCTAssertEqual(testCell.isNumberUsedInColumn(5, column: 0), true, "Not detected value in column")
        XCTAssertEqual(testCell.isNumberUsedInColumn(8, column: 0), false, "Not detected value not in column")
        // test row limits work
        XCTAssertEqual(testCell.isNumberUsedInColumn(5, column: -1), false, "Not detected incorrect column")
        XCTAssertEqual(testCell.isNumberUsedInColumn(5, column: 3), false, "Not detected incorrect column")
    }
    
    func testCellGetValuesFromRow() {
        var testCell: Cell!
        testCell = Cell(size: 3)
        // populate cell array row
        XCTAssertEqual(testCell.setNumberAtCellPosition(0, column: 0, number: 5), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(0, column: 1, number: 7), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(0, column: 2, number: 1), false, "Incorrect Cell incomplete value reported")
        // retrieve rows and test right values returned
        var testValues: [Int] = testCell.getValuesFromRow(0)
        XCTAssertEqual(testValues.count, 3, "Wrong size array returned")
        if testValues.count == 3 {
            XCTAssertEqual(testValues[0], 5, "Incorrect Integer returned in array[0]")
            XCTAssertEqual(testValues[1], 7, "Incorrect Integer returned in array[1]")
            XCTAssertEqual(testValues[2], 1, "Incorrect Integer returned in array[2]")
        }
        // try to retrieve a row out of range
        testValues = testCell.getValuesFromRow(-1)
        XCTAssertEqual(testValues.count, 0, "Wrong size array returned")
        testValues = testCell.getValuesFromRow(3)
        XCTAssertEqual(testValues.count, 0, "Wrong size array returned")
    }
    
    func testCellGetValuesFromColumn() {
        var testCell: Cell!
        testCell = Cell(size: 3)
        // populate cell array column
        XCTAssertEqual(testCell.setNumberAtCellPosition(0, column: 0, number: 5), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(1, column: 0, number: 2), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(2, column: 0, number: 6), false, "Incorrect Cell incomplete value reported")
        // retrieve columns and test right values returned
        var testValues: [Int] = testCell.getValuesFromColumn(0)
        XCTAssertEqual(testValues.count, 3, "Wrong size array returned")
        if testValues.count == 3 {
            XCTAssertEqual(testValues[0], 5, "Incorrect Integer returned in array[0]")
            XCTAssertEqual(testValues[1], 2, "Incorrect Integer returned in array[1]")
            XCTAssertEqual(testValues[2], 6, "Incorrect Integer returned in array[2]")
        }
        // try to retrieve a column out of range
        testValues = testCell.getValuesFromColumn(-1)
        XCTAssertEqual(testValues.count, 0, "Wrong size array returned")
        testValues = testCell.getValuesFromColumn(3)
        XCTAssertEqual(testValues.count, 0, "Wrong size array returned")
    }
    
    func testCellRandomUnUsedRoutines() {
        var testCell: Cell!
        testCell = Cell(size: 3)
        // populate cell array except row = 2, column = 0
        XCTAssertEqual(testCell.setNumberAtCellPosition(0, column: 0, number: 5), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(0, column: 1, number: 7), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(0, column: 2, number: 1), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(1, column: 0, number: 2), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(1, column: 1, number: 3), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(1, column: 2, number: 8), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(2, column: 1, number: 4), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(2, column: 2, number: 9), false, "Incorrect Cell complete value reported")
        // now test last unused number is returned
        XCTAssertEqual(testCell.getRandomUnUsedNumber(), 6, "Incorrect last unused number reported")
        // and the correct last position
        var unUsedPosn: (unUsedRow: Int, unUsedColumn: Int) = testCell.getRandomUnUsedPosition()
        XCTAssertEqual(unUsedPosn.unUsedRow, 2, "Incorrect last unused row position reported")
        XCTAssertEqual(unUsedPosn.unUsedColumn, 0, "Incorrect last unused column position reported")
        // use that position and reset another and test again
        XCTAssertEqual(testCell.setNumberAtCellPosition(2, column: 0, number: 6), true, "Incorrect Cell incomplete value reported")
        testCell.clearNumberAtCellPosition(1, column: 1)
        unUsedPosn = testCell.getRandomUnUsedPosition()
        XCTAssertEqual(unUsedPosn.unUsedRow, 1, "Incorrect last unused row position reported")
        XCTAssertEqual(unUsedPosn.unUsedColumn, 1, "Incorrect last unused column position reported")
        // complete cell and test that row = -1, column = -1 returned
        XCTAssertEqual(testCell.setNumberAtCellPosition(1, column: 1, number: 3), true, "Incorrect Cell incomplete value reported")
        unUsedPosn = testCell.getRandomUnUsedPosition()
        XCTAssertEqual(unUsedPosn.unUsedRow, -1, "Incorrect last unused row position reported")
        XCTAssertEqual(unUsedPosn.unUsedColumn, -1, "Incorrect last unused column position reported")
    }

    func testCellRandomUsedRoutines() {
        var testCell: Cell!
        testCell = Cell(size: 3)
        // with no used cells we should get row = -1, column = -1 back
        var usedPosn: (usedRow: Int, usedColumn: Int) = testCell.getRandomUsedPosition()
        XCTAssertEqual(usedPosn.usedRow, -1, "Incorrect used row position reported")
        XCTAssertEqual(usedPosn.usedColumn, -1, "Incorrect used column position reported")
        // populate cell array position row = 1, column = 2 only
        XCTAssertEqual(testCell.setNumberAtCellPosition(1, column: 2, number: 8), false, "Incorrect Cell incomplete value reported")
        usedPosn = testCell.getRandomUsedPosition()
        XCTAssertEqual(usedPosn.usedRow, 1, "Incorrect used row position reported")
        XCTAssertEqual(usedPosn.usedColumn, 2, "Incorrect used column position reported")
        // use that position and reset another and test again
        testCell.clearNumberAtCellPosition(1, column: 2)
        XCTAssertEqual(testCell.setNumberAtCellPosition(1, column: 1, number: 8), false, "Incorrect Cell incomplete value reported")
        usedPosn = testCell.getRandomUsedPosition()
        XCTAssertEqual(usedPosn.usedRow, 1, "Incorrect last unused row position reported")
        XCTAssertEqual(usedPosn.usedColumn, 1, "Incorrect last unused column position reported")
    }
    
    func testCellCopy() {
        var testCell: Cell!
        testCell = Cell(size: 3)
        // build up cell ready for copy
        // populate cell array
        XCTAssertEqual(testCell.setNumberAtCellPosition(0, column: 0, number: 5), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(0, column: 1, number: 7), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(0, column: 2, number: 1), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(1, column: 0, number: 2), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(1, column: 1, number: 3), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(1, column: 2, number: 8), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(2, column: 0, number: 6), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(2, column: 1, number: 4), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(2, column: 2, number: 9), true, "Incorrect Cell complete value reported")
        XCTAssertEqual(testCell.isCellCompleted(), true, "Incorrect Cell complete value reported")
        // now copy cell
        var copyCell: Cell!
        copyCell = testCell.copy() as! Cell
        // test cell dimensions
        XCTAssertEqual(copyCell.cellDepth(), testCell.cellDepth(), "Cell Depth not copied")
        XCTAssertEqual(copyCell.cellWidth(), testCell.cellWidth(), "Cell Width not copied")
        XCTAssertEqual(copyCell.cellDepth(), 3, "Cell Depth not correct")
        XCTAssertEqual(copyCell.cellWidth(), 3, "Cell Width not correct")
        //cell completion
        XCTAssertEqual(copyCell.isCellCompleted(), testCell.isCellCompleted(), "Cell completed value not correct")
        // test all cell values have been copied as expected
        XCTAssertEqual(copyCell.getNumberAtCellPosition(0, column: 0), testCell.getNumberAtCellPosition(0, column: 0), "Copied value is not correct for [0,0]")
        XCTAssertEqual(copyCell.getNumberAtCellPosition(0, column: 1), testCell.getNumberAtCellPosition(0, column: 1), "Copied value is not correct for [0,1]")
        XCTAssertEqual(copyCell.getNumberAtCellPosition(0, column: 2), testCell.getNumberAtCellPosition(0, column: 2), "Copied value is not correct for [0,2]")
        XCTAssertEqual(copyCell.getNumberAtCellPosition(1, column: 0), testCell.getNumberAtCellPosition(1, column: 0), "Copied value is not correct for [1,0]")
        XCTAssertEqual(copyCell.getNumberAtCellPosition(1, column: 1), testCell.getNumberAtCellPosition(1, column: 1), "Copied value is not correct for [1,1]")
        XCTAssertEqual(copyCell.getNumberAtCellPosition(1, column: 2), testCell.getNumberAtCellPosition(1, column: 2), "Copied value is not correct for [1,2]")
        XCTAssertEqual(copyCell.getNumberAtCellPosition(2, column: 0), testCell.getNumberAtCellPosition(2, column: 0), "Copied value is not correct for [2,0]")
        XCTAssertEqual(copyCell.getNumberAtCellPosition(2, column: 1), testCell.getNumberAtCellPosition(2, column: 1), "Copied value is not correct for [2,1]")
        XCTAssertEqual(copyCell.getNumberAtCellPosition(2, column: 2), testCell.getNumberAtCellPosition(2, column: 2), "Copied value is not correct for [2,2]")
        // reset a cell in the original and compare. to test it is a copied object and not a copied pointer only
        copyCell.clearNumberAtCellPosition(1, column: 1)
        XCTAssertNotEqual(copyCell.getNumberAtCellPosition(1, column: 1), testCell.getNumberAtCellPosition(1, column: 1), "Copied value is not correct for [1,1]")
        XCTAssertEqual(copyCell.getNumberAtCellPosition(1, column: 1), 0, "Copied value is not cleared as expected")
        //cell completion
        XCTAssertNotEqual(copyCell.isCellCompleted(), testCell.isCellCompleted(), "Cell completed value not correct")
    }
    
    func testCellMirrorVertically() {
        var testCell: Cell!
        testCell = Cell(size: 3)
        // populate cell array
        XCTAssertEqual(testCell.setNumberAtCellPosition(0, column: 0, number: 5), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(0, column: 1, number: 7), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(0, column: 2, number: 1), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(1, column: 0, number: 2), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(1, column: 1, number: 3), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(1, column: 2, number: 8), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(2, column: 0, number: 6), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(2, column: 1, number: 4), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(2, column: 2, number: 9), true, "Incorrect Cell complete value reported")
        XCTAssertEqual(testCell.isCellCompleted(), true, "Incorrect Cell complete value reported")
        // mirror image the cell and test
        testCell.mirrorVertically()
        XCTAssertEqual(testCell.getNumberAtCellPosition(0, column: 0), 6, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.getNumberAtCellPosition(0, column: 1), 4, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.getNumberAtCellPosition(0, column: 2), 9, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.getNumberAtCellPosition(1, column: 0), 2, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.getNumberAtCellPosition(1, column: 1), 3, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.getNumberAtCellPosition(1, column: 2), 8, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.getNumberAtCellPosition(2, column: 0), 5, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.getNumberAtCellPosition(2, column: 1), 7, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.getNumberAtCellPosition(2, column: 2), 1, "Incorrect Cell complete value reported")
        XCTAssertEqual(testCell.isCellCompleted(), true, "Incorrect Cell complete value reported")
    }
    
    func testCellMirrorHorizontally() {
        var testCell: Cell!
        testCell = Cell(size: 3)
        // populate cell array
        XCTAssertEqual(testCell.setNumberAtCellPosition(0, column: 0, number: 5), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(0, column: 1, number: 7), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(0, column: 2, number: 1), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(1, column: 0, number: 2), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(1, column: 1, number: 3), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(1, column: 2, number: 8), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(2, column: 0, number: 6), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(2, column: 1, number: 4), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(2, column: 2, number: 9), true, "Incorrect Cell complete value reported")
        XCTAssertEqual(testCell.isCellCompleted(), true, "Incorrect Cell complete value reported")
        // mirror image the cell and test
        testCell.mirrorHorizontally()
        XCTAssertEqual(testCell.getNumberAtCellPosition(0, column: 0), 1, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.getNumberAtCellPosition(0, column: 1), 7, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.getNumberAtCellPosition(0, column: 2), 5, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.getNumberAtCellPosition(1, column: 0), 8, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.getNumberAtCellPosition(1, column: 1), 3, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.getNumberAtCellPosition(1, column: 2), 2, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.getNumberAtCellPosition(2, column: 0), 9, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.getNumberAtCellPosition(2, column: 1), 4, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.getNumberAtCellPosition(2, column: 2), 6, "Incorrect Cell complete value reported")
        XCTAssertEqual(testCell.isCellCompleted(), true, "Incorrect Cell complete value reported")
    }
    
    func testGetLocationOfNumber() {
        var testCell: Cell!
        testCell = Cell(size: 3)
        // populate cell array
        XCTAssertEqual(testCell.setNumberAtCellPosition(0, column: 0, number: 5), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(0, column: 2, number: 1), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(1, column: 0, number: 2), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(1, column: 2, number: 8), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(2, column: 1, number: 4), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.setNumberAtCellPosition(2, column: 2, number: 9), false, "Incorrect Cell incomplete value reported")
        XCTAssertEqual(testCell.isCellCompleted(), false, "Incorrect Cell incomplete value reported")
        // test location of numbers used are valid
        var location: (Int, Int) = testCell.getLocationOfNumberInCell(5)
        XCTAssertEqual(location == (0, 0), true, "Incorrect Coordinate reported")
        location = testCell.getLocationOfNumberInCell(1)
        XCTAssertEqual(location == (0, 2), true, "Incorrect Coordinate reported")
        location = testCell.getLocationOfNumberInCell(2)
        XCTAssertEqual(location == (1, 0), true, "Incorrect Coordinate reported")
        location = testCell.getLocationOfNumberInCell(8)
        XCTAssertEqual(location == (1, 2), true, "Incorrect Coordinate reported")
        location = testCell.getLocationOfNumberInCell(4)
        XCTAssertEqual(location == (2, 1), true, "Incorrect Coordinate reported")
        location = testCell.getLocationOfNumberInCell(9)
        XCTAssertEqual(location == (2, 2), true, "Incorrect Coordinate reported")
        // now the missing values
        location = testCell.getLocationOfNumberInCell(3)
        XCTAssertEqual(location == (-1, -1), true, "Incorrect Coordinate reported")
        location = testCell.getLocationOfNumberInCell(6)
        XCTAssertEqual(location == (-1, -1), true, "Incorrect Coordinate reported")
        location = testCell.getLocationOfNumberInCell(7)
        XCTAssertEqual(location == (-1, -1), true, "Incorrect Coordinate reported")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
