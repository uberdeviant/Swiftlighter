//
//  EditFontProfileViewController.swift
//  Swiftlighter
//
//  Created by Ramil Salimov on 31/03/2019.
//  Copyright © 2019 Ramil Salimov. All rights reserved.
//

import Cocoa

protocol EditFontProfileViewControllerDelegate: class{
    func updateProfile(profile: FontProfile)
}

class EditFontProfileViewController: NSViewController {
    
    @IBOutlet weak var fontProfileTitleTextField: NSTextField!
    @IBOutlet weak var fontSizeTextField: NSTextField!
    
    @IBOutlet weak var calculagePopUp: NSPopUpButton!
    
    @IBOutlet weak var fontFamilyPopUp: NSPopUpButton!
    
    @IBOutlet weak var fontStylePopUp: NSPopUpButton!
    
    @IBOutlet weak var cssTextField: NSTextField!
    
    var oldFontTitle = ""
    var additionalCss = ""
    var fontProfile: FontProfile!
    
    var cssBlocks: [String] = []
    
    weak var delegate: EditFontProfileViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fontSizeTextField.delegate = self
        self.cssTextField.delegate = self
        
        calculagePopUp.removeAllItems()
        fontStylePopUp.removeAllItems()
        fontFamilyPopUp.removeAllItems()
        
        calculagePopUp.addItems(withTitles: FontProfile.fontCalculage)
        fontStylePopUp.addItems(withTitles: FontProfile.fontStyles)
        fontFamilyPopUp.addItems(withTitles: FontProfile.fontFamilies)
        
        calculagePopUp.selectItem(at: fontProfile.fontCalculageIndex)
        fontStylePopUp.selectItem(at: fontProfile.fontStyleIndex)
        fontFamilyPopUp.selectItem(at: fontProfile.fontFamilyIndex)
        
        if let cssText = fontProfile.additionalCSS{
            cssTextField.stringValue = cssText
        }else{
            cssTextField.stringValue = ""
        }
        
        if let sizeText = fontProfile.fontSize{
            fontSizeTextField.stringValue = sizeText
        }else{
            fontSizeTextField.stringValue = ""
        }
        
        fontProfileTitleTextField.stringValue = fontProfile.fontProfileTitle
        oldFontTitle = fontProfile.fontProfileTitle
        
        cssBlocks = cssTextField.stringValue.components(separatedBy: ";")
        
        // Do view setup here.
    }
    
    @IBAction func calculagePopUpDidChosen(_ sender: NSPopUpButton) {
        updateFieldLogic()
        updateTextSize(popUpSender: sender)
    }
    
    @IBAction func fontFamilyPopUpDidChosen(_ sender: NSPopUpButton) {
        updateFieldLogic()
        updateCssField(by: sender, neededString: "font-family", needToDownCase: false)
    }
    
    @IBAction func fontStylePopUpDidChosen(_ sender: NSPopUpButton) {
        updateFieldLogic()
        updateCssField(by: sender, neededString: "font-style", needToDownCase: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: NSButton) {
        let profile = FontProfile(fontProfileTitle: fontProfileTitleTextField.stringValue == "" ? oldFontTitle : fontProfileTitleTextField.stringValue, fontSize: fontSizeTextField.stringValue == "" ? nil : fontSizeTextField.stringValue, fontFamilyIndex: fontFamilyPopUp.indexOfSelectedItem, fontStyleIndex: fontStylePopUp.indexOfSelectedItem, fontCalculageIndex: calculagePopUp.indexOfSelectedItem, additionalCSS: cssTextField.stringValue == "" ? nil : cssTextField.stringValue)
        delegate?.updateProfile(profile: profile)
        self.dismiss(self)
    }
    
    @IBAction func defaultWebPageSettingButtonTapped(_ sender: NSButton) {
        fontStylePopUp.selectItem(at: 0)
        fontFamilyPopUp.selectItem(at: 0)
        calculagePopUp.selectItem(at: 0)
        fontSizeTextField.stringValue = ""
        fontProfileTitleTextField.stringValue = oldFontTitle
        cssBlocks = []
        cssTextField.stringValue = ""
        additionalCss = ""
    }
    
    @IBAction func cancelButtonTapped(_ sender: NSButton) {
        self.dismiss(self)
    }
    private func updateCssField(by popUpButton: NSPopUpButton, neededString: String, needToDownCase: Bool){
        if popUpButton.indexOfSelectedItem != 0  {
            guard let selectedItemTitle = popUpButton.titleOfSelectedItem else {return}
            
            var hasTextNeededText = false
            for (index,cssBlock) in cssBlocks.enumerated(){
                if cssBlock.contains(neededString){
                    hasTextNeededText = true
                    cssBlocks[index] = "\(neededString):\(needToDownCase ? selectedItemTitle.lowercased() : selectedItemTitle)"
                    
                }
            }
            if hasTextNeededText == false{
                cssBlocks.append("\(neededString):\(needToDownCase ? selectedItemTitle.lowercased() : selectedItemTitle)")
            }
        }else{
            for (index,cssBlock) in cssBlocks.enumerated(){
                if cssBlock.contains(neededString){
                    cssBlocks.remove(at: index)
                }
            }
        }
        updateCssTextField()
    }
    private func updateTextSize(popUpSender: NSPopUpButton){
        if fontSizeTextField.stringValue != ""{
            var hasNeededText = false
            for (index,cssBlock) in cssBlocks.enumerated(){
                if cssBlock.contains("font-size"){
                    hasNeededText = true
                    if let titleOfItem = popUpSender.titleOfSelectedItem{
                        cssBlocks[index] = "font-size:\(fontSizeTextField.stringValue)\(titleOfItem)"
                    }
                    
                }
            }
            if hasNeededText == false{
                if let titleOfItem = popUpSender.titleOfSelectedItem{
                    cssBlocks.append("font-size:\(fontSizeTextField.stringValue)\(titleOfItem)")
                }
            }
        }else{
            for (index,block) in cssBlocks.enumerated(){
                if block.contains("font-size"){
                    cssBlocks.remove(at: index)
                }
            }
        }
        updateCssTextField()
    }
    
    private func updateCssTextField(){
        var blocks: String = ""
        
        for block in cssBlocks{
            if block != ""{
                blocks += block + (block.hasSuffix(";") ? "" : ";")
            }
        }
        
        cssTextField.stringValue = blocks + additionalCss
        additionalCss = ""
        
    }
    private func updateFieldLogic(){
        let fieldBlocks = cssTextField.stringValue.components(separatedBy: ";")
        var indisesForRemove: [Int] = []
        for block in fieldBlocks{
            if block != ""{
                if !cssBlocks.contains(block){
                    cssBlocks.append(block)
                }
            }
        }
        for (index,block) in cssBlocks.enumerated(){
            if block != ""{
                if !fieldBlocks.contains(block){
                    indisesForRemove.append(index)
                }
            }
        }
        let sortedIndises = indisesForRemove.sorted(by: >)
        for index in sortedIndises{
            cssBlocks.remove(at: index)
        }
        updateCssTextField()
    }
    
}

extension EditFontProfileViewController: NSTextFieldDelegate{
    func controlTextDidEndEditing(_ obj: Notification) {
        if obj.object as? NSTextField == fontSizeTextField{
            updateTextSize(popUpSender: calculagePopUp)
        }else if obj.object as? NSTextField == cssTextField{
            updateFieldLogic()
        }
    }
}
