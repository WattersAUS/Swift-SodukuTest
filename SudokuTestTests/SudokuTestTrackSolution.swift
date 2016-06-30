//
//  SudokuTestTrackSolution.swift
//  SudokuTest
//
//  Created by Graham Watson on 11/05/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import XCTest
@testable import SudokuTest

class SudokuTestTrackSolution: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSolutionInitialSizeOverriddenCorrectly() {
        var testSize: (row: Int, column: Int, cellRow: Int, cellColumn: Int) = (-1, -1, -1, -1)
        var testTracker: TrackSolution!
        testTracker = TrackSolution()
        testSize = testTracker.getBoardSize()
        // we should see a size == 3 for width
        XCTAssertEqual(testSize.row, 3, "Incorrect initial Board Rows reported")
        XCTAssertEqual(testSize.column, 3, "Incorrect initial Board Columns reported")
        XCTAssertEqual(testSize.cellRow, 3, "Incorrect initial Cell Rows reported")
        XCTAssertEqual(testSize.cellColumn, 3, "Incorrect initial Cell Columns reported")
    }
    
    func testSolutionInitialSizeSetCorrectly() {
        var testSize: (row: Int, column: Int, cellRow: Int, cellColumn: Int) = (-1, -1, -1, -1)
        var testTracker: TrackSolution!
        testTracker = TrackSolution(row: 7, column: 5, cellRow: 6, cellColumn: 4)
        testSize = testTracker.getBoardSize()
        // we should see sizes reported as added
        XCTAssertEqual(testSize.row, 7, "Incorrect initial Board Rows reported")
        XCTAssertEqual(testSize.column, 5, "Incorrect initial Board Columns reported")
        XCTAssertEqual(testSize.cellRow, 6, "Incorrect initial Cell Rows reported")
        XCTAssertEqual(testSize.cellColumn, 4, "Incorrect initial Cell Columns reported")
    }

    func testSolutionSizeReturnedCorrectly() {
        var testTracker: TrackSolution!
        testTracker = TrackSolution()
        // should be empty
        XCTAssertEqual(testTracker.countOfUserSolution(), 0, "Incorrect initial Solution Size reported")
        testTracker.addCoordinate((0, column: 1, cellRow: 2, cellColumn: 3))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
