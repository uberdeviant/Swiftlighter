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
        var fontProfileCSS: [String] = []
        var usedIndexes: [Int] = []
        
        var usedProperties: [String] = ["view"]
        var listOfUnwrappedProperties: [String] = []
        
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
        
        for (index,cssBlock) in fontProfileCSS.enumerated(){
            guard cssBlock != "" else{continue}
            if cssBlock.contains("background:"){
                backgroundColour = cssBlock + ";"
                usedIndexes.append(index)
            }else if cssBlock.contains("textShadow:"){
                textShadow = textShadow + ";"
                usedIndexes.append(index)
            }else if cssBlock.contains("border-radius:"){
                borderRadius = cssBlock + ";"
                usedIndexes.append(index)
            }else if cssBlock.contains("border-width:"){
                borderWidth = cssBlock + ";"
                usedIndexes.append(index)
            }else if cssBlock.contains("border:solid"){
                borderColour = cssBlock + ";"
                usedIndexes.append(index)
            }else if cssBlock.contains("font-size:"){
                fontSize = cssBlock + ";"
                usedIndexes.append(index)
            }else if cssBlock.contains("padding:"){
                padding = cssBlock + ";"
                usedIndexes.append(index)
            }else if cssBlock.contains("overflow:"){
                overflow = cssBlock + ";"
                usedIndexes.append(index)
            }else if cssBlock.contains("overflow-x:"){
                overflowX = cssBlock + ";"
                usedIndexes.append(index)
            }else if cssBlock.contains("overflow-y:"){
                overflowY = cssBlock + ";"
                usedIndexes.append(index)
            }else if cssBlock.contains("line-height:"){
                lineHeight = cssBlock + ";"
                usedIndexes.append(index)
            }else if cssBlock.contains("line-width:"){
                lineWidth = cssBlock + ";"
                usedIndexes.append(index)
            }else if cssBlock.contains("font-family:"){
                fontFamily = cssBlock + ";"
                usedIndexes.append(index)
            }else if cssBlock.contains("font-style:"){
                fontStyle = cssBlock + ";"
                usedIndexes.append(index)
            }else if cssBlock.contains("margin:"){
                margin = cssBlock + ";"
                usedIndexes.append(index)
            }else if cssBlock.contains("width:"){
                width = cssBlock + ";"
                usedIndexes.append(index)
            }else if cssBlock.contains("height:"){
                height = cssBlock + ";"
                usedIndexes.append(index)
            }
        }
        if overflowX != "" && overflowY != ""{
            overflow = ""
        }
        let sortedIndexes = usedIndexes.sorted(by: >)
        
        for index in sortedIndexes{
            fontProfileCSS.remove(at: index)
        }
        
        for block in fontProfileCSS{
            guard block != "" else {continue}
            additional += block + (block.last == ";" ? "" : ";")
        }
        
        //add font size
        var htmlText: String = "<!-- HTML created by mr-uberdeviant.blogspot.com --><div style=\"\(backgroundColour)\(textShadow)\(fontSize)\(borderRadius)\(borderWidth)\(borderColour)\(padding)\(overflow)\(overflowY)\(overflowX)\(width)\(height)\"><table><tr><td><pre style=\"\(margin)\(fontFamily)\(fontStyle)\(lineHeight)\(lineWidth)\(additional)\">"
        var word: String = ""
        var isFuncDeclaring: Bool = false
        var isString: Bool = false
        var codeInString: Bool = false
        var stringInCodeInString: Bool = false
        var isComment: Bool = false
        var isLotLinesComment: Bool = false
        var previousWordAsAKey: Bool = false
        var wordIsGoingToBeAProperty: Bool = false
        var wordIsAMethod: Bool = false
        var propertyNeedsToBeDropped: Bool = false
        var isNewType: Bool = false
        var unwrappingIsUsed: Bool = false
        var ifGuardHasBeenUsed: Bool = false
        var openBrackersAmount = 0
        var closeBrackersAmount = 0
        var stringOpenBrackers = 0
        var stringCloseBrackers = 0
        var lastSymbol = ""
        
        
        for char in swiftCode + "\n"{
            if word == "\"\""{
                isString = false
                safetyAppending(of: "<span style=\"color: \(colourStyle.stringColour)\">\(word)</span>", to: &htmlText)
                word = ""
            }
            if codeInString && word == ")"{
                stringCloseBrackers += 1
                if stringCloseBrackers != 0 && stringCloseBrackers == stringOpenBrackers{
                    codeInString = false
                    stringOpenBrackers = 0
                    stringCloseBrackers = 0
                }
            }
            
            if (openBrackersAmount != 0 && closeBrackersAmount != 0) && openBrackersAmount == closeBrackersAmount && isNewType{
                usedProperties = ["view"]
                openBrackersAmount = 0
                closeBrackersAmount = 0
                isNewType = false
            }else if (openBrackersAmount - closeBrackersAmount <= 1 && isNewType) || (openBrackersAmount != 0 && openBrackersAmount == closeBrackersAmount && !isNewType){
                listOfUnwrappedProperties = []
            }
            
            if (isString && !codeInString) || (isString && codeInString && stringInCodeInString){
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
                            }else if isString && codeInString && stringInCodeInString{
                                word.append(char)
                                safetyAppending(of: "<span style=\"color: \(colourStyle.stringColour)\">\(word)</span>", to: &htmlText)
                                word = ""
                                stringInCodeInString = false
                            }
                        }
                    }else{
                        word.append(char)
                    }
                }else if char == "("{
                    if let lastLetter = word.last{
                        if lastLetter == "\\"{
                            word.append(char)
                            safetyAppending(of: "<span style=\"color: \(colourStyle.stringColour)\">\(word)</span>", to: &htmlText)
                            codeInString = true
                            word = ""
                            stringOpenBrackers += 1
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
                word.append(char)
                if word.contains("*/"){
                    isLotLinesComment = false
                    safetyAppending(of: "<span style=\"color: \(colourStyle.commentColour)\">\(word)</span>", to: &htmlText)
                    word = ""
                }
            }else if isComment{
                if char != "\n"{
                    word.append(char)
                }else{
                    isComment = false
                    safetyAppending(of: "<span style=\"color: \(colourStyle.commentColour)\">\(word)</span>", to: &htmlText)
                    word = String(char)
                }
            }else{
                switch word{
                case "class", "protocol", "enum", "struct", "import", "internal", "private", "public", "let", "var", "func", "nil", "init", "as", "deinit", "extension", "self", "get", "set", "didSet", "willSet", "while", "do", "try", "cath", "case", "switch", "default", "if", "else", "for", "true", "false", "super", "@IBOutlet", "@unknown", "@IBAction", "weak", "strong", "associatedtype", "fileprivate", "inout", " open", "operator", "static", "subscript",  "typealias", "defer", "continue", "break", "fallthrough", "repeat", "return", "where", "Any", "Self", "rethrows", "throw", "throws", "associativity", "convenience", "dynamic", "final", "infix", "indirect", "lazy", "mutating", "none", "nonmutating", "optional", "override", "postfix", "precedence", "prefix", "Protocol", "required", "Type", "unowned", "in", "is", "@objc", "#selector", "#import", "guard", "_":
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
                                if openBrackersAmount - closeBrackersAmount <= 1{
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
                        word.append(char)
                    }else{
                        safetyAppending(of: "<span style=\"color: \(colourStyle.stringColour)\">\(word)</span>", to: &htmlText)
                        word = String(char)
                    }
                case _ where Int(word) != nil:
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
                    lastSymbol = word
                    word.append(char)
                    if !isString && !codeInString && !stringInCodeInString{
                        isString = true
                        previousWordAsAKey = false
                    }else if isString && codeInString && !stringInCodeInString{
                        stringInCodeInString = true
                    }else if isString && codeInString && stringInCodeInString{
                        stringInCodeInString = false
                    }
                case "/":
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
                        stringOpenBrackers += 1
                    }else if word == "{"{
                        
                        unwrappingIsUsed = false
                        ifGuardHasBeenUsed = false
                        openBrackersAmount += 1
                    }else if word == "}"{
                        closeBrackersAmount += 1
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
                    if char == " " || char == "\n" || char == "{" || char == "}" || char == "." || char == "(" || char == ")" || char == "!" || char == "?" || char == ":" || char == "+" || char == "-" || char == "*" || char == "=" || char == "/" || char == "," || char == "<" || char == ">" || char == "&" || char == "[" || char == "]"{
                        
                        if !usedProperties.contains(word) && (lastSymbol == "[" || char == "]") && lastSymbol != "."{
                            safetyAppending(of: "<span style=\"color: \(colourStyle.textColour)\">\(word)</span>", to: &htmlText)
                        }else if openBrackersAmount - closeBrackersAmount > 1 && (lastSymbol == " " || lastSymbol == "=") && (char == "\n"){
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
                            if listOfUnwrappedProperties.contains(word) && openBrackersAmount > 0{
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
    private func safetyAppending(of string: String, to text: inout String){
        if string != "<span style=\"color: \(colourStyle.textColour)\"></span>" && string != "<span style=\"color: \(colourStyle.textColour)\"> </span>" && string != "<span style=\"color: \(colourStyle.methodColour)\"></span>" && string != "<span style=\"color: \(colourStyle.textColour)\"> </span>"{
            text.append(string)
        }
    }
}

