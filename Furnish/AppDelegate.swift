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

    let sim_ctl = SimCtl()

    let queue = NSOperationQueue()

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        sim_ctl.start()

//        let task = SimCtlOperations.install(path: "~/Library/Developer/Xcode/DerivedData/Orangina-fxlmalmfvzgjlsbadupjkptfhtmx/Build/Products/Debug-iphonesimulator/Orangina.app") { (task, data: NSMutableData?) -> Void in
//        }
//
//        queue.addOperation(task)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

