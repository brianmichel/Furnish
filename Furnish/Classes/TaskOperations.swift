//
//  TaskOperation.swift
//  Furnish
//
//  Created by Brian Michel on 11/1/15.
//  Copyright © 2015 Brian Michel. All rights reserved.
//

import Foundation

typealias TaskTerminationHandler = ((NSTask, NSMutableData?) -> Void)?

class ReadOnlyTaskOperation: NSOperation {

    let output = NSPipe()
    let task = NSTask()

    let outputBuffer = NSMutableData()

    let terminationHandler: TaskTerminationHandler

    let semaphore = dispatch_semaphore_create(0)

    init(path: String, args: [String]? = [], handler: TaskTerminationHandler) {
        task.standardOutput = output
        task.launchPath = path
        task.arguments = args ?? []

        terminationHandler = handler

        super.init()

        output.fileHandleForReading.readabilityHandler = { [weak self]
            (handle) -> Void in
            self?.outputBuffer.appendData(handle.availableData)
        }
    }

    override func main() {
        guard !task.running else { return }

        task.terminationHandler = { [weak self]
            (finishedTask) -> Void in

            guard let handler = self?.terminationHandler,
                let semaphore = self?.semaphore else {
                return
            }

            defer {
                dispatch_semaphore_signal(semaphore)
            }

            handler(finishedTask, self?.outputBuffer)
        }

        task.launch()
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
    }

    override func cancel() {
        dispatch_semaphore_signal(semaphore)
    }
}