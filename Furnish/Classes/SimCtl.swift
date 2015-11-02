//
//  SimCtl.swift
//  Furnish
//
//  Created by Brian Michel on 11/1/15.
//  Copyright © 2015 Brian Michel. All rights reserved.
//

import Foundation

public class SimCtl {
    let outputPipe = NSPipe()
    var baseTask = NSTask()

    var temporaryOutputBuffer: NSMutableData?

    init() {
        baseTask.standardOutput = outputPipe
        baseTask.launchPath = "/usr/bin/xcrun"
        baseTask.arguments = ["simctl", "list"]

        self.outputPipe.fileHandleForReading.readabilityHandler = { (handle: NSFileHandle) -> Void in
            self.appendDataToTemporaryBuffer(handle.availableData)
        }

        self.baseTask.terminationHandler = { (task: NSTask) -> Void in
            if let buffer = self.temporaryOutputBuffer {
                guard let string = String(data: buffer, encoding: NSUTF8StringEncoding) else {
                    return;
                }

                let response = SimCtlListResponse(output: string);

                let device = response.devices.filter({ (device) -> Bool in
                    return device.os.version == "8.4" && device.name.containsString("iPhone")
                })

                print("Found device(s): \(device)")

                print("Response: \(response)")
            }
        }
    }

    func start() {
        guard !baseTask.running else { return }

        baseTask.launch()
    }

    func appendDataToTemporaryBuffer(data: NSData) {
        let buffer = self.temporaryOutputBuffer ?? NSMutableData()

        buffer.appendData(data)

        self.temporaryOutputBuffer = buffer
    }
}