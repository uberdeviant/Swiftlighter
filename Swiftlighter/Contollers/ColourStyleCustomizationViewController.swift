//
//  ColourStyleCustomizationViewController.swift
//  Swiftlighter
//
//  Created by Ramil Salimov on 27/03/2019.
//  Copyright © 2019 Ramil Salimov. All rights reserved.
//

import Cocoa

protocol ColourStyleCustomizationViewControllerDelegate: class{
    func passColourStyle(colourStyle: ColourStyle)
}

class ColourStyleCustomizationViewController: NSViewController{
    
    
    @IBOutlet weak var colourStyleTextField: NSTextField!
    
    @IBOutlet weak var backgroundColourWell: NSColorWell!
    @IBOutlet weak var backgroundColourTextField: NSTextField!
    
    @IBOutlet weak var texColourColourWell: NSColorWell!
    @IBOutlet weak var textColourTextField: NSTextField!
    
    @IBOutlet weak var keywordColourWell: NSColorWell!
    @IBOutlet weak var keywordColourTextField: NSTextField!
    
    @IBOutlet weak var commentColourWell: NSColorWell!
    @IBOutlet weak var commentColourTextField: NSTextField!
    
    @IBOutlet weak var propertiesColourWell: NSColorWell!
    @IBOutlet weak var propertiesTextField: NSTextField!
    
    @IBOutlet weak var methodsColourWell: NSColorWell!
    @IBOutlet weak var methodsTextField: NSTextField!
    
    @IBOutlet weak var typesColourWell: NSColorWell!
    @IBOutlet weak var typesColourTextField: NSTextField!
    
    @IBOutlet weak var stringColourWell: NSColorWell!
    @IBOutlet weak var stringColourTextField: NSTextField!
    
    @IBOutlet weak var numberColourWell: NSColorWell!
    @IBOutlet weak var numberColourTextField: NSTextField!
    
    
    @IBOutlet weak var borderColourWell: NSColorWell!
    @IBOutlet weak var borderColourTextField: NSTextField!
    
    @IBOutlet weak var borderButton: NSButton!
    
    @IBOutlet weak var borderHashtagText: NSTextField!
    
    @IBOutlet weak var exampleBox: NSBox!
    
    @IBOutlet weak var exampleKeywordText: NSTextField!
    @IBOutlet weak var exampleText: NSTextField!
    
    @IBOutlet weak var exampleText1: NSTextField!
    @IBOutlet weak var exampleNumber: NSTextField!
    @IBOutlet weak var exampleKeywordText1: NSTextField!
    @IBOutlet weak var exampleText2: NSTextField!
    @IBOutlet weak var exampleText3: NSTextField!
    @IBOutlet weak var exampleText4: NSTextField!
    @IBOutlet weak var exampleText5: NSTextField!
    
    @IBOutlet weak var exampleMethodText: NSTextField!
    @IBOutlet weak var examplePropertyText: NSTextField!
    
    @IBOutlet weak var exampleTypeText1: NSTextField!
    @IBOutlet weak var exampleTypeText: NSTextField!
    
    @IBOutlet weak var exampleTextString: NSTextField!
    @IBOutlet weak var exampleCommentText: NSTextField!
    
    @IBOutlet weak var saveButton: NSButton!
    
    
    var colourStyleForEdit: ColourStyle?
    var isNewColour: Bool!
    
    weak var delegate: ColourStyleCustomizationViewControllerDelegate?
    
    var isBorder: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectDelegate()
        
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        exampleBox.boxType = .custom
        exampleBox.borderType = .lineBorder
        updateByStyleToEdit()
        
        if colourStyleForEdit?.borderColour != nil{
            isBorder = true
        }
        
        if isBorder == false{
            exampleBox.borderColor = backgroundColourWell.color
            borderButton.state = .off
            borderColourWell.isHidden = true
            borderColourTextField.isHidden = true
            borderHashtagText.isHidden = true
        }else{
            borderButton.state = .on
            exampleBox.borderColor = borderColourWell.color
            borderColourWell.isHidden = false
            borderColourTextField.isHidden = false
            borderHashtagText.isHidden = false
        }
        updatePreview()
        
        if colourStyleTextField.stringValue == ""{
            saveButton.isEnabled = false
        }else{
            saveButton.isEnabled = true
        }
    }
    
    @IBAction func backgroundColourChanged(_ sender: NSColorWell) {
        update(textField: backgroundColourTextField, by: sender)
        updatePreview()
    }
    
    @IBAction func textColourChanged(_ sender: NSColorWell) {
        update(textField: textColourTextField, by: sender)
        updatePreview()
    }
    
    @IBAction func keyWordColourChanged(_ sender: NSColorWell) {
        update(textField: keywordColourTextField, by: sender)
        updatePreview()
    }
    
    @IBAction func commentColourChanged(_ sender: NSColorWell) {
        update(textField: commentColourTextField, by: sender)
        updatePreview()
    }
    
    @IBAction func typeColourChanged(_ sender: NSColorWell) {
        update(textField: typesColourTextField, by: sender)
        updatePreview()
    }
    
    @IBAction func stringColourChanged(_ sender: NSColorWell) {
        update(textField: stringColourTextField, by: sender)
        updatePreview()
    }
    
    @IBAction func numberColourChanged(_ sender: NSColorWell) {
        update(textField: numberColourTextField, by: sender)
        updatePreview()
    }
    
    @IBAction func borderColourChanged(_ sender: NSColorWell) {
        update(textField: borderColourTextField, by: sender)
        updatePreview()
    }
    
    @IBAction func parametersColourChanged(_ sender: NSColorWell) {
        update(textField: propertiesTextField, by: sender)
        updatePreview()
        
    }
    
    
    @IBAction func methodsColourChanged(_ sender: NSColorWell) {
        update(textField: methodsTextField, by: sender)
        updatePreview()
    }
    
    
    
    @IBAction func borderCheckButtonTapped(_ sender: NSButtonCell) {
        if isBorder{
            isBorder = false
            borderColourWell.isHidden = true
            borderColourTextField.isHidden = true
            borderHashtagText.isHidden = true
            exampleBox.borderColor = backgroundColourWell.color
        }else{
            isBorder = true
            borderColourWell.isHidden = false
            borderColourTextField.isHidden = false
            borderHashtagText.isHidden = false
            exampleBox.borderColor = borderColourWell.color
            
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: NSButton) {
        self.dismiss(self)
    }
    
    @IBAction func saveButtonTapped(_ sender: NSButton) {
        var colourTitle = ""
        var backgroundColour = ""
        var keywordColour = ""
        var textColour = ""
        var commentColour = ""
        var propertyColour = ""
        var methodsColour = ""
        var stringColour = ""
        var numberColour = ""
        var typeColour = ""
        var borderColour: String? = nil
        
        if colourStyleTextField.stringValue == ""{
            colourTitle = "Custom Colour"
        }else{
            colourTitle = colourStyleTextField.stringValue
        }
        
        if backgroundColourTextField.stringValue == ""{
            if let placeHolder = backgroundColourTextField.placeholderString{
                backgroundColour = "#" + placeHolder
            }
        }else{
            backgroundColour = "#" + backgroundColourTextField.stringValue
        }
        
        if keywordColourTextField.stringValue == ""{
            if let placeHolder = keywordColourTextField.placeholderString{
                keywordColour = "#" + placeHolder
            }
        }else{
            keywordColour = "#" + keywordColourTextField.stringValue
        }
        
        if textColourTextField.stringValue == ""{
            if let placeHolder = textColourTextField.placeholderString{
                textColour = "#" + placeHolder
            }
        }else{
            textColour = "#" + textColourTextField.stringValue
        }
        
        if commentColourTextField.stringValue == ""{
            if let placeHolder = commentColourTextField.placeholderString{
                commentColour = "#" + placeHolder
            }
        }else{
            commentColour = "#" + commentColourTextField.stringValue
        }
        
        if propertiesTextField.stringValue == ""{
            if let placeHolder = propertiesTextField.placeholderString{
                propertyColour = "#" + placeHolder
            }
        }else{
            propertyColour = "#" + propertiesTextField.stringValue
        }
        
        if methodsTextField.stringValue == ""{
            if let placeHolder = methodsTextField.placeholderString{
                methodsColour = "#" + placeHolder
            }
        }else{
            methodsColour = "#" + methodsTextField.stringValue
        }
        
        if stringColourTextField.stringValue == ""{
            if let placeHolder = stringColourTextField.placeholderString{
                stringColour = "#" + placeHolder
            }
        }else{
            stringColour = "#" + stringColourTextField.stringValue
        }
        
        if numberColourTextField.stringValue == ""{
            if let placeHolder = numberColourTextField.placeholderString{
                numberColour = "#" + placeHolder
            }
        }else{
            numberColour = "#" + numberColourTextField.stringValue
        }
        
        if typesColourTextField.stringValue == ""{
            if let placeHolder = typesColourTextField.placeholderString{
                typeColour = "#" + placeHolder
            }
        }else{
            typeColour = "#" + typesColourTextField.stringValue
        }
        
        if isBorder{
            if borderColourTextField.stringValue == ""{
                if let placeHolder = borderColourTextField.placeholderString{
                    borderColour = "#" + placeHolder
                }
            }else{
                borderColour = "#" + borderColourTextField.stringValue
            }
        }else{
            borderColour = nil
        }
        
        let colourStyle = ColourStyle(title: colourTitle, backgroundColour: backgroundColour, keywordColour: keywordColour, textColour: textColour, commentColour: commentColour, propertyColour: propertyColour, methodColour: methodsColour, stringColour: stringColour, numberColour: numberColour, typeColour: typeColour, borderColour: borderColour)
        delegate?.passColourStyle(colourStyle: colourStyle)
        self.dismiss(self)
        
    }
    
    
    func updatePreview(){
        exampleBox.fillColor = backgroundColourWell.color
        if isBorder{
            exampleBox.borderColor = borderColourWell.color
        }else{
            exampleBox.borderColor = backgroundColourWell.color
        }
        exampleKeywordText.textColor = keywordColourWell.color
        exampleKeywordText1.textColor = keywordColourWell.color
        exampleText.textColor = texColourColourWell.color
        exampleText1.textColor = texColourColourWell.color
        exampleText2.textColor = texColourColourWell.color
        exampleText3.textColor = texColourColourWell.color
        exampleText4.textColor = texColourColourWell.color
        exampleText5.textColor = texColourColourWell.color
        exampleMethodText.textColor = methodsColourWell.color
        examplePropertyText.textColor = propertiesColourWell.color
        exampleTypeText.textColor = typesColourWell.color
        exampleTypeText1.textColor = typesColourWell.color
        exampleNumber.textColor = numberColourWell.color
        exampleTextString.textColor = stringColourWell.color
        exampleCommentText.textColor = commentColourWell.color
    }
    
    func connectDelegate(){
        self.colourStyleTextField.delegate = self
        self.backgroundColourTextField.delegate = self
        self.textColourTextField.delegate = self
        self.keywordColourTextField.delegate = self
        self.commentColourTextField.delegate = self
        self.typesColourTextField.delegate = self
        self.stringColourTextField.delegate = self
        self.numberColourTextField.delegate = self
        self.backgroundColourTextField.delegate = self
        self.methodsTextField.delegate = self
        self.propertiesTextField.delegate = self
        
    }
    
    func update(colourWell: NSColorWell, by textField: NSTextField){
        guard textField.stringValue.count >= 6 && textField.stringValue.count <= 8 else{return}
        if textField.stringValue.hasPrefix("#"){
            if let hexColour = NSColor(hexString: textField.stringValue + "ff"){
                colourWell.color = hexColour
            }
        }else{
            if let hexColour = NSColor(hexString: "#" + textField.stringValue + "ff"){
                colourWell.color = hexColour
            }
        }
    }
    
    func update(textField: NSTextField, by colourWell: NSColorWell){
        if let hexString = colourWell.color.converToHex(){
            textField.stringValue = hexString
        }
    }
    private func updateByStyleToEdit(){
        if let colourForEdit = colourStyleForEdit{
            var colourText = colourForEdit.title + (isNewColour ? " Based" : "")
            colourStyleTextField.stringValue = colourText
            
            colourText = colourForEdit.backgroundColour
            if colourText.first == "#"{
                colourText.removeFirst()
            }
            backgroundColourTextField.stringValue = colourText
            update(colourWell: backgroundColourWell, by: backgroundColourTextField)
            
            colourText = colourForEdit.textColour
            if colourText.first == "#"{
                colourText.removeFirst()
            }
            textColourTextField.stringValue = colourText
            update(colourWell: texColourColourWell, by: textColourTextField)
            
            colourText = colourForEdit.keywordColour
            if colourText.first == "#"{
                colourText.removeFirst()
            }
            keywordColourTextField.stringValue = colourText
            update(colourWell: keywordColourWell, by: keywordColourTextField)
            
            colourText = colourForEdit.methodColour
            if colourText.first == "#"{
                colourText.removeFirst()
            }
            methodsTextField.stringValue = colourText
            update(colourWell: methodsColourWell, by: methodsTextField)
            
            colourText = colourForEdit.propertyColour
            if colourText.first == "#"{
                colourText.removeFirst()
            }
            propertiesTextField.stringValue = colourText
            update(colourWell: propertiesColourWell, by: propertiesTextField)
            
            colourText = colourForEdit.commentColour
            if colourText.first == "#"{
                colourText.removeFirst()
            }
            commentColourTextField.stringValue = colourText
            update(colourWell: commentColourWell, by: commentColourTextField)
            
            colourText = colourForEdit.typeColour
            if colourText.first == "#"{
                colourText.removeFirst()
            }
            typesColourTextField.stringValue = colourText
            update(colourWell: typesColourWell, by: typesColourTextField)
            
            colourText = colourForEdit.stringColour
            if colourText.first == "#"{
                colourText.removeFirst()
            }
            stringColourTextField.stringValue = colourText
            update(colourWell: stringColourWell, by: stringColourTextField)
            
            colourText = colourForEdit.numberColour
            if colourText.first == "#"{
                colourText.removeFirst()
            }
            numberColourTextField.stringValue = colourText
            update(colourWell: numberColourWell, by: numberColourTextField)
            
            if let borderColour = colourForEdit.borderColour{
                
                colourText = borderColour
                if colourText.first == "#"{
                    colourText.removeFirst()
                }
                
                isBorder = true
                borderColourTextField.stringValue = colourText
                update(colourWell: borderColourWell, by: borderColourTextField)
            }
        }else{
            colourStyleTextField.stringValue = ""
            backgroundColourTextField.stringValue = ""
            textColourTextField.stringValue = ""
            keywordColourTextField.stringValue = ""
            commentColourTextField.stringValue = ""
            typesColourTextField.stringValue = ""
            stringColourTextField.stringValue = ""
            numberColourTextField.stringValue = ""
            borderColourTextField.stringValue = ""
            methodsTextField.stringValue = ""
            propertiesTextField.stringValue = ""
        }
    }
    
    
}

extension ColourStyleCustomizationViewController: NSTextFieldDelegate{
    
    
    func controlTextDidEndEditing(_ obj: Notification) {
        
        if let textField = obj.object as? NSTextField{
            switch textField{
            case backgroundColourTextField:
                update(colourWell: backgroundColourWell, by: backgroundColourTextField)
            case textColourTextField:
                update(colourWell: texColourColourWell, by: textColourTextField)
            case keywordColourTextField:
                update(colourWell: keywordColourWell, by: keywordColourTextField)
            case commentColourTextField:
                update(colourWell: commentColourWell, by: commentColourTextField)
            case typesColourTextField:
                update(colourWell: typesColourWell, by: typesColourTextField)
            case stringColourTextField:
                update(colourWell: stringColourWell, by: stringColourTextField)
            case numberColourTextField:
                update(colourWell: numberColourWell, by: numberColourTextField)
            case borderColourTextField:
                update(colourWell: borderColourWell, by: numberColourTextField)
            case methodsTextField:
                update(colourWell: methodsColourWell, by: methodsTextField)
            case propertiesTextField:
                update(colourWell: propertiesColourWell, by: propertiesTextField)
            default: ()
            }
            updatePreview()
        }
    }
    
    func controlTextDidChange(_ obj: Notification) {
        if let textField = obj.object as? NSTextField{
            if textField == colourStyleTextField{
                if textField.stringValue == ""{
                    saveButton.isEnabled = false
                }else{
                    saveButton.isEnabled = true
                }
            }
        }
    }
}
