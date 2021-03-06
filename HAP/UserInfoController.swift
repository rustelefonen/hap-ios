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
    @IBOutlet weak var userType: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var components = [[String](), ResourceList.genders, ResourceList.counties, ResourceList.userTypes]
    
    //Lifecycle operations
    override func viewDidLoad() {
        super.viewDidLoad()
        if RemoteUserInfo.loadHasSentResearch() {
            accepted.isHidden = true
            contributeLabel.isHidden = true
            infoTextView.text = "Du har allerede bidratt til å forbedre vårt hjelpetilbud. Tusen takk!"
            startAppButton.setTitle("Start appen nå", for: UIControlState())
        }
        initAgeStrings()
        initTextField(gender)
        initTextField(age)
        initTextField(state)
        initTextField(userType)
        scrollView.alwaysBounceVertical = true
    }
    
    fileprivate func initAgeStrings(){
        for i in 13 ..< 90 { components[0].append(String(i)) }
    }
    
    func initTextField(_ textField:UITextField){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        textField.inputView = pickerView
        textField.inputAccessoryView = getToolbar()
        textField.alpha = accepted.isOn ? 1 : 0
        textField.delegate = self
    }
    
    func getToolbar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(title: "Avbryt", style: .plain, target: self, action: #selector(cancelAction))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Velg", style: .plain, target: scrollView, action: #selector(UIView.endEditingInFirstResponder))
        
        toolBar.items = [cancelButton, spaceButton, doneButton]
        return toolBar
    }
    
    func cancelAction() {
        if let textField = scrollView.endEditingInFirstResponder() as? UITextField{
            textField.text = nil
        }
    }
    
    @IBAction func animateInputFields(_ sender: AnyObject) {
        let btnY:CGFloat = accepted.isOn ? 440 : 240
        let btnLabel = accepted.isOn ? "Start appen nå" : "Nei takk, start appen nå"
        let fieldAlpha:CGFloat = accepted.isOn ? 1 : 0
        
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.4, animations: {
            self.startAppButton.frame.origin.y = btnY
            self.topConstraintComplete.constant = btnY
            self.gender.alpha = fieldAlpha
            self.age.alpha = fieldAlpha
            self.state.alpha = fieldAlpha
            self.userType.alpha = fieldAlpha
            }, completion: { finished in
                self.startAppButton.setTitle(btnLabel, for: UIControlState())
        })
    }
    
    @IBAction func startProgram(_ sender: AnyObject) {
        self.performSegue(withIdentifier: PrivacyViewController.storyboardId, sender: nil)
        /*let content = "Dersom du vil bruke appen, må du akseptere vår personvernerklæring."
        let alert = UIAlertController(title: "Personvernerklæring", message: content, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Les vår erklæring", style: .default, handler: {
            alert in
            self.performSegue(withIdentifier: PrivacyViewController.storyboardId, sender: nil)
        }))
        alert.addAction(UIAlertAction(title: "Jeg aksepterer", style: .default, handler: {
            alert in
            if self.accepted.isOn {
                let genderIndex = ResourceList.genders.index(of: self.gender.text!)
                let genderText = genderIndex != nil ? ResourceList.genderValues[genderIndex!] : ""
                RemoteUserInfo.postDataToServer(self.age.text, gender: genderText, county: self.state.text, userType: self.userType.text)
            }
            (self.parent as? IntroPageViewController)?.finishIntro()
        }))
        alert.addAction(UIAlertAction(title: "Avbryt", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)*/
    }
    
    func startProgramFromPrivacyController() {
        if self.accepted.isOn {
            let genderIndex = ResourceList.genders.index(of: self.gender.text!)
            let genderText = genderIndex != nil ? ResourceList.genderValues[genderIndex!] : ""
            RemoteUserInfo.postDataToServer(self.age.text, gender: genderText, county: self.state.text, userType: self.userType.text)
        }
        (self.parent as? IntroPageViewController)?.finishIntro()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return componentForPickerView(pickerView).count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return componentForPickerView(pickerView)[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        switch pickerView {
        case age.inputView!: age.text = components[0][row]
        case gender.inputView!: gender.text = components[1][row]
        case state.inputView!: state.text = components[2][row]
        default: userType.text = components[3][row]
        }
    }
    
    func componentForPickerView(_ pickerView:UIPickerView) -> [String]{
        switch pickerView {
        case age.inputView!: return components[0]
        case gender.inputView!: return components[1]
        case state.inputView!: return components[2]
        default: return components[3]
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let picker = textField.inputView as? UIPickerView {
            pickerView(picker, didSelectRow: picker.selectedRow(inComponent: 0), inComponent: 0)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == PrivacyViewController.storyboardId {
            let destinationVC = segue.destination.childViewControllers.first as? PrivacyViewController
            destinationVC?.userInfoController = self
        }
    }
}
