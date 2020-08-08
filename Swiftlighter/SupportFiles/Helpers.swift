//
//  Helpers.swift
//  Swiftlighter
//
//  Created by Ramil Salimov on 25/03/2019.
//  Copyright © 2019 Ramil Salimov. All rights reserved.
//

import Foundation


extension String{
    func isUppercased() -> Bool{
        guard let firstLetter = self.first else {return false}
        let char = firstLetter.unicodeScalars.first
        if let unwChar = char{
            return CharacterSet.uppercaseLetters.contains(unwChar)
        }else{
            return false
        }
    }
}

extension Character{
    func isAlphaNumerical() -> Bool{
        if let char = self.unicodeScalars.first{
            return CharacterSet.alphanumerics.contains(char)
        }else{
            return false
        }
    }
}
