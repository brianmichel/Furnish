//
//  ApplicationCoordinator.swift
//  Furnish
//
//  Created by Brian Michel on 11/14/15.
//  Copyright © 2015 Brian Michel. All rights reserved.
//

import AppKit

final class ApplicationCoordinator: NSObject {

    private let queue = NSOperationQueue()

    private lazy var deviceSelectionCoordinator: DeviceSelectionCoordinator = {
        return DeviceSelectionCoordinator(selectionCallback: { (device, error) -> Void in
            let bootTask = InstrumentsOperations.boot(device.identifier, handler: nil)
            self.queue.addOperation(bootTask)
            self.appInstallationCoordinator = AppInstallationCoordinator(device: device)
        })
    }()
    
    private var appInstallationCoordinator: AppInstallationCoordinator?

    @IBAction func launchSimulator(button: NSButton) {
        deviceSelectionCoordinator.present(fromView: button)
    }

    @IBAction func installApplication(button: NSButton) {
        guard let installationCoordinator = appInstallationCoordinator else {
            return
        }

        installationCoordinator.present { [weak self] (task, error) -> Void in
            guard let zelf = self else {
                return
            }

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let _ = error {
                    zelf.displayBanner("Uh oh", subtitle: "Something went wrong installing the app.")
                }
                else {
                    zelf.displayBanner("Installation Complete", subtitle: "The application was successfully installed.")
                }
            })
        }
    }

    private func displayBanner(title: String, subtitle: String) {
        let userNotification = NSUserNotification()
        userNotification.title = title
        userNotification.subtitle = subtitle

        NSUserNotificationCenter.defaultUserNotificationCenter().scheduleNotification(userNotification)
    }
}