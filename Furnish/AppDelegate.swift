//
//  AppDelegate.swift
//  Furnish
//
//  Created by Brian Michel on 11/1/15.
//  Copyright © 2015 Brian Michel. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        NSAppearance.setCurrentAppearance(NSAppearance(named: NSAppearanceNameVibrantDark))

        window.titleVisibility = .Hidden
        window.titlebarAppearsTransparent = true

        if let view = window.contentView as? NSVisualEffectView {
            view.appearance = NSAppearance.currentAppearance()
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }


}

