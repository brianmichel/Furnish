//
//  AppInstallationCoordinator.swift
//  Furnish
//
//  Created by Brian Michel on 11/15/15.
//  Copyright © 2015 Brian Michel. All rights reserved.
//

import AppKit

class AppInstallationCoordinator {

    typealias InstallationCompletionCallback = (NSTask, NSError?) -> Void

    private let device: Device

    private var callback: InstallationCompletionCallback?

    private var openPanel: NSOpenPanel?

    init(device: Device) {
        self.device = device
    }

    func present(callback: InstallationCompletionCallback) {
        dismiss()

        self.callback = callback

        openPanel = openPanelForSelection()

        openPanel?.beginWithCompletionHandler({ [weak self] (state) -> Void in
            switch state {
            case NSFileHandlingPanelOKButton:
                guard let panel = self?.openPanel else {
                    return
                }

                self?.installFilePackage(panel.URL)
            case NSFileHandlingPanelCancelButton: fallthrough
            default: break
            }
        })
    }

    func dismiss() {
        if let panel = openPanel {
            panel.cancel(self)
        }
    }

    private func openPanelForSelection() -> NSOpenPanel {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.allowedFileTypes = ["app"]
        openPanel.treatsFilePackagesAsDirectories = false
        openPanel.title = NSLocalizedString("Select an app", comment: "")
        openPanel.message = NSLocalizedString("Select an app to install", comment: "")

        return openPanel
    }

    private func installFilePackage(url: NSURL?) -> Bool {
        guard let absoluteFilePath = url?.relativePath where validateFilePackage(url) else {
            return false
        }

        let install = SimCtlOperations.install(path: absoluteFilePath, handler: { [weak self] (task, data) -> Void in
            if let callback = self?.callback {
                callback(task, nil)
            }
        })

        NSOperationQueue.mainQueue().addOperation(install)

        return true
    }

    private func validateFilePackage(url: NSURL?) -> Bool {
        guard let fileURL = url else {
            return false
        }

        // more validation here
        return true
    }
}