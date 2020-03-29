//
//  StylesCollectionViewItem.swift
//  Swiftlighter
//
//  Created by Ramil Salimov on 29/03/2019.
//  Copyright © 2019 Ramil Salimov. All rights reserved.
//

import Cocoa

class StylesCollectionViewItem: NSCollectionViewItem {
    

    override var isSelected: Bool{
        didSet{
            super.isSelected = isSelected
            if isSelected{
                NSAnimationContext.runAnimationGroup({ (_in) in
                    NSAnimationContext.current.duration = 0.3
                    self.view.animator().alphaValue = 0.2
                    self.view.layer?.transform = CATransform3DMakeScale(1.05, 1.05, 1.05)
                }) {
                    NSAnimationContext.current.duration = 0.5
                    self.view.animator().alphaValue = 1.0
                    self.view.layer?.transform = CATransform3DIdentity
                }
            }
        }
    }
    
    @IBOutlet weak var backgroundBox: NSBox!
    
    @IBOutlet weak var keywordBox: NSBox!
    
    @IBOutlet weak var numBox: NSBox!
    
    @IBOutlet weak var stringBox: NSBox!
    
    @IBOutlet weak var textBox: NSBox!
    
    @IBOutlet weak var typeBox: NSBox!
    
    @IBOutlet weak var commentBox: NSBox!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        // Do view setup here.
        
        keywordBox.borderWidth = 0
        numBox.borderWidth = 0
        stringBox.borderWidth = 0
        textBox.borderWidth = 0
        typeBox.borderWidth = 0
        commentBox.borderWidth = 0
        backgroundBox.borderWidth = 0
        backgroundBox.layer?.bounds.clip()
    }
    
    func updateItem(by colourStyle: ColourStyle, item: StylesCollectionViewItem) -> StylesCollectionViewItem{
        
        item.backgroundBox.fillColor = NSColor(hexString: colourStyle.backgroundColour + "ff") ?? NSColor.white
        if let borderColour = colourStyle.borderColour{
            item.backgroundBox.borderColor = NSColor(hexString: borderColour + "ff") ?? NSColor.white
        }else{
            item.backgroundBox.borderColor = NSColor(hexString: colourStyle.backgroundColour + "ff") ?? NSColor.white
        }
        item.keywordBox.fillColor = NSColor(hexString: colourStyle.keywordColour + "ff") ?? NSColor.black
        item.textBox.fillColor = NSColor(hexString: colourStyle.textColour + "ff") ?? NSColor.black
        item.typeBox.fillColor = NSColor(hexString: colourStyle.typeColour + "ff") ?? NSColor.black
        item.numBox.fillColor = NSColor(hexString: colourStyle.numberColour + "ff") ?? NSColor.black
        item.stringBox.fillColor = NSColor(hexString: colourStyle.stringColour + "ff") ?? NSColor.black
        item.commentBox.fillColor = NSColor(hexString: colourStyle.commentColour + "ff") ?? NSColor.black
        
        return item

    }
    
}
