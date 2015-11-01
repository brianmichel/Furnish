//
//  SimCtlListResponse.swift
//  Furnish
//
//  Created by Brian Michel on 11/1/15.
//  Copyright © 2015 Brian Michel. All rights reserved.
//

import Foundation

class SimCtlListResponse {
    enum ListResponseParseMode: Int {
        case Unknown = -1
        case DeviceTypes
        case Runtimes
        case Devices
        case Finished
    }

    var parseMode: ListResponseParseMode = .Unknown
    var types: Array<String> = [String]()
    var runtimes: Array<Runtime> = [Runtime]()
    var devices: Array<Device> = [Device]()

    var lastDeviceBucket: String?

    init(output: Array<String>) {
        processOutput(output)
    }

    private func processOutput(output: Array<String>) {
        for string in output {
            switch string {
            case "== Device Types ==":
                parseMode = .DeviceTypes
            case "== Runtimes ==":
                parseMode = .Runtimes
            case "== Devices ==":
                parseMode = .Devices
            default:
                if parseMode == .Devices {
                    lastDeviceBucket = string.hasPrefix("--") ? string : lastDeviceBucket
                }

                appendElement(string,
                    mode: parseMode,
                    deviceOS: lastDeviceBucket)
            }
        }
        parseMode = .Finished
    }

    private func appendElement(element: String,
        mode: ListResponseParseMode,
        deviceOS: String?) {
        guard mode.rawValue >= ListResponseParseMode.DeviceTypes.rawValue
            && mode.rawValue < ListResponseParseMode.Finished.rawValue else {
            return
        }

        switch mode {
        case .DeviceTypes:
            types.append(element)
        case .Runtimes:
            if let runtime = Runtime(runtimeString: element) {
                runtimes.append(runtime)
            }
        case .Devices:
            if let device = Device(deviceString: element, osString: deviceOS) {
                devices.append(device)
            }
        case .Finished: fallthrough
        case .Unknown: break
        }
    }
}
