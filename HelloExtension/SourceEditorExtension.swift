//
//  SourceEditorExtension.swift
//  HelloExtension
//
//  Created by Jesse Black on 8/25/16.
//  Copyright © 2016 Jesse Black. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorExtension: NSObject, XCSourceEditorExtension {
    
    //*
    func extensionDidFinishLaunching() {
        // If your extension needs to do any work at launch, implement this optional method.
    }
    //*/
    
    ///*
    var commandDefinitions: [[XCSourceEditorCommandDefinitionKey: Any]] {
        // If your extension needs to return a collection of command definitions that differs from those in its Info.plist, implement this optional property getter.
        return [
            [
                .classNameKey: "Hello.SourceEditorCommand",
                .identifierKey: "com.jesseblack.HelloWorldProject.HelloExtension.HelloWorld",
                .nameKey: "World"
            ]
        ]
    }
    //*/
    
}
