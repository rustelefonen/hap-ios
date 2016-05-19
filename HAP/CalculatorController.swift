//
//  CalculatorController.swift
//  HAP
//
//  Created by Simen Fonnes on 15.03.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit

class CalculatorController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    private let pricePerGramKey = "pricePerGramKey"
    private let gramsKey = "gramsKey"
    private let gramsDecimalKey = "gramsDecimalKey"
    private let gramsTimeUnitKey = "gramsTimeUnitKey"
    
    private let gramComponent = 0
    private let gramDecimalComponent = 1
    private let gramTimeUnitComponent = 2

    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var priceInputView: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var componentsValues = [[String](), [String](), ResourceList.gramType]
    
    let preferences = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        initPickerValues()
        initPicker(pickerView)
        addDismissibleKeyboardButton()
        initPreviousValues()
        priceInputView.delegate = self
    }
    
    private func initPicker(picker: UIPickerView){
        picker.delegate = self
        picker.dataSource = self
    }
    
    private func initPreviousValues(){
        priceInputView.text = loadPricePerGram()
        pickerView.selectRow(loadGramComponent(), inComponent: gramComponent, animated: false)
        pickerView.selectRow(loadGramDecimalComponent(), inComponent: gramDecimalComponent, animated: false)
        pickerView.selectRow(loadTimeUnitComponent(), inComponent: gramTimeUnitComponent, animated: false)
    }
    
    private func addDismissibleKeyboardButton(){
        let leftButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let rightButton = UIBarButtonItem(title: "Ferdig", style: .Done, target: priceInputView, action: #selector(UIView.endEditingInFirstResponder))
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.items = [leftButton, spaceButton, rightButton]
        
        priceInputView.inputAccessoryView = toolbar;
    }
    
    private func initPickerValues() {
        for i in 0..<10 {
            componentsValues[gramComponent].append(String(i))
            componentsValues[gramDecimalComponent].append(String(i))
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if component == gramTimeUnitComponent { return componentsValues[component].count }
        return 99999 // infinite repeating wheel wanted
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        let i = row % componentsValues[component].count
        if component == gramDecimalComponent {
            return ",\(componentsValues[component][i])0g"
        }
        return componentsValues[component][i]
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let width = view.frame.width
        if component == gramComponent { return width / 10 }
        else if component == gramDecimalComponent { return width / 8 }
        else { return width / 3.5 }
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var label = view as? UILabel
        if (label == nil){
            let width = self.pickerView(pickerView, widthForComponent: component)
            label = UILabel(frame: CGRectMake(0,0, width, 44))
            
            let alignment:NSTextAlignment
            if component ==  gramComponent { alignment = .Right }
            else if component == gramDecimalComponent { alignment = .Left }
            else { alignment = .Center }
            
            label!.textAlignment = alignment
        }
        label!.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        return label!
    }
    
    @IBAction func saveToUserInfo(sender: UIBarButtonItem) {
        let pricePerGram = Int(priceInputView.text!) ?? -1
        if pricePerGram  < 1 { return displayInvalidDataAlert() }
        
        let gramIndex = pickerView.selectedRowInComponent(gramComponent) % componentsValues[gramComponent].count
        let gramDecimalIndex = pickerView.selectedRowInComponent(gramDecimalComponent) % componentsValues[gramDecimalComponent].count
        let timeUnitIndex = pickerView.selectedRowInComponent(gramTimeUnitComponent)
        let s = componentsValues[gramComponent][gramIndex] + "." + componentsValues[gramDecimalComponent][gramDecimalIndex]
        
        var gramsPerDay = Double(s) ?? 1
        if gramsPerDay == 0 { return displayInvalidDataAlert(true) }
        
        if timeUnitIndex == 1 { gramsPerDay /= 7 } //per week
        else if timeUnitIndex == 2 { gramsPerDay /= 30 } //per month
        
        saveSelectedValues()
        AppDelegate.getUserInfo()!.moneySpentPerDayOnHash = Double(pricePerGram) * gramsPerDay
        UserInfoDao().save()
        AppDelegate.initUserInfo()
        
        NotificationHandler.scheduleAchievementNotifications(AppDelegate.getUserInfo()!, force: true)
        SwiftEventBus.post(AchievementsTableController.RELOAD_ACHIEVEMENTS_EVENT)
        navigationController?.popViewControllerAnimated(true)
    }
    
    private func saveSelectedValues(){
        preferences.setObject(priceInputView.text, forKey: pricePerGramKey)
        preferences.setObject(pickerView.selectedRowInComponent(gramComponent), forKey: gramsKey)
        preferences.setObject(pickerView.selectedRowInComponent(gramDecimalComponent), forKey: gramsDecimalKey)
        preferences.setObject(pickerView.selectedRowInComponent(gramTimeUnitComponent), forKey: gramsTimeUnitKey)
    }
    
    private func displayInvalidDataAlert(usageIsZero:Bool = false){
        let content = usageIsZero ? "Forbruket kan ikke være null" : "Du må angi pris per gram før du kan lagre. \nPrisen kan ikke være null"
        let title = usageIsZero ? "Ingen forbruk" : "Angi pris per gram"
        let alert = UIAlertController(title: title, message: content, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func dismissCalc(sender: UIBarButtonItem) {
        if noChangesMade() { navigationController?.popViewControllerAnimated(true) }
        else { showUnSavedChangesNotSavedAlert() }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let length = text.utf16.count + string.utf16.count - range.length
        return length <= 3 // Bool
    }
    
    private func showUnSavedChangesNotSavedAlert() {
        let alert = UIAlertController(title: "Ikke lagret!", message: "Du har ikke lagret endringene", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Forkast", style: .Destructive, handler: { alert in self.navigationController?.popViewControllerAnimated(true) }))
        alert.addAction(UIAlertAction(title: "Avbryt", style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    private func noChangesMade() -> Bool {
        return priceInputView.text == loadPricePerGram() &&
            pickerView.selectedRowInComponent(gramComponent) == loadGramComponent() &&
            pickerView.selectedRowInComponent(gramDecimalComponent) == loadGramDecimalComponent() &&
            pickerView.selectedRowInComponent(gramTimeUnitComponent) == loadTimeUnitComponent()
    }
    
    private func loadPricePerGram() -> String {
        return preferences.stringForKey(pricePerGramKey) ?? "150"
    }
    
    private func loadGramComponent() -> Int {
        return Int(preferences.stringForKey(gramsKey) ?? "50000")!
    }
    
    private func loadGramDecimalComponent() -> Int {
        return Int(preferences.stringForKey(gramsDecimalKey) ?? "50001")!
    }
    
    private func loadTimeUnitComponent() -> Int {
        return Int(preferences.stringForKey(gramsTimeUnitKey) ?? "1")!
    }
}
