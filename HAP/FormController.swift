//
//  FormController2TableViewController.swift
//  HAP
//
//  Created by Fredrik Loberg on 13/04/16.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class FormController: UITableViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var genderInputField: UITextField!
    @IBOutlet weak var ageInputField: UITextField!
    @IBOutlet weak var titleInputField: UITextField!
    @IBOutlet weak var countyInputField: UITextField!
    @IBOutlet weak var questionLabel: UILabel!
    var activeTextField: UITextField! //Used for keyboard scroll to visibility
    
    var components = [[String](), ResourceList.genders, ResourceList.counties]
    
    @IBOutlet weak var infoHeaderCell: UITableViewCell!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0)
        initAgeStrings()
        initTextField(genderInputField)
        initTextField(ageInputField)
        initTextField(countyInputField)
        titleInputField.returnKeyType = .done
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
    }
    
    func getToolbar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Velg", style: .plain, target: tableView, action: #selector(UIView.endEditingInFirstResponder))
        
        toolBar.items = [spaceButton, doneButton]
        return toolBar
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return componentForPickerView(pickerView).count
    }
    
    func componentForPickerView(_ pickerView:UIPickerView) -> [String]{
        switch pickerView {
        case ageInputField.inputView!: return components[0]
        case genderInputField.inputView!: return components[1]
        default: return components[2]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return componentForPickerView(pickerView)[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        switch pickerView {
        case ageInputField.inputView!: ageInputField.text = components[0][row]
        case genderInputField.inputView!: genderInputField.text = components[1][row]
        default: countyInputField.text = components[2][row]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tableSelection = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: tableSelection, animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //such hack?
        activeTextField = textField
        perform(#selector(scrollToMakeVisible), with: self, afterDelay: 0.1)
        
        if let picker = textField.inputView as? UIPickerView {
            pickerView(picker, didSelectRow: picker.selectedRow(inComponent: 0), inComponent: 0)
        }
    }
    
    func scrollToMakeVisible(){
        let cell = activeTextField.superview!.superview! //contentView -> actuall cell
        var centeredRect = cell.frame
        centeredRect.origin.y += 100
        
        tableView.scrollRectToVisible(centeredRect, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ((indexPath as NSIndexPath).section, (indexPath as NSIndexPath).row) != (3, 0) { return }
        tableView.deselectRow(at: indexPath, animated: true)
        
        if genderInputField.text?.trimmingCharacters(in: CharacterSet.whitespaces).characters.count < 1 {
            presentValidationAlert("Kjønn mangler", content: "Du må anngi kjønn for å sende inn spørsmålet.")
        } else if ageInputField.text?.trimmingCharacters(in: CharacterSet.whitespaces).characters.count < 1 {
            presentValidationAlert("Alder mangler", content: "Du må anngi alder for å sende inn spørsmålet.")
        } else if countyInputField.text?.trimmingCharacters(in: CharacterSet.whitespaces).characters.count < 1 {
            presentValidationAlert("Fylke mangler", content: "Du må anngi fylke for å sende inn spørsmålet.")
        } else if titleInputField.text?.trimmingCharacters(in: CharacterSet.whitespaces).characters.count < 1 {
            presentValidationAlert("Spørsmålstittel mangler", content: "Du må anngi spørsmålstittel for å sende inn spørsmålet.")
        } else if questionLabel.text?.trimmingCharacters(in: CharacterSet.whitespaces).characters.count < 1 {
            presentValidationAlert("Spørsmålsinnhold mangler", content: "Du må anngi spørsmålsinnhold for å sende inn spørsmålet.")
        } else {
            postDataToServer()
        }
    }
    
    fileprivate func presentValidationAlert(_ title:String, content:String) {
        let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? QuestionController {
            vc.questionLabel = questionLabel
        }
        activeTextField?.endEditingInFirstResponder()
    }
    
    fileprivate func postDataToServer() {
        let params = [
            ("user-submitted-sex", genderInputField.text!),
            ("user-submitted-age", ageInputField.text!),
            ("user-submitted-county", countyInputField.text!),
            ("user-submitted-title", titleInputField.text!),
            ("user-submitted-captcha", "5"),
            ("user-submitted-content", questionLabel.text! + "\n\nSendt fra iOS-applikasjonen"),
            ("user-submitted-category", "17"),
            ("user-submitted-post", "Send inn ditt spørsmål!")
        ]
        
        let request = NSMutableURLRequest(url: URL(string: "http://www.rustelefonen.no/still-sporsmal")!)
        request.httpMethod =  "POST"
        request.addValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = parseParams(params).data(using: String.Encoding.utf8)
        let loadingDialog = showLoadingDialog()
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {data, response, error in self.onResponse(data, loadingDialog: loadingDialog)}).resume()
    }
    
    fileprivate func parseParams(_ params:[(String, String)]) -> String{
        var paramBody = ""
        for p in params { paramBody += "\(p.0)=\(p.1)&" }
        
        return String(paramBody.characters.dropLast()).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
    
    fileprivate func showLoadingDialog() -> UIAlertController{
        let alert = UIAlertController(title: "Sender spørsmål...", message: nil, preferredStyle: .alert)
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.startAnimating()
        
        let cvc = UIViewController()
        cvc.view.addSubview(indicator)
        cvc.view!.addConstraint(NSLayoutConstraint(item: indicator, attribute: .centerX, relatedBy: .equal, toItem: cvc.view!, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        cvc.view!.addConstraint(NSLayoutConstraint(item: indicator, attribute: .centerY, relatedBy: .equal, toItem: cvc.view!, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        alert.view.addConstraint(NSLayoutConstraint(item: alert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 105))
        alert.setValue(cvc, forKey: "contentViewController")
        
        present(alert, animated: true, completion: nil)
        return alert
    }
    
    fileprivate func onResponse(_ data:Data?, loadingDialog:UIAlertController){
        loadingDialog.dismiss(animated: true, completion: nil)
        if data == nil { return showErrorOccouredDialog() }
        showConfirmationDialog()
    }
    
    fileprivate func showConfirmationDialog() {
        let content = "Svaret vil bli publisert på www.rustelefonen.no i løpet av 7 dager."
        let alert = UIAlertController(title: "Spørsmålet er sendt!", message: content, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in self.navigationController?.popViewController(animated: true)}))
        present(alert, animated: true, completion: nil)
    }
            
    fileprivate func showErrorOccouredDialog() {
        let content = "En feil oppstod\n\n Sjekk din nettverkstilkobling."
        let alert = UIAlertController(title: "Feil!", message: content, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func navigateToQuestionForm(_ sender: UIButton) {
        UIApplication.shared.openURL(URL(string: "http://www.rustelefonen.no/besvarte-sporsmal-og-svar/")!)
    }
}
