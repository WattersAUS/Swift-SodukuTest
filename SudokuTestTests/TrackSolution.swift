//
//  TrackSolution.swift
//  SudokuTest
//
//  Created by Graham Watson on 11/05/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import XCTest
@testable import SudokuTest

class TrackSolution: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCellInitialSizeOverriddenCorrectly() {
        var testSize: (maxBoardRows: Int, maxBoardColumns: Int, maxCellRows: Int, maxCellColumns: Int) = (-1, -1, -1, -1)
        var testTracker: TrackSolution!
        testTracker = TrackSolution()
        // we should see board sizes == 3
        testSize = testTracker.getBoardSize()
    }
    
    func testCellInitialSizeSetCorrectly() {
        var testBoardSize: (maxBoardRows: Int, maxBoardColumns: Int, maxCellRows: Int, maxCellColumns: Int) = (-1, -1, -1, -1)
        var testTracker: TrackSolution!
        testTracker = TrackSolution()
        
        
        
        
        
        var boardSize: (maxBoardRows: Int, maxBoardColumns: Int, maxCellRows: Int, maxCellColumns: Int) = (-1, -1, -1, -1)

        // we should see a size == 3 for width
        XCTAssertEqual(testCell.cellDepth(), 3, "Incorrect initial Cell depth reported")
        XCTAssertEqual(testCell.cellWidth(), 3, "Incorrect initial Cell width reported")
        XCTAssertNotEqual(testCell.isCellCompleted(), true, "Incorrect initial Cell state reported")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
