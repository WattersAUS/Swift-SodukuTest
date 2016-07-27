//
//  Preferences.swift
//  SudokuTest
//
//  Created by Graham Watson on 10/07/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import UIKit

class Preferences: UIViewController {
    
    weak var delegate: PreferencesDelegate?

    @IBOutlet weak var characterSet: UISegmentedControl!
    @IBOutlet weak var setDifficulty: UISegmentedControl!
    @IBOutlet weak var gameMode: UISegmentedControl!
    @IBOutlet weak var useSound: UISwitch!
    @IBOutlet weak var allowHints: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // get the current state of the prefs
        self.characterSet.selectedSegmentIndex = (delegate?.characterSetInUse)!
        // remember the difficulty is offset from '3'
        switch (delegate?.difficultySet)! {
            case 7:
                self.setDifficulty.selectedSegmentIndex = 2
                break
            case 5:
                self.setDifficulty.selectedSegmentIndex = 1
                break
            case 3:
                self.setDifficulty.selectedSegmentIndex = 0
                break
            default:
                self.setDifficulty.selectedSegmentIndex = 0
                break
        }
        self.gameMode.selectedSegmentIndex = (delegate?.gameModeInUse)!
        self.useSound.on = (delegate?.soundOn)!
        self.allowHints.on = (delegate?.hintsOn)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func dismissDialog(sender: UIButton) {
        // now go call the function to redraw the board in the background if needed
        // remember the difficulty is offset from '3'
        switch (self.setDifficulty.selectedSegmentIndex) {
        case 2:
            delegate?.difficultySet = 7
            break
        case 1:
            delegate?.difficultySet = 5
            break
        case 0:
            delegate?.difficultySet = 3
            break
        default:
            delegate?.difficultySet = 3
            break
        }
        delegate?.gameModeInUse = self.gameMode.selectedSegmentIndex
        delegate?.soundOn = self.useSound.on
        delegate?.hintsOn = self.allowHints.on
        if delegate?.characterSetInUse != self.characterSet.selectedSegmentIndex {
            delegate?.characterSetInUse = self.characterSet.selectedSegmentIndex
            for redrawFunction: (Void) -> () in (delegate?.drawFunctions)! {
                redrawFunction()
            }
        }
        for saveFunction: (Void) -> () in (delegate?.saveFunctions)! {
            saveFunction()
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
