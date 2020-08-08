//
//  Engine.swift
//  Swift To HTML Listing
//
//  Created by Ramil Salimov on 22/03/2019.
//  Copyright © 2019 Ramil Salimov. All rights reserved.
//

import Cocoa

struct Engine{
    
    var colourStyle: ColourStyle
    var fontOptionStyle: FontProfile
    
    init(colourStyle: ColourStyle, fontOptionStyle: FontProfile){
        self.colourStyle = colourStyle
        self.fontOptionStyle = fontOptionStyle
    }
    
    
    func getHtmlAndColorFields(swiftCode: String) -> String{
        
        var htmlText = getCSS() //first we get CSS code for instructing our web page
        
        //Then we colorise it
        
        var usedProperties: [String] = ["view"]
        var listOfUnwrappedProperties: [String] = []
        
        var word: String = ""
        var isFuncDeclaring: Bool = false
        var isString: Bool = false
        var codeInString: Bool = false
        var codeCoveredString: Bool = false
        var isComment: Bool = false
        var isLotLinesComment: Bool = false
        var previousWordAsAKey: Bool = false
        var wordIsGoingToBeAProperty: Bool = false
        var wordIsAMethod: Bool = false
        var propertyNeedsToBeDropped: Bool = false
        var isNewType: Bool = false
        var unwrappingIsUsed: Bool = false
        var ifGuardHasBeenUsed: Bool = false
        var openBracersAmount = 0 //scope control
        var closeBracersAmount = 0 //scope control
        var stringOpenParanthesis = 0
        var stringCloseParanthesis = 0
        var lastSymbol = ""
        
        
        for char in swiftCode + "\n"{
            //Looking for Strings and multiple lines of Strings
            if word == "\"\""{
                isString = false
                safetyAppending(of: "<span style=\"color: \(colourStyle.stringColour)\">\(word)</span>", to: &htmlText)
                word = ""
            }
            if codeInString && word == ")"{
                stringCloseParanthesis += 1
                if stringCloseParanthesis != 0 && stringCloseParanthesis == stringOpenParanthesis{
                    codeInString = false
                    stringOpenParanthesis = 0
                    stringCloseParanthesis = 0
                }
            }
            //Looking for balanced bracers in code
            if (openBracersAmount != 0 && closeBracersAmount != 0) && openBracersAmount == closeBracersAmount && isNewType{
                usedProperties = ["view"]
                openBracersAmount = 0
                closeBracersAmount = 0
                isNewType = false
            }else if (openBracersAmount - closeBracersAmount <= 1 && isNewType) || (openBracersAmount != 0 && openBracersAmount == closeBracersAmount && !isNewType){
                listOfUnwrappedProperties = []
            }
            //Work with Strings
            if (isString && !codeInString) || (isString && codeInString && codeCoveredString){
                //Continue work with Strings
                if char == "\""{
                    if let lastLetter = word.last{
                        if lastLetter == "\\"{
                            word.append(char)
                        }else{
                            if isString && !codeInString{
                                word.append(char)
                                isString = false
                                safetyAppending(of: "<span style=\"color: \(colourStyle.stringColour)\">\(word)</span>", to: &htmlText)
                                word = ""
                            }else if isString && codeInString && codeCoveredString{
                                word.append(char)
                                safetyAppending(of: "<span style=\"color: \(colourStyle.stringColour)\">\(word)</span>", to: &htmlText)
                                word = ""
                                codeCoveredString = false
                            }
                        }
                    }else{
                        word.append(char)
                    }
                }else if char == "("{
                    //Adds code to String if needed like print("year \(2019)") where 2019 is Int
                    if let lastLetter = word.last{
                        if lastLetter == "\\"{
                            word.append(char)
                            safetyAppending(of: "<span style=\"color: \(colourStyle.stringColour)\">\(word)</span>", to: &htmlText)
                            codeInString = true
                            word = ""
                            stringOpenParanthesis += 1
                        }else{
                            word.append(char)
                        }
                    }else{
                        word.append(char)
                    }
                    
                }else{
                    word.append(char)
                }
            }else if isLotLinesComment{
                //End comments
                word.append(char)
                if word.contains("*/"){
                    isLotLinesComment = false
                    safetyAppending(of: "<span style=\"color: \(colourStyle.commentColour)\">\(word)</span>", to: &htmlText)
                    word = ""
                }
            }else if isComment{
                //Continue comments
                if char != "\n"{
                    word.append(char)
                }else{
                    isComment = false
                    safetyAppending(of: "<span style=\"color: \(colourStyle.commentColour)\">\(word)</span>", to: &htmlText)
                    word = String(char)
                }
            }else{
                //Keywords and data types
                switch word{
                case "class", "protocol", "enum", "struct", "import", "internal", "private", "fileprivate", "public", "let", "var", "func", "nil", "init", "as", "deinit", "extension", "self", "get", "set", "didSet", "willSet", "while", "do", "try", "catch", "case", "switch", "default", "if", "else", "for", "true", "false", "super", "@IBOutlet", "@unknown", "@IBAction", "@IBDesignable", "@DiscardableResult", "weak", "unowned", "associatedtype", "inout", " open", "operator", "static", "open", "subscript",  "typealias", "defer", "continue", "break", "fallthrough", "repeat", "return", "where", "Any", "Self", "rethrows", "throw", "throws", "associativity", "convenience", "dynamic", "final", "infix", "indirect", "lazy", "mutating", "none", "nonmutating", "optional", "override", "postfix", "precedence", "prefix", "Protocol", "required", "Type", "in", "is", "@objc", "#selector", "#import", "guard", "_":
                    //Keywords
                    if !char.isAlphaNumerical(){
                        if word == "for" && (previousWordAsAKey || lastSymbol == "(" || lastSymbol == ":"){
                            safetyAppending(of: "<span style=\"color: \(colourStyle.textColour)\">\(word)</span>", to: &htmlText)
                            previousWordAsAKey = false
                        }else{
                            safetyAppending(of: "<span style=\"color: \(colourStyle.keywordColour)\">\(word)</span>", to: &htmlText)
                            if word == "class" || word == "enum" || word == "struct" || word == "protocol" || word == "import"{
                                previousWordAsAKey = true
                                if word == "class" || word == "struct" || word == "enum" || word == "protocol"{
                                    isNewType = true
                                }
                            }else if word == "var" || word == "let"{
                                if word == "let" && ifGuardHasBeenUsed{
                                    unwrappingIsUsed = true
                                }
                                if openBracersAmount - closeBracersAmount <= 1{
                                    wordIsGoingToBeAProperty = true
                                }else{
                                    propertyNeedsToBeDropped = true
                                }
                                previousWordAsAKey = true
                            }else if word == "func"{
                                isFuncDeclaring = true
                            }else if word == "if" || word == "guard"{
                                ifGuardHasBeenUsed = true
                            }
                        }
                        word = String(char)
                    }else{
                        word.append(char)
                    }
                    
                case "#":
                    lastSymbol = word
                    if char == "s" || char == "i"{
                        //#import and #swift
                        word.append(char)
                    }else{
                        safetyAppending(of: "<span style=\"color: \(colourStyle.stringColour)\">\(word)</span>", to: &htmlText)
                        word = String(char)
                    }
                case _ where Int(word) != nil:
                    //Int
                    safetyAppending(of: "<span style=\"color: \(colourStyle.numberColour)\">\(word)</span>", to: &htmlText)
                    word = String(char)
                case _ where word.isUppercased() && (char == "=" || char == " " || char == "\n" || char == "{" || char == "}" || char == "." || char == "(" || char == ")" || char == ":" || char == "+" || char == "-" || char == "*" || char == "/" || char == "?" || char == "!" || char == "," || char == "<" || char == ">" || char == "&" || char == "[" || char == "]"):
                    if previousWordAsAKey{
                        safetyAppending(of: "<span style=\"color: \(colourStyle.textColour)\">\(word)</span>", to: &htmlText)
                        
                    }else{
                        safetyAppending(of: "<span style=\"color: \(colourStyle.typeColour)\">\(word)</span>", to: &htmlText)
                    }
                    if char == "{"{
                        ifGuardHasBeenUsed = false
                        unwrappingIsUsed = false
                    }
                    previousWordAsAKey = false
                    word = String(char)
                    
                case " ", "\n":
                    lastSymbol = word
                    htmlText.append(word)
                    word = String(char)
                case "\"":
                    //String starts
                    lastSymbol = word
                    word.append(char)
                    if !isString && !codeInString && !codeCoveredString{
                        isString = true
                        previousWordAsAKey = false
                    }else if isString && codeInString && !codeCoveredString{
                        codeCoveredString = true
                    }else if isString && codeInString && codeCoveredString{
                        codeCoveredString = false
                    }
                case "/":
                    //Comments starts
                    lastSymbol = word
                    var futureWord = word
                    futureWord.append(char)
                    if futureWord.contains("//"){
                        isComment = true
                        word.append(char)
                    }else if futureWord.contains("/*"){
                        isLotLinesComment = true
                        word.append(char)
                    }else{
                        safetyAppending(of: "<span style=\"color: \(colourStyle.textColour)\">\(word)</span>", to: &htmlText)
                        word = String(char)
                    }
                    previousWordAsAKey = false
                case ".", "(", ")", ":", "+", "-", "*", "=", "?", "!", ",", "{", "}", "<", ">", "&", "[", "]":
                    lastSymbol = word
                    wordIsGoingToBeAProperty = false
                    switch word{
                    case "<": safetyAppending(of: "<span style=\"color: \(colourStyle.textColour)\">&lt;</span>", to: &htmlText)
                    case ">": safetyAppending(of: "<span style=\"color: \(colourStyle.textColour)\">&gt;</span>", to: &htmlText)
                    case "&": safetyAppending(of: "<span style=\"color: \(colourStyle.textColour)\">&amp;</span>", to: &htmlText)
                    default: safetyAppending(of: "<span style=\"color: \(colourStyle.textColour)\">\(word)</span>", to: &htmlText)
                    }
                    if word == "."{
                        wordIsAMethod = true
                    }else if word == "(" && codeInString{
                        stringOpenParanthesis += 1
                    }else if word == "{"{ //scope control
                        
                        unwrappingIsUsed = false
                        ifGuardHasBeenUsed = false
                        openBracersAmount += 1
                    }else if word == "}"{ //scope control
                        closeBracersAmount += 1
                    }
                    word = String(char)
                    previousWordAsAKey = false
                case _ where char == "(":
                    if isFuncDeclaring{
                        safetyAppending(of: "<span style=\"color: \(colourStyle.textColour)\">\(word)</span>", to: &htmlText)
                        isFuncDeclaring = false
                    }else{
                        safetyAppending(of: "<span style=\"color: \(colourStyle.methodColour)\">\(word)</span>", to: &htmlText)
                    }
                    
                    word = String(char)
                    
                default:
                    //methods, properties and text
                    if char == " " || char == "\n" || char == "{" || char == "}" || char == "." || char == "(" || char == ")" || char == "!" || char == "?" || char == ":" || char == "+" || char == "-" || char == "*" || char == "=" || char == "/" || char == "," || char == "<" || char == ">" || char == "&" || char == "[" || char == "]"{
                        
                        if !usedProperties.contains(word) && (lastSymbol == "[" || char == "]") && lastSymbol != "."{
                            safetyAppending(of: "<span style=\"color: \(colourStyle.textColour)\">\(word)</span>", to: &htmlText)
                        }else if openBracersAmount - closeBracersAmount > 1 && (lastSymbol == " " || lastSymbol == "=") && (char == "\n"){
                            safetyAppending(of: "<span style=\"color: \(colourStyle.textColour)\">\(word)</span>", to: &htmlText)
                            
                        }else if wordIsAMethod && char == "("{
                            safetyAppending(of: "<span style=\"color: \(colourStyle.methodColour)\">\(word)</span>", to: &htmlText)
                            if wordIsAMethod{
                                wordIsAMethod = false
                            }
                        }else if wordIsGoingToBeAProperty{
                            usedProperties.append(word)
                            if unwrappingIsUsed{
                                listOfUnwrappedProperties.append(word)
                                unwrappingIsUsed = false
                            }
                            wordIsGoingToBeAProperty = false
                            safetyAppending(of: "<span style=\"color: \(colourStyle.textColour)\">\(word)</span>", to: &htmlText)
                            
                        }else if previousWordAsAKey || unwrappingIsUsed{
                            if propertyNeedsToBeDropped || unwrappingIsUsed{
                                for property in usedProperties{
                                    if property == word{
                                        listOfUnwrappedProperties.append(property)
                                    }
                                }
                                propertyNeedsToBeDropped = false
                                unwrappingIsUsed = false
                                
                            }
                            
                            safetyAppending(of: "<span style=\"color: \(colourStyle.textColour)\">\(word)</span>", to: &htmlText)
                            previousWordAsAKey = false
                        }else if (usedProperties.contains(word) && !wordIsGoingToBeAProperty && !previousWordAsAKey && char != ":") || (wordIsAMethod && !usedProperties.contains(word) && lastSymbol == "." && char != "("){
                            if listOfUnwrappedProperties.contains(word) && openBracersAmount > 0{
                                safetyAppending(of: "<span style=\"color: \(colourStyle.textColour)\">\(word)</span>", to: &htmlText)
                            }else{
                                safetyAppending(of: "<span style=\"color: \(colourStyle.propertyColour)\">\(word)</span>", to: &htmlText)
                            }
                            wordIsAMethod = false
                        }else{
                            safetyAppending(of: "<span style=\"color: \(colourStyle.textColour)\">\(word)</span>", to: &htmlText)
                        }
                        if char == " " || char == "\n"{
                            if char == "\n"{
                                unwrappingIsUsed = false
                            }
                            htmlText.append(char)
                            word = ""
                        }else{
                            word = String(char)
                        }
                        
                    }else{
                        word.append(char)
                    }
                }
            }
        }
        
        htmlText.append("</pre></td></tr></table></div>")
        return htmlText
    }
    
    private func getCSS() -> String{
        var fontProfileCSS: [String] = []
        var usedIndices: [Int] = []
        
        if let profileCSS = fontOptionStyle.additionalCSS{
            fontProfileCSS = profileCSS.components(separatedBy: ";")
        }
        
        var backgroundColour: String = "background: \(colourStyle.backgroundColour);"
        var textShadow = "text-shadow: 1px rgba(0, 0, 0, 0.3);"
        
        var borderHas: Bool = false
        
        if colourStyle.borderColour != nil || fontProfileCSS.contains("border:solid"){
            borderHas = true
        }
        
        var borderRadius = "border-radius:0.4em;"
        var borderWidth = borderHas ? "border-width:0.1em;" : ""
        var borderColour = borderHas && colourStyle.borderColour != nil ? "border:solid \(colourStyle.borderColour!);" : ""
        var fontSize = ""
        var padding = borderHas ? "padding:0.7em;" : "padding:1em;"
        var overflow = "overflow:auto;"
        var overflowX = ""
        var overflowY = ""
        var width = "width:auto;"
        var height = ""
        
        var margin = borderHas ? "margin: .3em;" : "margin: .2em;"
        var lineHeight = "line-height: 125%;"
        var lineWidth = ""
        var fontFamily = ""
        var fontStyle = ""
        var additional: String = ""
        
        //Each profile contains settings and we store it to our variables
        for (index,cssBlock) in fontProfileCSS.enumerated(){
            guard cssBlock != "" else{continue}
            if cssBlock.contains("background:"){
                backgroundColour = cssBlock + ";"
                usedIndices.append(index)
            }else if cssBlock.contains("textShadow:"){
                textShadow = textShadow + ";"
                usedIndices.append(index)
            }else if cssBlock.contains("border-radius:"){
                borderRadius = cssBlock + ";"
                usedIndices.append(index)
            }else if cssBlock.contains("border-width:"){
                borderWidth = cssBlock + ";"
                usedIndices.append(index)
            }else if cssBlock.contains("border:solid"){
                borderColour = cssBlock + ";"
                usedIndices.append(index)
            }else if cssBlock.contains("font-size:"){
                fontSize = cssBlock + ";"
                usedIndices.append(index)
            }else if cssBlock.contains("padding:"){
                padding = cssBlock + ";"
                usedIndices.append(index)
            }else if cssBlock.contains("overflow:"){
                overflow = cssBlock + ";"
                usedIndices.append(index)
            }else if cssBlock.contains("overflow-x:"){
                overflowX = cssBlock + ";"
                usedIndices.append(index)
            }else if cssBlock.contains("overflow-y:"){
                overflowY = cssBlock + ";"
                usedIndices.append(index)
            }else if cssBlock.contains("line-height:"){
                lineHeight = cssBlock + ";"
                usedIndices.append(index)
            }else if cssBlock.contains("line-width:"){
                lineWidth = cssBlock + ";"
                usedIndices.append(index)
            }else if cssBlock.contains("font-family:"){
                fontFamily = cssBlock + ";"
                usedIndices.append(index)
            }else if cssBlock.contains("font-style:"){
                fontStyle = cssBlock + ";"
                usedIndices.append(index)
            }else if cssBlock.contains("margin:"){
                margin = cssBlock + ";"
                usedIndices.append(index)
            }else if cssBlock.contains("width:"){
                width = cssBlock + ";"
                usedIndices.append(index)
            }else if cssBlock.contains("height:"){
                height = cssBlock + ";"
                usedIndices.append(index)
            }
        }
        if overflowX != "" && overflowY != ""{
            overflow = ""
        }
        let sortedIndises = usedIndices.sorted(by: >)
        
        for index in sortedIndises{
            fontProfileCSS.remove(at: index)
        }
        
        for block in fontProfileCSS{
            guard block != "" else {continue}
            additional += block + (block.last == ";" ? "" : ";")
        }
        
        return "<!-- HTML created by mr-uberdeviant.blogspot.com --><div style=\"\(backgroundColour)\(textShadow)\(fontSize)\(borderRadius)\(borderWidth)\(borderColour)\(padding)\(overflow)\(overflowY)\(overflowX)\(width)\(height)\"><table><tr><td><pre style=\"\(margin)\(fontFamily)\(fontStyle)\(lineHeight)\(lineWidth)\(additional)\">"
    }
    
    private func safetyAppending(of string: String, to text: inout String){
        if string != "<span style=\"color: \(colourStyle.textColour)\"></span>" && string != "<span style=\"color: \(colourStyle.textColour)\"> </span>" && string != "<span style=\"color: \(colourStyle.methodColour)\"></span>" && string != "<span style=\"color: \(colourStyle.textColour)\"> </span>"{
            text.append(string)
        }
    }
}

