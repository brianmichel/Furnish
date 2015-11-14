//
//  SimCtl.swift
//  Furnish
//
//  Created by Brian Michel on 11/1/15.
//  Copyright © 2015 Brian Michel. All rights reserved.
//

import Foundation

public class SimCtl {
    let listTask: ReadOnlyTaskOperation?
    init() {
        listTask = SimCtlOperations.list { (task: NSTask, data: NSMutableData?) -> Void in
            guard let
                buffer = data,
                string = String(data: buffer, encoding: NSUTF8StringEncoding) else {
                return
            }

            let response = SimCtlListResponse(output: string)

            let device = response.devices.filter({ (device) -> Bool in
                return device.os.version == "8.4" && device.name.containsString("iPhone")
            })

            print("Response: \(response) - \(device)")
        }
    }

    func start() {
        guard let task = listTask where task.executing != true else {
            return
        }

        NSOperationQueue.mainQueue().addOperation(task)
    }
}