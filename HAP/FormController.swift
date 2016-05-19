//
//  FormController2TableViewController.swift
//  HAP
//
//  Created by Fredrik Loberg on 13/04/16.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit

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
        titleInputField.returnKeyType = .Done
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
    }
    
    func getToolbar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Velg", style: .Plain, target: tableView, action: #selector(UIView.endEditingInFirstResponder))
        
        toolBar.items = [spaceButton, doneButton]
        return toolBar
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return componentForPickerView(pickerView).count
    }
    
    func componentForPickerView(pickerView:UIPickerView) -> [String]{
        switch pickerView {
        case ageInputField.inputView!: return components[0]
        case genderInputField.inputView!: return components[1]
        default: return components[2]
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return componentForPickerView(pickerView)[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        switch pickerView {
        case ageInputField.inputView!: ageInputField.text = components[0][row]
        case genderInputField.inputView!: genderInputField.text = components[1][row]
        default: countyInputField.text = components[2][row]
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let tableSelection = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(tableSelection, animated: true)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //such hack?
        activeTextField = textField
        performSelector(#selector(scrollToMakeVisible), withObject: self, afterDelay: 0.1)
        
        if let picker = textField.inputView as? UIPickerView {
            pickerView(picker, didSelectRow: picker.selectedRowInComponent(0), inComponent: 0)
        }
    }
    
    func scrollToMakeVisible(){
        let cell = activeTextField.superview!.superview! //contentView -> actuall cell
        var centeredRect = cell.frame
        centeredRect.origin.y += 100
        
        tableView.scrollRectToVisible(centeredRect, animated: true)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section, indexPath.row) != (3, 0) { return }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if genderInputField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).characters.count < 1 {
            presentValidationAlert("Kjønn mangler", content: "Du må anngi kjønn for å sende inn spørsmålet.")
        } else if ageInputField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).characters.count < 1 {
            presentValidationAlert("Alder mangler", content: "Du må anngi alder for å sende inn spørsmålet.")
        } else if countyInputField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).characters.count < 1 {
            presentValidationAlert("Fylke mangler", content: "Du må anngi fylke for å sende inn spørsmålet.")
        } else if titleInputField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).characters.count < 1 {
            presentValidationAlert("Spørsmålstittel mangler", content: "Du må anngi spørsmålstittel for å sende inn spørsmålet.")
        } else if questionLabel.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).characters.count < 1 {
            presentValidationAlert("Spørsmålsinnhold mangler", content: "Du må anngi spørsmålsinnhold for å sende inn spørsmålet.")
        } else {
            postDataToServer()
        }
    }
    
    private func presentValidationAlert(title:String, content:String) {
        let alert = UIAlertController(title: title, message: content, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? QuestionController {
            vc.questionLabel = questionLabel
        }
        activeTextField?.endEditingInFirstResponder()
    }
    
    private func postDataToServer() {
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
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://www.rustelefonen.no/still-sporsmal")!)
        request.HTTPMethod =  "POST"
        request.addValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = parseParams(params).dataUsingEncoding(NSUTF8StringEncoding)
        let loadingDialog = showLoadingDialog()
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {data, response, error in self.onResponse(data, loadingDialog: loadingDialog)}).resume()
    }
    
    private func parseParams(params:[(String, String)]) -> String{
        var paramBody = ""
        for p in params { paramBody += "\(p.0)=\(p.1)&" }
        
        return String(paramBody.characters.dropLast()).stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()) ?? ""
    }
    
    private func showLoadingDialog() -> UIAlertController{
        let alert = UIAlertController(title: "Sender spørsmål...", message: nil, preferredStyle: .Alert)
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.startAnimating()
        
        let cvc = UIViewController()
        cvc.view.addSubview(indicator)
        cvc.view!.addConstraint(NSLayoutConstraint(item: indicator, attribute: .CenterX, relatedBy: .Equal, toItem: cvc.view!, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        cvc.view!.addConstraint(NSLayoutConstraint(item: indicator, attribute: .CenterY, relatedBy: .Equal, toItem: cvc.view!, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        alert.view.addConstraint(NSLayoutConstraint(item: alert.view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 105))
        alert.setValue(cvc, forKey: "contentViewController")
        
        presentViewController(alert, animated: true, completion: nil)
        return alert
    }
    
    private func onResponse(data:NSData?, loadingDialog:UIAlertController){
        loadingDialog.dismissViewControllerAnimated(true, completion: nil)
        if data == nil { return showErrorOccouredDialog() }
        showConfirmationDialog()
    }
    
    private func showConfirmationDialog() {
        let content = "Svaret vil bli publisert på www.rustelefonen.no i løpet av 7 dager."
        let alert = UIAlertController(title: "Spørsmålet er sendt!", message: content, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {action in self.navigationController?.popViewControllerAnimated(true)}))
        presentViewController(alert, animated: true, completion: nil)
    }
            
    private func showErrorOccouredDialog() {
        let content = "En feil oppstod\n\n Sjekk din nettverkstilkobling."
        let alert = UIAlertController(title: "Feil!", message: content, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func navigateToQuestionForm(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.rustelefonen.no/besvarte-sporsmal-og-svar/")!)
    }
}
