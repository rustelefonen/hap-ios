//
//  UserInfo.swift
//  HAP
//
//  Created by Fredrik Lober on 02/02/16.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit

class UserInfoIntroController: IntroContentViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var contributeLabel: UILabel!
    static let storyboardId = "userinfo"
    
    //Outlets
    @IBOutlet weak var topConstraintComplete: NSLayoutConstraint!
    @IBOutlet weak var startAppButton: UIButton!
    @IBOutlet weak var accepted: UISwitch!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var state: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var components = [[String](), ResourceList.genders, ResourceList.counties]
    
    //Lifecycle operations
    override func viewDidLoad() {
        super.viewDidLoad()
        if RemoteUserInfo.loadHasSentResearch() {
            accepted.hidden = true
            contributeLabel.hidden = true
            infoTextView.text = "Du har allerede bidratt til å forbedre vårt hjelpetilbud. Tusen takk!"
            startAppButton.setTitle("Start appen nå", forState: .Normal)
        }
        initAgeStrings()
        initTextField(gender)
        initTextField(age)
        initTextField(state)
        scrollView.alwaysBounceVertical = true
    }
    
    private func initAgeStrings(){
        for i in 13 ..< 90 { components[0].append(String(i)) }
    }
    
    func initTextField(textField:UITextField){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        textField.inputView = pickerView
        textField.inputAccessoryView = getToolbar()
        textField.alpha = accepted.on ? 1 : 0
        textField.delegate = self
    }
    
    func getToolbar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(title: "Avbryt", style: .Plain, target: self, action: #selector(cancelAction))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Velg", style: .Plain, target: scrollView, action: #selector(UIView.endEditingInFirstResponder))
        
        toolBar.items = [cancelButton, spaceButton, doneButton]
        return toolBar
    }
    
    func cancelAction() {
        if let textField = scrollView.endEditingInFirstResponder() as? UITextField{
            textField.text = nil
        }
    }
    
    @IBAction func animateInputFields(sender: AnyObject) {
        let btnY:CGFloat = accepted.on ? 380 : 240
        let btnLabel = accepted.on ? "Start appen nå" : "Nei takk, start appen nå"
        let fieldAlpha:CGFloat = accepted.on ? 1 : 0
        
        view.layoutIfNeeded()
        UIView.animateWithDuration(0.4, animations: {
            self.startAppButton.frame.origin.y = btnY
            self.topConstraintComplete.constant = btnY
            self.gender.alpha = fieldAlpha
            self.age.alpha = fieldAlpha
            self.state.alpha = fieldAlpha
            }, completion: { finished in
                self.startAppButton.setTitle(btnLabel, forState: .Normal)
        })
    }
    
    @IBAction func startProgram(sender: AnyObject) {
        if accepted.on {
            let genderIndex = ResourceList.genders.indexOf(gender.text!)
            let genderText = genderIndex != nil ? ResourceList.genderValues[genderIndex!] : ""
            RemoteUserInfo.postDataToServer(age.text, gender: genderText, county: state.text)
        }
        
        (parentViewController as? IntroPageViewController)?.finishIntro()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return componentForPickerView(pickerView).count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return componentForPickerView(pickerView)[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        switch pickerView {
        case age.inputView!: age.text = components[0][row]
        case gender.inputView!: gender.text = components[1][row]
        default: state.text = components[2][row]
        }
    }
    
    func componentForPickerView(pickerView:UIPickerView) -> [String]{
        switch pickerView {
        case age.inputView!: return components[0]
        case gender.inputView!: return components[1]
        default: return components[2]
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if let picker = textField.inputView as? UIPickerView {
            pickerView(picker, didSelectRow: picker.selectedRowInComponent(0), inComponent: 0)
        }
    }
}