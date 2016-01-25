//
//  TaskModel.swift
//  BucketList
//
//  Created by Ketul Patel on 1/14/16.
//  Copyright © 2016 Ketul Patel. All rights reserved.
//

import Foundation

class TaskModel {
    func getAllTasks() -> NSArray? {
        // Specify the url that we will be sending the GET Request to
        if let urlToReq = NSURL(string: "http://localhost:8000/tasks") {
            // Request the url and store the data in "packagedData"
            if let packagedData = NSData(contentsOfURL: urlToReq) {
                // unpackage the data using our parseJSON function
                if let unpackagedData = parseJSON(packagedData) {
                    // Do whatever you want here with the data
                    // data - soundcloud auth token & other data
                    // present the view controller
                    return unpackagedData
                } else {
                    // something went wrong while unpackaging the data
                    print("Error unpackaging data")
                }
            } else {
                // something went wrong receiving the data from the request
                print("Error requesting data")
            }
        } else {
            // something went wrong while creating the NSURL
            print("Error creating NSURL")
        }
        return nil
    }
    func addTaskWithObjective(objective: String, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        if let urlToReq = NSURL(string: "http://localhost:8000/tasks") {
            let request = NSMutableURLRequest(URL: urlToReq)
            request.HTTPMethod = "POST"
            let bodyData = "objective=\(objective)"
            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
            NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: completionHandler).resume()
        }
    }
    func editTaskWithCreatedAt(createdAt: String, objective: String, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        if let urlToReq = NSURL(string: "http://localhost:8000/tasks/edit") {
            let request = NSMutableURLRequest(URL: urlToReq)
            request.HTTPMethod = "POST"
            let bodyData = "objective=\(objective)&createdAt=\(createdAt)"
            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
            NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: completionHandler).resume()
        }
    }
    func removeTaskWithCreatedAt(createdAt: String, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        if let urlToReq = NSURL(string: "http://localhost:8000/tasks/remove") {
            let request = NSMutableURLRequest(URL: urlToReq)
            request.HTTPMethod = "POST"
            let bodyData = "createdAt=\(createdAt)"
            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
            NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: completionHandler).resume()
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
