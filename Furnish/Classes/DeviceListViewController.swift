//
//  DeviceListViewController.swift
//  Furnish
//
//  Created by Brian Michel on 11/15/15.
//  Copyright © 2015 Brian Michel. All rights reserved.
//

import AppKit

class DeviceListViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    struct Constants {
        static let DeviceCellIdentifier = "DeviceListCell"
    }

    typealias DeviceSelectionCallback = (Device) -> Void

    let callback: DeviceSelectionCallback
    var devices: [Device]?

    @IBOutlet weak var tableView: NSTableView!
    
    override var nibName: String {
        return "DeviceListView"
    }

    init?(selectionCallback: DeviceSelectionCallback) {
        callback = selectionCallback
        super.init(nibName: "DeviceListView", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = NSNib(nibNamed: Constants.DeviceCellIdentifier, bundle: nil)
        tableView.registerNib(nib, forIdentifier: Constants.DeviceCellIdentifier)

        let task = SimCtlOperations.list { [weak self] (task, data) -> Void in
            guard let
                buffer = data,
                string = String(data: buffer, encoding: NSUTF8StringEncoding) else {
                    return
            }

            let response = SimCtlListResponse(output: string)

            self?.devices = response.devices

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self?.tableView.reloadData()
            })
        }

        NSOperationQueue.mainQueue().addOperation(task)
    }

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeViewWithIdentifier(Constants.DeviceCellIdentifier, owner: self) as? DeviceListCell,
            availableDevices = devices else {
            return nil
        }

        let device = availableDevices[row]
        cell.deviceName.stringValue = "\(device.name) (\(device.os.type) \(device.os.version))"

        return cell
    }

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return self.devices?.count ?? 0
    }

    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 50.0
    }

    func tableView(tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        guard let availableDevices = devices else {
            return false
        }

        let selectedDevice = availableDevices[row]

        callback(selectedDevice)

        return true
    }
}