//
//  AppDelegate.swift
//  Hablador
//
//  Created by Leonardo Guzman on 2/12/17.
//  Copyright © 2017 Leonardo Guzman. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var mainWindowController : MainWindowController?;


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let mainWindowController = MainWindowController();
        mainWindowController.showWindow(self);
        
        self.mainWindowController = mainWindowController;
        
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

