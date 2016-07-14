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
    @IBOutlet weak var useHighlight: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // get the current state of the prefs
        self.characterSet.selectedSegmentIndex = (delegate?.characterSetInUse)!
        self.setDifficulty.selectedSegmentIndex = (delegate?.difficultySet)!
        self.gameMode.selectedSegmentIndex = (delegate?.gameModeInUse)!
        self.useSound.on = (delegate?.soundOn)!
        self.useHighlight.on = (delegate?.highlightOn)!
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
        delegate?.difficultySet = self.setDifficulty.selectedSegmentIndex
        delegate?.gameModeInUse = self.gameMode.selectedSegmentIndex
        delegate?.soundOn = self.useSound.on
        delegate?.highlightOn = self.useHighlight.on
        if delegate?.characterSetInUse != self.characterSet.selectedSegmentIndex {
            delegate?.characterSetInUse = self.characterSet.selectedSegmentIndex
            for redrawFunction: (Void) -> () in (delegate?.drawFunctions)! {
                redrawFunction()
            }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
