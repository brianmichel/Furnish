//
//  DeviceListCellView.swift
//  Furnish
//
//  Created by Brian Michel on 11/15/15.
//  Copyright © 2015 Brian Michel. All rights reserved.
//

import AppKit

class DeviceListCell: NSView {
    @IBOutlet weak var deviceName: NSTextField!

    var device: Device? {
        didSet {
            guard let actualDevice = device else {
                return
            }

            deviceName.stringValue = "\(actualDevice.name) (\(actualDevice.os.type) \(actualDevice.os.version))"
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}