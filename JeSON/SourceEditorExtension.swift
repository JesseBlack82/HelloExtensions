//
//  SourceEditorExtension.swift
//  JeSON
//
//  Created by Jesse Black on 8/26/16.
//  Copyright © 2016 Jesse Black. All rights reserved.
//

import Foundation
import XcodeKit

enum JeSONInvocation: String {
    case Prettify = "com.jesseblack.HelloWorldProject.JeSON.Prettify"
    case Minify = "com.jesseblack.HelloWorldProject.JeSON.Minify"
}

class SourceEditorExtension: NSObject, XCSourceEditorExtension {
    
    /*
    func extensionDidFinishLaunching() {
        // If your extension needs to do any work at launch, implement this optional method.
    }
    */
    
    var commandDefinitions: [[XCSourceEditorCommandDefinitionKey: Any]] {
        return [
            [
                .classNameKey: "JeSON.SourceEditorCommand",
                .identifierKey: JeSONInvocation.Minify.rawValue,
                .nameKey: "Minify"
            ],
            [
                .classNameKey: "JeSON.SourceEditorCommand",
                .identifierKey: JeSONInvocation.Prettify.rawValue,
                .nameKey: "Prettify"
            ],
        ]
    }
    
}
