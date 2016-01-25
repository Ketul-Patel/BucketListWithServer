//
//  ViewController.swift
//  BucketList
//
//  Created by Ketul Patel on 6/1/15.
//  Copyright (c) 2015 Ketul Patel. All rights reserved.
//

import UIKit

// BucketListViewController that inherits from UITableViewController and conforms to CancelButtonDelegate and MissionDetailsViewControllerDelegate
class BucketListViewController: UITableViewController, CancelButtonDelegate, MissionDetailsViewControllerDelegate {
    // keep track of all of the missions using our makeshift database
    var taskModel = TaskModel()
    var tasks: NSArray?
    
    // boolean property to determine if we are editing or not
    var isEditing: Bool?
    override func viewDidLoad() {
        tasks = taskModel.getAllTasks()
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // this is the UITableViewController method that populates each cell with the necessary information
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // dequeue the cell from our storyboard so that we can populate it
        let dequeued: AnyObject = tableView.dequeueReusableCellWithIdentifier("MissionCell", forIndexPath: indexPath)
        // since the method returns an AnyObject, we have to cast it to UITableViewCell type
        let cell = dequeued as! UITableViewCell
        // bring out the task that corresponds to indexPath.row and typecast as Dictionary<String, String>
        let task = tasks![indexPath.row] as! [String: String]
        // if the cell has a text label, set it to the task objective that is corresponding to the row in array
        cell.textLabel?.text = task["objective"]
        // return cell so that Table View knows what to draw in each row
        return cell
    }
    
    // this is the UITableViewController method that tells how many rows there are going to be
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks!.count
    }
    
//    // this is the UITableViewController method that helps us do the swipe to delete functionality
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let taskToDelete = tasks![indexPath.row] as! [String:String]
        taskModel.removeTaskWithCreatedAt(taskToDelete["createdAt"]!) {
            (data, response, error) in
            dispatch_async(dispatch_get_main_queue()) {
                if let updatedTasks = data {
                    self.tasks = self.parseJSON(updatedTasks)
                    self.tableView.reloadData()
                }
            }
        }

    }
    
    // action for when the add button is pressed. First set the boolean to tell whether we are editing and then perform the segue
    @IBAction func addMissionBarButtonPressed(sender: UIBarButtonItem) {
        // telling ourselves taht we are not editing
        isEditing = false
        // manually trigger segue
        performSegueWithIdentifier("DetailsSegue", sender: nil)
    }
    // this is the UITableViewController method that handles when the accessory button is tapped for a specific row. First set the boolean to say that we are editing not adding and then perform the segue
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        isEditing = true
        performSegueWithIdentifier("DetailsSegue", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
    
    // Delegate method cancelButtonPressedFrom for the cancelButtonDelegate. This is how we access this class from inside the missionDetailsViewController in order to dismiss the view when the cancel button is pressed.
    func cancelButtonPressedFrom(controller: UIViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // override the built-in function that runs right before segueing
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailsSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! MissionDetailsViewController
            controller.cancelButtonDelegate = self
            controller.delegate = self
            // if we are editing then set the controller(missionDetailsViewController)'s missionToEdit to be the mission that was clicked
            if isEditing! {
                if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                    let task = tasks![indexPath.row] as! [String: String]
                    controller.missionToEdit = task
                }
            }
        }
    }

    // missionDetailsViewControllerDelegate method to handle having finished adding the mission
    func missionDetailsViewController(controller: MissionDetailsViewController, didFinishAddingMission mission: String) {
        dismissViewControllerAnimated(true, completion: nil)
        taskModel.addTaskWithObjective(mission) {
            (data, response, error) in
            dispatch_async(dispatch_get_main_queue()) {
                if let updatedTasks = data {
                    self.tasks = self.parseJSON(updatedTasks)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // missionDetailsViewControllerDelegate method to handle having finished editing the mission
    func missionDetailsViewController(controller: MissionDetailsViewController, didFinishEditingMission mission: [String: String]) {
        dismissViewControllerAnimated(true, completion: nil)
        taskModel.editTaskWithCreatedAt(mission["createdAt"]!, objective: mission["objective"]!) {
            (data, response, error) in
            dispatch_async(dispatch_get_main_queue()) {
                if let updatedTasks = data {
                    self.tasks = self.parseJSON(updatedTasks)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func parseJSON(inputData: NSData) -> NSArray? {
        do {
            let arrOfObjects = try NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers)
            return arrOfObjects as? NSArray
        } catch let error as NSError {
            print(error)
            return nil
        }
    }
}

