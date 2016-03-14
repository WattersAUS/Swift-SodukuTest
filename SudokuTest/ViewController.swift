//
//  ViewController.swift
//  SudokuTest
//
//  Created by Graham Watson on 06/03/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var outputBoardMsgsTextField: UITextView!
    
    var board: SudokuBoard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        board = SudokuBoard()
        board.buildBoard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func resetBoardButtonPressed(sender: UIButton) {
        board.clearBoard()
        board.buildBoard()
        let boardDump: String = board.dumpBoard()
        outputBoardMsgsTextField.text = boardDump
    }
    
}

