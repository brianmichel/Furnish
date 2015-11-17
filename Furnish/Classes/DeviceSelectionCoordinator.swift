//
//  Info.swift
//  Furnish
//
//  Created by Brian Michel on 11/15/15.
//  Copyright © 2015 Brian Michel. All rights reserved.
//

import AppKit

class DeviceSelectionCoordinator: NSObject, NSPopoverDelegate {

    typealias TaskTerminationHandler = (Device, NSError?) -> Void

    private var popover: NSPopover?

    private let callback: TaskTerminationHandler

    init(selectionCallback: TaskTerminationHandler) {
        callback = selectionCallback
    }

    func present(fromView view: NSView) {
        dismiss()

        popover = deviceSelectionPopover(self)

        popover?.showRelativeToRect(view.bounds, ofView: view, preferredEdge: .MaxY)
    }

    func dismiss() {
        if let devicePopover = popover {
            devicePopover.performClose(self)
        }
    }

    private func deviceSelectionPopover(delegate: NSPopoverDelegate) -> NSPopover {
        let popover = NSPopover()
        let deviceSelectionController = DeviceListViewController { [weak self] (device) -> Void in
            self?.callback(device, nil)
            self?.dismiss()
        }

        popover.contentViewController = deviceSelectionController
        popover.contentSize = NSMakeSize(200, 100)
        popover.behavior = .Transient
        popover.delegate = delegate

        return popover
    }
}