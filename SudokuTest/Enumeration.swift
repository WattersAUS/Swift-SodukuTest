//
//  Enumeration.swift
//  SudokuTest
//
//  Created by Graham Watson on 11/07/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

//
// states we'l use during display/game
//
enum imgStates: Int {
    case Origin = 0
    case Selected = 1
    case Delete = 2
    case Inactive = 3
    case Highlight = 4
}

//
// images sets we have available
//
enum imageSet: Int {
    case Default = 0
    case Greek = 1
    case Images = 2
}

//
// difficulty
//
enum gameDiff: Int {
    case Easy = 3
    case Medium = 5
    case Hard = 6
}

//
// game modes
//
enum gameMode: Int {
    case Normal = 0
    case Challenge = 1
    case Timer = 2
}

