//
//  SourceEditorCommand.swift
//  HelloExtension
//
//  Created by Jesse Black on 8/25/16.
//  Copyright © 2016 Jesse Black. All rights reserved.
//

import Foundation
import XcodeKit

enum HelloInvocation: String {
    case Atlanta = "com.jesseblack.HelloWorldProject.HelloExtension.HelloAtlanta"
    case World = "com.jesseblack.HelloWorldProject.HelloExtension.HelloWorld"
}

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        
        guard let helloInvocation = HelloInvocation(rawValue: invocation.commandIdentifier) else {
            completionHandler(nil)
            return
        }
        
        let buffer = invocation.buffer
        
        switch helloInvocation {
        case .Atlanta:
            buffer.lines.insert("//  Hello Atlanta", at: 0)
        case .World:
            buffer.lines.insert("//  Hello World!", at: 0)
        }
        
        completionHandler(nil)
    }
    
}
