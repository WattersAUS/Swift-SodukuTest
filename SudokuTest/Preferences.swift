//
//  Preferences.swift
//  SudokuTest
//
//  Created by Graham Watson on 10/07/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import UIKit

class Preferences: UIViewController {
    
    weak var prefs: PreferencesDelegate?
    weak var state: GameStateDelegate?

    @IBOutlet weak var characterSet: UISegmentedControl!
    @IBOutlet weak var setDifficulty: UISegmentedControl!
    @IBOutlet weak var gameMode: UISegmentedControl!
    @IBOutlet weak var useSound: UISwitch!
    @IBOutlet weak var allowHints: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // get the current state of the prefs
        self.characterSet.selectedSegmentIndex = (prefs?.characterSetInUse)!
        self.setDifficulty.selectedSegmentIndex = (prefs?.difficultySet)!
        self.gameMode.selectedSegmentIndex = (prefs?.gameModeInUse)!
        self.useSound.on = (prefs?.soundOn)!
        self.allowHints.on = (prefs?.hintsOn)!
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
        prefs?.difficultySet = self.setDifficulty.selectedSegmentIndex
        prefs?.gameModeInUse = self.gameMode.selectedSegmentIndex
        prefs?.soundOn = self.useSound.on
        prefs?.hintsOn = self.allowHints.on
        if prefs?.characterSetInUse != self.characterSet.selectedSegmentIndex {
            prefs?.characterSetInUse = self.characterSet.selectedSegmentIndex
            for redrawFunction: (Void) -> () in (prefs?.drawFunctions)! {
                redrawFunction()
            }
        }
        for saveFunction: (Void) -> () in (prefs?.saveFunctions)! {
            saveFunction()
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
