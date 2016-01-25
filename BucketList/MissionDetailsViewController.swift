//
//  MissionDetailsViewController.swift
//  BucketList
//
//  Created by Ketul Patel on 6/1/15.
//  Copyright (c) 2015 Ketul Patel. All rights reserved.
//

import UIKit
// MissionDetailsViewController handles adding/editing a particular mission
class MissionDetailsViewController: UITableViewController {
    // we will have a delegate for the cancelButton so that we can delegate when the cancelButtonPressed action occurs
    weak var cancelButtonDelegate: CancelButtonDelegate?
    // we will have a delegate so that we can always delegate back when we want to dismiss the view or do some action with the information entered in the view
    weak var delegate: MissionDetailsViewControllerDelegate?
    var missionToEdit: [String: String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        // as soon as the view loads set the text of the input if missionToEdit exists
        editMissionTextInput.text = missionToEdit?["objective"]
        // Do any additional setup after loading the view, typically from a nib.
    }
    // when the cancel button is pressed delegate to the cancelButtonDelegate
    @IBAction func cancelBarButtonPressed(sender: UIBarButtonItem) {
        cancelButtonDelegate?.cancelButtonPressedFrom(self)
    }
    // when the done button is pressed delegate to the delegate that will handle edits and adds
    @IBAction func doneBarButtonPressed(sender: AnyObject) {
        if var mission = missionToEdit {
            mission["objective"] = newMissionTextField.text!
            delegate?.missionDetailsViewController(self, didFinishEditingMission: mission)
        } else {
            delegate?.missionDetailsViewController(self, didFinishAddingMission: newMissionTextField.text!)
        }
    }
    @IBOutlet weak var newMissionTextField: UITextField!
    @IBOutlet weak var editMissionTextInput: UITextField!
}
