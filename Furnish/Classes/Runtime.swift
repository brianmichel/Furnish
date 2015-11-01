//
//  Runtime.swift
//  Furnish
//
//  Created by Brian Michel on 11/1/15.
//  Copyright © 2015 Brian Michel. All rights reserved.
//

import Foundation

public struct Runtime {
    enum Type: Int {
        case Unknown = -1
        case iOS
        case tvOS
        case watchOS

        static func stringToType(string: String) -> Type {
            switch string {
            case "iOS":
                return .iOS
            case "tvOS" :
                return .tvOS
            case "watchOS":
                return .watchOS
            default:
                return .Unknown
            }
        }
    }

    let type: Type
    let version: String
    let identifier: String

    init?(runtimeString: String) {
        let components = runtimeString.componentsSeparatedByString(" ")

        guard components.count == 6 else {
            return nil
        }

        type = Type.stringToType(components[0])
        version = components[1]
        identifier = Runtime.cleanupIdentifer(components[5])
    }

    static func cleanupIdentifer(identifierString: String) -> String {
        return identifierString.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "()"))
    }
}