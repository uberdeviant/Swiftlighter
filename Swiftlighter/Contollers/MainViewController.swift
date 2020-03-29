//
//  ViewController.swift
//  Swiftlighter
//
//  Created by Ramil Salimov on 22/03/2019.
//  Copyright © 2019 Ramil Salimov. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController, NSCollectionViewDelegate, NSCollectionViewDataSource, ColourStyleCustomizationViewControllerDelegate, EditFontProfileViewControllerDelegate {
    
    @IBOutlet var swiftTextView: NSTextView!
    @IBOutlet var outputTextView: NSTextView!
    
    @IBOutlet weak var styleTextLabel: NSTextField!
    
    @IBOutlet weak var editButton: NSButton!
    @IBOutlet weak var deleteButton: NSButton!
    
    @IBOutlet weak var fontProfilePopUp: NSPopUpButton!
    @IBOutlet weak var editFontProfileButton: NSButton!
    
    @IBOutlet weak var linkButton: NSButton!
    
    @IBOutlet weak var selectAllAndCopyButton: NSButtonCell!
    
    
    var engine: Engine!
    
    var indexOfSelectedStyle: Int? = nil {
        willSet{
            if newValue == nil{
                editButton.isEnabled = false
                deleteButton.isEnabled = false
            }else{
                editButton.isEnabled = true
                deleteButton.isEnabled = true
            }
        }
    }
    var indexOfFontProfile: Int = 0 {
        willSet{
            if newValue == 0{
                editFontProfileButton.isEnabled = false
            }else{
                editFontProfileButton.isEnabled = true
            }
        }
    }
    
    var isAddNewSegue: Bool = false
    
    @IBOutlet weak var stylesCollectionView: NSCollectionView!
    
    var colourStyles: [ColourStyle] = []
    var fontProfiles: [FontProfile] = []
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fontProfilePopUp.removeAllItems()
        linkButton.isBordered = false
        var fontTitles: [String] = []
        
        if let loadProfiles = FontProfile.load(){
            fontProfiles = loadProfiles
        }else{
            fontProfiles = [FontProfile(fontProfileTitle: "Default Web Page", fontSize: nil, fontFamilyIndex: 0, fontStyleIndex: 0, fontCalculageIndex: 0, additionalCSS: nil), FontProfile(fontProfileTitle: "Custom 1", fontSize: nil, fontFamilyIndex: 0, fontStyleIndex: 0, fontCalculageIndex: 0, additionalCSS: nil), FontProfile(fontProfileTitle: "Custom 2", fontSize: nil, fontFamilyIndex: 0, fontStyleIndex: 0, fontCalculageIndex: 0, additionalCSS: nil)]
        }
        for profile in fontProfiles{
            fontTitles.append(profile.fontProfileTitle)
        }
        fontProfilePopUp.addItems(withTitles: fontTitles)
        loadChosenFontProfileIndex()
        fontProfilePopUp.selectItem(at: indexOfFontProfile)
        
        
        
        editButton.isEnabled = false
        deleteButton.isEnabled = false
        
        if let styles = ColourStyle.load(){
            colourStyles = styles
        }else{
            colourStyles = [ColourStyle(colourStyleType: .dark), ColourStyle(colourStyleType: .space), ColourStyle(colourStyleType: .sunset), ColourStyle(colourStyleType: .light)]
        }
        
        styleTextLabel.stringValue = "Click on any Colour Style for launch..."
        swiftTextView.isAutomaticQuoteSubstitutionEnabled = false
        swiftTextView.isAutomaticDashSubstitutionEnabled = false
        outputTextView.isAutomaticQuoteSubstitutionEnabled = false
        
        let item = NSNib(nibNamed: "StylesCollectionViewItem", bundle: nil)
       
        stylesCollectionView.register(item, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "StylesCollectionViewItem"))
        stylesCollectionView.delegate = self
        stylesCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }

    
    func passColourStyle(colourStyle: ColourStyle) {
        if isAddNewSegue{
            stylesCollectionView.performBatchUpdates({
                self.colourStyles.append(colourStyle)
                var set = Set<IndexPath>()
                set.insert(IndexPath(item: self.colourStyles.count - 1, section: 0))
                self.stylesCollectionView.insertItems(at: set)
            }, completionHandler: nil)
        }else{
            guard let unwIndexOfStyle = indexOfSelectedStyle else{return}
            
            stylesCollectionView.performBatchUpdates({
                self.colourStyles[unwIndexOfStyle] = colourStyle
                var set = Set<IndexPath>()
                set.insert(IndexPath(item: unwIndexOfStyle, section: 0))
                self.stylesCollectionView.deleteItems(at: set)
                self.stylesCollectionView.insertItems(at: set)
                
                self.executeEngine()
            }, completionHandler: nil)
        }
        indexOfSelectedStyle = nil
        ColourStyle.save(colourStylesArray: colourStyles)
    }
    func updateProfile(profile: FontProfile) {
        fontProfiles[indexOfFontProfile] = profile
        fontProfilePopUp.removeAllItems()
        var profileTitles: [String] = []
        for profile in fontProfiles{
            profileTitles.append(profile.fontProfileTitle)
        }
        fontProfilePopUp.addItems(withTitles: profileTitles)
        fontProfilePopUp.selectItem(at: indexOfFontProfile)
        FontProfile.save(profileArray: fontProfiles)
        executeEngine()
    }
    
    private func setUpCustomizationContoller(styleCustomizationViewController: ColourStyleCustomizationViewController,additionalString: String){
        if let selectedIndex = indexOfSelectedStyle{
            styleCustomizationViewController.colourStyleTextField.stringValue = colourStyles[selectedIndex].title + additionalString
            styleCustomizationViewController.backgroundColourTextField.stringValue = colourStyles[selectedIndex].backgroundColour
            styleCustomizationViewController.textColourTextField.stringValue = colourStyles[selectedIndex].textColour
            styleCustomizationViewController.keywordColourWell.stringValue = colourStyles[selectedIndex].keywordColour
            styleCustomizationViewController.commentColourTextField.stringValue = colourStyles[selectedIndex].commentColour
            styleCustomizationViewController.typesColourTextField.stringValue = colourStyles[selectedIndex].typeColour
            styleCustomizationViewController.stringColourTextField.stringValue = colourStyles[selectedIndex].stringColour
            styleCustomizationViewController.numberColourTextField.stringValue = colourStyles[selectedIndex].numberColour
            
            if let borderColour = colourStyles[selectedIndex].borderColour{
                styleCustomizationViewController.isBorder = true
                styleCustomizationViewController.borderColourTextField.stringValue = borderColour
            }
        }
        
    }
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return colourStyles.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "StylesCollectionViewItem"), for: indexPath)
        guard let myItem = item as? StylesCollectionViewItem else {return item}
            let styleItem = myItem.updateItem(by: colourStyles[indexPath.item], item: myItem)
        return styleItem
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexOfSelectedStyle = indexPaths.first?.item else {return}
        self.indexOfSelectedStyle = indexOfSelectedStyle
        executeEngine()
        var set = Set<IndexPath>()
        set.insert(IndexPath(item: indexOfSelectedStyle, section: 0))
        stylesCollectionView.deselectItems(at: set)
    }
    
    private func executeEngine(){
        guard let selectedIndex = indexOfSelectedStyle else {return}
        styleTextLabel.stringValue = "Style: \(colourStyles[selectedIndex].title)"
        engine = Engine(colourStyle: colourStyles[selectedIndex], fontOptionStyle: fontProfiles[indexOfFontProfile])
        
        if swiftTextView.string == ""{
            outputTextView.string = "Output is going to be here..."
        }else{
            outputTextView.string = engine.getHtmlAndColorFields(swiftCode: swiftTextView.string)
        }
        selectAllAndCopyButton.title = "Select all and copy"
    }
    
    @IBAction func helpButtonTapped(_ sender: NSButton) {
        if let url = URL(string: "https://mr-uberdeviant.blogspot.com/p/swiftlighter.html"){
            NSWorkspace.shared.open(url)
        }
    }
    
    
    
    @IBAction func twitterButton(_ sender: NSButton) {
        if let url = URL(string: "https://twitter.com/mruberdeviant"){
            NSWorkspace.shared.open(url)
        }
    }
    
    
    @IBAction func patreonButtonTapped(_ sender: NSButton) {
        if let url = URL(string: "https://www.patreon.com/user?u=32639039"){
            NSWorkspace.shared.open(url)
        }
    }
    

    @IBAction func selectAllAndCopyButtonTapped(_ sender: NSButton) {
        guard outputTextView.string != "Output is going to be here" && outputTextView.string != "" else {return}
        outputTextView.selectAll(outputTextView.string)
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        pasteboard.setString(outputTextView.string, forType: NSPasteboard.PasteboardType.string)
        selectAllAndCopyButton.title = "Selected and copied"
        
    }
    
    @IBAction func profilePopUpButtonChoosen(_ sender: NSPopUpButton) {
        indexOfFontProfile = sender.indexOfSelectedItem
        saveChosenFontProfileIndex()
        executeEngine()
    }
    
    
    @IBAction func editProfileButtonTapped(_ sender: NSButton) {
        performSegue(withIdentifier: "editFontProfileSegue", sender: nil)
    }
    
    
    @IBAction func editButtonTapped(_ sender: NSButton) {
        isAddNewSegue = false
        performSegue(withIdentifier: "addEditSegue", sender: nil)
    }
    
    @IBAction func deleteButtonTapped(_ sender: NSButton) {
        guard let unwIndexOfStyle = indexOfSelectedStyle else{return}
        if unwIndexOfStyle < colourStyles.count{
            stylesCollectionView.performBatchUpdates({
                self.colourStyles.remove(at: unwIndexOfStyle)
                var set = Set<IndexPath>()
                set.insert(IndexPath(item: unwIndexOfStyle, section: 0))
                self.stylesCollectionView.deleteItems(at: set)
            }, completionHandler: nil)
            ColourStyle.save(colourStylesArray: colourStyles)
        }
        indexOfSelectedStyle = nil
        
        
    }
    
    @IBAction func addNewButtonTapped(_ sender: NSButton) {
        isAddNewSegue = true
        performSegue(withIdentifier: "addEditSegue", sender: nil)
    }
    
    private func saveChosenFontProfileIndex(){
        UserDefaults.standard.set(indexOfFontProfile, forKey: "swiftlighterChosenProfileIndex")
    }
    
    private func loadChosenFontProfileIndex(){
        if let loadedIndex = UserDefaults.standard.object(forKey: "swiftlighterChosenProfileIndex"){
            if let intIndex = loadedIndex as? Int{
                indexOfFontProfile = intIndex
            }
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "webPreviewSegue"{
            let webPreviewViewController = segue.destinationController as! WebPreviewViewController
            webPreviewViewController.webCode = outputTextView.string
        }else if segue.identifier == "addEditSegue"{
            let styleCustomizationViewController = segue.destinationController as! ColourStyleCustomizationViewController
            styleCustomizationViewController.delegate = self
            
            if isAddNewSegue{
                if let selectedIndex = indexOfSelectedStyle{
                    styleCustomizationViewController.isNewColour = true
                    if colourStyles.count > selectedIndex{
                        styleCustomizationViewController.colourStyleForEdit = colourStyles[selectedIndex]
                    }
                }else{
                    styleCustomizationViewController.isNewColour = false
                }
            }else{
                if let selectedIndex = indexOfSelectedStyle{
                    if selectedIndex < colourStyles.count{
                        styleCustomizationViewController.colourStyleForEdit = colourStyles[selectedIndex]
                        styleCustomizationViewController.isNewColour = false
                    }else{
                        isAddNewSegue = true
                        styleCustomizationViewController.isNewColour = true
                    }
                }
            }
        }else if segue.identifier == "editFontProfileSegue"{
            let editProfileViewController = segue.destinationController as! EditFontProfileViewController
            editProfileViewController.delegate = self
            editProfileViewController.fontProfile = fontProfiles[indexOfFontProfile]
        }
    }
    
}

