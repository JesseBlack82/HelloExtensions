//
//  SourceEditorCommand.swift
//  JeSON
//
//  Created by Jesse Black on 8/26/16.
//  Copyright © 2016 Jesse Black. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        guard let jeSONInvocation = JeSONInvocation(rawValue: invocation.commandIdentifier) else {
            let errorInfo = [NSLocalizedDescriptionKey: "Command not recognized"]
            completionHandler(NSError(domain: "", code: 0, userInfo: errorInfo))
            return
        }
        
        let buffer = invocation.buffer
        guard buffer.selections.count == 1 else {
            let errorInfo = [NSLocalizedDescriptionKey: "Command only handles 1 selection at a time"]
            completionHandler(NSError(domain: "", code: 0, userInfo: errorInfo))
            return
        }
        
        let selectedText = textAtSelectionIndex(0, buffer: buffer)
        
        let data = selectedText.data(using: .utf8)
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions())
            switch jeSONInvocation {
            case .Minify:
                let miniData = try! JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions())
                let string = String.init(data: miniData, encoding: .utf8)!
                replaceTextAtSelectionIndex(0, replacementText: string, buffer: buffer)
            case .Prettify:
                let miniData = try! JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                let string = String.init(data: miniData, encoding: .utf8)!
                replaceTextAtSelectionIndex(0, replacementText: string, buffer: buffer)
            }
        }
        catch {
            completionHandler(error)
        }

        completionHandler(nil)
    }
    
    func textAtSelectionIndex(_ at: Int, buffer: XCSourceTextBuffer) -> String {
        let textRange = buffer.selections[at] as! XCSourceTextRange
        
        let selectionLines = buffer.lines.enumerated().filter { (offset, element) -> Bool in
            return offset >= textRange.start.line && offset <= textRange.end.line
            }.map { return $1 }
        
        return selectionLines.enumerated().reduce("") { (result, enumeration) -> String in
            let line = enumeration.element as! String
            
            if enumeration.offset == 0 && enumeration.offset == selectionLines.count - 1 {
                let startIndex = line.index(line.startIndex, offsetBy: textRange.start.column)
                let endIndex = line.index(line.startIndex, offsetBy: textRange.end.column + 1)

                return result + line.substring(with: startIndex..<endIndex)
            } else if enumeration.offset == 0 {
                let startIndex = line.index(line.startIndex, offsetBy: textRange.start.column)
                return result + line.substring(from: startIndex)
            } else if enumeration.offset == selectionLines.count - 1 {
                let endIndex = line.index(line.startIndex, offsetBy: textRange.end.column + 1)
                return result + line.substring(to: endIndex)
            }
            
            return result + line
        }
    }
    
    func replaceTextAtSelectionIndex(_ at: Int, replacementText: String, buffer: XCSourceTextBuffer) {
        let textRange = buffer.selections[at] as! XCSourceTextRange

        let lastLine = buffer.lines[textRange.end.line] as! String
        let endIndex = lastLine.index(lastLine.startIndex, offsetBy: textRange.end.column+1)
        let suffix = lastLine.substring(from: endIndex)
        
        let firstLine = buffer.lines[textRange.start.line] as! String
        let startIndex = firstLine.index(firstLine.startIndex, offsetBy: textRange.start.column)
        let prefix = firstLine.substring(to: startIndex)
        
        let range = NSMakeRange(textRange.start.line, textRange.end.line - textRange.start.line + 1)
        buffer.lines.removeObjects(in: range)
        buffer.lines.insert(prefix+replacementText+suffix, at: textRange.start.line)
        
        let newRange = XCSourceTextRange(start: textRange.start, end: textRange.start)
        buffer.selections.setArray([newRange])
    }
}

/*
{
  "glossary" : {
    "title" : "example glossary",
    "GlossDiv" : {
      "title" : "S",
      "GlossList" : {
        "GlossEntry" : {
          "SortAs" : "SGML",
          "Abbrev" : "ISO 8879:1986",
          "GlossTerm" : "Standard Generalized Markup Language",
          "GlossDef" : {
            "GlossSeeAlso" : [
              "GML",
              "XML"
            ],
            "para" : "A meta-markup language, used to create markup languages such as DocBook."
          },
          "GlossSee" : "markup",
          "ID" : "SGML",
          "Acronym" : "SGML"
        }
      }
    }
  }
}
 */
