//
//  CalculatorController.swift
//  HAP
//
//  Created by Simen Fonnes on 15.03.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit

class CalculatorController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    fileprivate let pricePerGramKey = "pricePerGramKey"
    fileprivate let gramsKey = "gramsKey"
    fileprivate let gramsDecimalKey = "gramsDecimalKey"
    fileprivate let gramsTimeUnitKey = "gramsTimeUnitKey"
    
    fileprivate let gramComponent = 0
    fileprivate let gramDecimalComponent = 1
    fileprivate let gramTimeUnitComponent = 2

    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var priceInputView: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var componentsValues = [[String](), [String](), ResourceList.gramType]
    
    let preferences = UserDefaults.standard
    
    override func viewDidLoad() {
        initPickerValues()
        initPicker(pickerView)
        addDismissibleKeyboardButton()
        initPreviousValues()
        priceInputView.delegate = self
    }
    
    fileprivate func initPicker(_ picker: UIPickerView){
        picker.delegate = self
        picker.dataSource = self
    }
    
    fileprivate func initPreviousValues(){
        priceInputView.text = loadPricePerGram()
        pickerView.selectRow(loadGramComponent(), inComponent: gramComponent, animated: false)
        pickerView.selectRow(loadGramDecimalComponent(), inComponent: gramDecimalComponent, animated: false)
        pickerView.selectRow(loadTimeUnitComponent(), inComponent: gramTimeUnitComponent, animated: false)
    }
    
    fileprivate func addDismissibleKeyboardButton(){
        let leftButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let rightButton = UIBarButtonItem(title: "Ferdig", style: .done, target: priceInputView, action: #selector(UIView.endEditingInFirstResponder))
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.items = [leftButton, spaceButton, rightButton]
        
        priceInputView.inputAccessoryView = toolbar;
    }
    
    fileprivate func initPickerValues() {
        for i in 0..<10 {
            componentsValues[gramComponent].append(String(i))
            componentsValues[gramDecimalComponent].append(String(i))
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if component == gramTimeUnitComponent { return componentsValues[component].count }
        return 99999 // infinite repeating wheel wanted
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        let i = row % componentsValues[component].count
        if component == gramDecimalComponent {
            return ",\(componentsValues[component][i])0g"
        }
        return componentsValues[component][i]
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let width = view.frame.width
        if component == gramComponent { return width / 10 }
        else if component == gramDecimalComponent { return width / 8 }
        else { return width / 3.5 }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as? UILabel
        if (label == nil){
            let width = self.pickerView(pickerView, widthForComponent: component)
            label = UILabel(frame: CGRect(x: 0,y: 0, width: width, height: 44))
            
            let alignment:NSTextAlignment
            if component ==  gramComponent { alignment = .right }
            else if component == gramDecimalComponent { alignment = .left }
            else { alignment = .center }
            
            label!.textAlignment = alignment
        }
        label!.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        return label!
    }
    
    @IBAction func saveToUserInfo(_ sender: UIBarButtonItem) {
        let pricePerGram = Int(priceInputView.text!) ?? -1
        if pricePerGram  < 1 { return displayInvalidDataAlert() }
        
        let gramIndex = pickerView.selectedRow(inComponent: gramComponent) % componentsValues[gramComponent].count
        let gramDecimalIndex = pickerView.selectedRow(inComponent: gramDecimalComponent) % componentsValues[gramDecimalComponent].count
        let timeUnitIndex = pickerView.selectedRow(inComponent: gramTimeUnitComponent)
        let s = componentsValues[gramComponent][gramIndex] + "." + componentsValues[gramDecimalComponent][gramDecimalIndex]
        
        var gramsPerDay = Double(s) ?? 1
        if gramsPerDay == 0 { return displayInvalidDataAlert(true) }
        
        if timeUnitIndex == 1 { gramsPerDay /= 7 } //per week
        else if timeUnitIndex == 2 { gramsPerDay /= 30 } //per month
        
        saveSelectedValues()
        AppDelegate.getUserInfo()!.moneySpentPerDayOnHash = NSNumber(value: Double(pricePerGram) * gramsPerDay)
        UserInfoDao().save()
        AppDelegate.initUserInfo()
        
        NotificationHandler.scheduleAchievementNotifications(AppDelegate.getUserInfo()!, force: true)
        SwiftEventBus.post(AchievementsTableController.RELOAD_ACHIEVEMENTS_EVENT)
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func saveSelectedValues(){
        preferences.set(priceInputView.text, forKey: pricePerGramKey)
        preferences.set(pickerView.selectedRow(inComponent: gramComponent), forKey: gramsKey)
        preferences.set(pickerView.selectedRow(inComponent: gramDecimalComponent), forKey: gramsDecimalKey)
        preferences.set(pickerView.selectedRow(inComponent: gramTimeUnitComponent), forKey: gramsTimeUnitKey)
    }
    
    fileprivate func displayInvalidDataAlert(_ usageIsZero:Bool = false){
        let content = usageIsZero ? "Forbruket kan ikke være null" : "Du må angi pris per gram før du kan lagre. \nPrisen kan ikke være null"
        let title = usageIsZero ? "Ingen forbruk" : "Angi pris per gram"
        let alert = UIAlertController(title: title, message: content, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func dismissCalc(_ sender: UIBarButtonItem) {
        if noChangesMade() { navigationController?.popViewController(animated: true) }
        else { showUnSavedChangesNotSavedAlert() }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let length = text.utf16.count + string.utf16.count - range.length
        return length <= 3 // Bool
    }
    
    fileprivate func showUnSavedChangesNotSavedAlert() {
        let alert = UIAlertController(title: "Ikke lagret!", message: "Du har ikke lagret endringene", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Forkast", style: .destructive, handler: { alert in self.navigationController?.popViewController(animated: true) }))
        alert.addAction(UIAlertAction(title: "Avbryt", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func noChangesMade() -> Bool {
        return priceInputView.text == loadPricePerGram() &&
            pickerView.selectedRow(inComponent: gramComponent) == loadGramComponent() &&
            pickerView.selectedRow(inComponent: gramDecimalComponent) == loadGramDecimalComponent() &&
            pickerView.selectedRow(inComponent: gramTimeUnitComponent) == loadTimeUnitComponent()
    }
    
    fileprivate func loadPricePerGram() -> String {
        return preferences.string(forKey: pricePerGramKey) ?? "150"
    }
    
    fileprivate func loadGramComponent() -> Int {
        return Int(preferences.string(forKey: gramsKey) ?? "50000")!
    }
    
    fileprivate func loadGramDecimalComponent() -> Int {
        return Int(preferences.string(forKey: gramsDecimalKey) ?? "50001")!
    }
    
    fileprivate func loadTimeUnitComponent() -> Int {
        return Int(preferences.string(forKey: gramsTimeUnitKey) ?? "1")!
    }
}
