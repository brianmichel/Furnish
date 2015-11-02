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

        let op = ReadOnlyTaskOperation(path: "/usr/bin/say", args: ["-v", "vicki", "hello, how are you?"], handler: { (task, buffer) -> Void in
            print("Task \(task)")

            if let data = buffer {
                let string = String(data: data, encoding: NSUTF8StringEncoding)
                print("buffer:\n\(string!)")
            }
        })

        queue.addOperation(op)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

