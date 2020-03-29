//
//  FontOptionStyle.swift
//  Swiftlighter
//
//  Created by Ramil Salimov on 30/03/2019.
//  Copyright © 2019 Ramil Salimov. All rights reserved.
//

import Foundation

struct FontProfile: Codable {
    
    static let fontStyles = ["Default","Normal", "Italic", "Oblique"]
    static let fontFamilies = ["Web Page Font","Arial, sans-serif", "Helvetica, sans-serif", "Verdana, sans-serif", "Trebuchet MS, sans-serif", "Gill Sans, sans-serif", "Noto Sans, sans-serif", "Avantgarde, TeX Gyre Adventor, URW Gothic L, sans-serif", "Optima, sans-serif", "Arial Narrow, sans-serif", "sans-serif", "Times, Times New Roman, serif", "Didot, serif", "Georgia, serif", "Palatino, URW Palladio L, serif", "Bookman, URW Bookman L, serif", "New Century Schoolbook, TeX Gyre Schola, serif", "American Typewriter, serif", "serif", "Andale Mono, monospace", "Courier New, monospace", "Courier, monospace", "FreeMono, monospace", "OCR A Std, monospace", "DejaVu Sans Mono, monospace", "Monaco", "monospace", "Comic Sans MS, Comic Sans, cursive", "Apple Chancery, cursive", "Bradley Hand, cursive", "Brush Script MT, Brush Script Std, cursive", "Snell Roundhand, cursive", "URW Chancery L, cursive", "cursive", "Impact, fantasy", "Luminari, fantasy", "Chalkduster, fantasy", "Jazz LET, fantasy", "Blippo, fantasy", "Stencil Std, fantasy", "Marker Felt, fantasy", "Trattatello, fantasy", "fantasy"]
    static let fontCalculage = ["px", "em", "%"]
    
    static func save(profileArray: [FontProfile]){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(profileArray) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "SwiftlighterSavedProfiles")
        }
    }
    
    static func load() -> [FontProfile]?{
        if let savedProfiles = UserDefaults.standard.object(forKey: "SwiftlighterSavedProfiles") as? Data {
            let decoder = JSONDecoder()
            if let loadedProfiles = try? decoder.decode([FontProfile].self, from: savedProfiles) {
                return loadedProfiles
            }else{
                return nil
            }
        }else{
            return nil
        }
    }
    
    var fontProfileTitle: String
    var fontSize: String?
    var fontFamilyIndex: Int
    var fontStyleIndex: Int
    var fontCalculageIndex: Int
    var additionalCSS: String?
    init(fontProfileTitle: String, fontSize: String?, fontFamilyIndex: Int, fontStyleIndex: Int, fontCalculageIndex: Int, additionalCSS: String?) {
        self.fontProfileTitle = fontProfileTitle
        self.fontSize = fontSize
        self.fontFamilyIndex = fontFamilyIndex
        self.fontStyleIndex = fontStyleIndex
        self.fontCalculageIndex = fontCalculageIndex
        self.additionalCSS = additionalCSS
    }
}
