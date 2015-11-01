//
//  Device.swift
//  Furnish
//
//  Created by Brian Michel on 11/1/15.
//  Copyright © 2015 Brian Michel. All rights reserved.
//

import Foundation

struct Device {
    struct OS {
        let type: String
        let version: String

        init?(deviceOSString: String) {
            let components = deviceOSString.componentsSeparatedByString(" ")
            guard components.count == 4 else {
                return nil
            }

            type = components[1]
            version = components[2]
        }
    }
    let name: String
    let identifier: String
    let state: String
    let os: OS

    init?(deviceString: String, osString: String?) {
        let components = deviceString.componentsSeparatedByString(" ")

        guard components.count == 8
            && !deviceString.hasPrefix("--")
            && !deviceString.hasPrefix("==")
            else {
            return nil
        }

        guard let deviceOSString = osString else {
            return nil
        }

        guard let deviceOS = OS(deviceOSString: deviceOSString) else {
            return nil
        }

        name = "\(components[4]) \(components[5])"
        identifier = Device.trimParenthesis(components[6])
        state = Device.trimParenthesis(components[7])
        os = deviceOS
    }

    static func trimParenthesis(string: String) -> String {
        return string.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "()"))
    }

    static func cleanupOSString(string: String) -> String {
        return string.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "- "))
    }
}