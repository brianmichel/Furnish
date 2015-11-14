//
//  SimCtlOperations.swift
//  Furnish
//
//  Created by Brian Michel on 11/14/15.
//  Copyright © 2015 Brian Michel. All rights reserved.
//

import Foundation

struct SimCtlOperations {
    static let xcrunPath = "/usr/bin/xcrun"
    static let arguments = ["simctl"]

    static func list(handler: TaskTerminationHandler) -> ReadOnlyTaskOperation {
        return ReadOnlyTaskOperation(
            path: xcrunPath,
            args: arguments + ["list"],
            handler: handler
        )
    }

    static func install(udid: String = "booted", path: String, handler: TaskTerminationHandler) -> ReadOnlyTaskOperation {
        return ReadOnlyTaskOperation(
            path: xcrunPath,
            args: arguments + ["install", udid, path],
            handler: handler
        )
    }
}