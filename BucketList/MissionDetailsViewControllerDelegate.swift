//
//  MissionDetailsViewControllerDelegate.swift
//  BucketList
//
//  Created by Ketul Patel on 6/1/15.
//  Copyright (c) 2015 Ketul Patel. All rights reserved.
//

import Foundation
protocol MissionDetailsViewControllerDelegate: class {
    func missionDetailsViewController(controller: MissionDetailsViewController, didFinishAddingMission mission: String)
    func missionDetailsViewController(controller: MissionDetailsViewController, didFinishEditingMission mission: [String: String])
}