//
//  ColourStyle.swift
//  Swiftlighter
//
//  Created by Ramil Salimov on 25/03/2019.
//  Copyright © 2019 Ramil Salimov. All rights reserved.
//

import Foundation


struct ColourStyle: Codable {
    
    enum ColourStyleType{
        case light, dark, space, sunset
    }
    
    static func save(colourStylesArray: [ColourStyle]){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(colourStylesArray) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "SwiftlighterSavedColours")
        }
    }
    
    static func load() -> [ColourStyle]?{
        if let savedColours = UserDefaults.standard.object(forKey: "SwiftlighterSavedColours") as? Data {
            let decoder = JSONDecoder()
            if let loadedColours = try? decoder.decode([ColourStyle].self, from: savedColours) {
                return loadedColours
            }else{
                return nil
            }
        }else{
            return nil
        }
    }
    
    let title: String
    var backgroundColour: String
    var keywordColour: String
    var textColour: String
    var commentColour: String
    var methodColour: String
    var propertyColour: String
    var stringColour: String
    var numberColour: String
    var typeColour: String
    var borderColour: String?
    
    
    init(colourStyleType: ColourStyleType) {
        switch colourStyleType {
        case .light:
            title = "Light"
            backgroundColour = "#eff0f1"
            keywordColour = "#993399"
            textColour = "#000000"
            commentColour = "#006633"
            propertyColour = "#003366"
            methodColour = "#003333"
            stringColour = "#cc3333"
            numberColour =  "#3300cc"
            typeColour = "#336666"
            borderColour = "#cccccc"
        case .dark:
            title = "Dark"
            backgroundColour = "#272822"
            keywordColour = "#ff6699"
            textColour = "#cccccc"
            propertyColour = "#9999cc"
            methodColour = "#66cccc"
            commentColour = "#33cc33"
            stringColour = "#ff6666"
            numberColour = "#0099cc"
            typeColour = "#339999"
            borderColour = nil
        case .space:
            title = "Space"
            backgroundColour = "#272822"
            keywordColour = "#66ccff"
            textColour = "#ffffff"
            propertyColour = "#99ccff"
            methodColour = "#00ccff"
            commentColour = "#3399cc"
            stringColour = "#66cc00"
            numberColour = "#9966ff"
            typeColour = "#cccc66"
            borderColour = nil
        case .sunset:
            title = "Sunset"
            backgroundColour = "#ffffcc"
            keywordColour = "#003366"
            propertyColour = "#336666"
            methodColour = "#006699"
            textColour = "#000000"
            commentColour = "#cc6600"
            stringColour = "#cc3333"
            numberColour = "#333366"
            typeColour = "#cc3300"
            borderColour = nil
        }
    }
    
    
    init(title: String, backgroundColour: String, keywordColour: String, textColour: String, commentColour: String, propertyColour: String, methodColour: String, stringColour: String, numberColour: String, typeColour: String, borderColour: String?){
        self.title = title
        self.backgroundColour = backgroundColour
        self.keywordColour = keywordColour
        self.textColour = textColour
        self.commentColour = commentColour
        self.stringColour = stringColour
        self.numberColour =  numberColour
        self.typeColour = typeColour
        self.borderColour = borderColour
        self.propertyColour = propertyColour
        self.methodColour = methodColour
    }
    
}
