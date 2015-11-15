//
//  ApplicationCoordinator.swift
//  Furnish
//
//  Created by Brian Michel on 11/14/15.
//  Copyright © 2015 Brian Michel. All rights reserved.
//

import AppKit

final class ApplicationCoordinator: NSObject {

    let operationQueue: NSOperationQueue = {
        let queue = NSOperationQueue()
        queue.name = "com.bsm.furnish.application"

        return queue
    }()

    var simulatorPopover: NSPopover?
    lazy var deviceSelectionCoordinator: DeviceSelectionCoordinator = {
        return DeviceSelectionCoordinator(selectionCallback: { (device, error) -> Void in
            print("Selected device: \(device)")
            let bootTask = InstrumentsOperations.boot(device.identifier, handler: nil)
            self.operationQueue.addOperation(bootTask)
            self.appInstallationCoordinator = AppInstallationCoordinator(device: device)
        })
    }()
    var appInstallationCoordinator: AppInstallationCoordinator?

    @IBAction func launchSimulator(button: NSButton) {
        deviceSelectionCoordinator.present(fromView: button)
    }

    @IBAction func installApplication(button: NSButton) {
        guard let installationCoordintoar = appInstallationCoordinator else {
            return
        }

        installationCoordintoar.present()
    }
}