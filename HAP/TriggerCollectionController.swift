//
//  RefacThisNameController.swift
//  HAP
//
//  Created by Simen Fonnes on 12.02.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit

class TriggerCollectionController: UIViewController, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var resistedImage: UIImageView!
    @IBOutlet weak var smokedImage: UIImageView!
    @IBOutlet weak var resultsView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var triggersView: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var triggersViewHeight: NSLayoutConstraint!
    
    var checkableTriggers:[CheckableTrigger]!
    
    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let triggers = TriggerDao().getAllTriggers()
        checkableTriggers = triggers.map({CheckableTrigger(trigger: $0, isChecked: false)})
        
        topConstraint.constant = (UIScreen.main.bounds.height / 2) - (resultsView.frame.height * 1.2)
        triggersView.alpha = 0
        triggersViewHeight.constant = view.frame.height - 64
        resistedImage.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(resultImageSelected(_:))))
        smokedImage.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(resultImageSelected(_:))))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(15.0, 0, 15.0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return -10.0
    }
    
    func resultImageSelected(_ sender: UIGestureRecognizer) {
        let selectedImage = sender.view!
        let opositeImage = selectedImage == resistedImage ? smokedImage : resistedImage
        headerLabel.text = selectedImage == resistedImage ? "Hva hjalp deg?" : "Hva trigget deg?"
        
        removeCheckmarkFromView(opositeImage!)
        invertSelectionOf(selectedImage)
        
        if topConstraint.constant > 0 { animateToFinalPosition() }
    }
    
    func animateToFinalPosition(){
        let distance = topConstraint.constant
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.resultsView.frame.origin.y -= distance
            self.triggersView.frame.origin.y -= distance
            self.resultLabel.frame.origin.y -= distance
            self.triggersView.alpha = 1
            },
            completion: { finished in
                self.topConstraint.constant = 0
                self.triggersViewHeight.constant -= self.resultsView.frame.height
                self.view.layoutIfNeeded()
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return checkableTriggers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width / 4)
        return CGSize(width: width, height: width+10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TriggerCell
        invertSelectionOf(cell.imageView)
        checkableTriggers![(indexPath as NSIndexPath).row].isChecked = !checkableTriggers![(indexPath as NSIndexPath).row].isChecked
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TriggerCell
        
        if let image = UIImage(named: checkableTriggers![(indexPath as NSIndexPath).row].trigger.imageName) {
            cell.imageView.image = image
            
            if checkableTriggers![(indexPath as NSIndexPath).row].isChecked { addCheckmarkToView(cell.imageView) }
            else { removeCheckmarkFromView(cell.imageView) }
        }
        cell.detailLabel.text = checkableTriggers![(indexPath as NSIndexPath).row].trigger.title
        return cell
    }
    
    func invertSelectionOf(_ view:UIView) {
        if hasCheckmark(view) { removeCheckmarkFromView(view) }
        else { addCheckmarkToView(view) }
    }
    
    fileprivate func hasCheckmark(_ view:UIView) -> Bool{
        return view.subviews.count > 0
    }
    
    fileprivate func addCheckmarkToView(_ view:UIView) {
        let checkmarkImageView = UIImageView(image: UIImage(named: "checkmark"))
        let checkmarkSize:CGFloat = 23.0
        let checkmarkMargin:CGFloat = 3.0
        
        checkmarkImageView.frame = CGRect(x: view.frame.width - checkmarkSize - checkmarkMargin, y: view.frame.height - checkmarkSize - checkmarkMargin, width: checkmarkSize, height: checkmarkSize)
        view.addSubview(checkmarkImageView)
    }
    
    fileprivate func removeCheckmarkFromView(_ view:UIView) {
        view.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    fileprivate func displayMissingDataAlert(){
        let alert = UIAlertController(title: "Legg til triggere", message: "Du har ikke valgt noen triggere å legge til", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveTriggerDiary(_ sender: AnyObject) {
        if noTriggersSelected() { return displayMissingDataAlert() }
        
        if hasCheckmark(smokedImage) { addCheckedTriggersToUserInfo(.Smoked) }
        else if hasCheckmark(resistedImage) { addCheckedTriggersToUserInfo(.Resisted) }
        else { return displayMissingDataAlert() }
        
        SwiftEventBus.post(MainTabBarController.GO_TO_PAGE_EVENT, sender: MainTabBarController.OVERVIEW_TAB_INDEX as AnyObject)
        SwiftEventBus.post(ProgramController.SCROLL_TO_BOTTOM)
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func addCheckedTriggersToUserInfo(_ type:UserTrigger.Kind) {
        let userInfoDao = UserInfoDao()
        for checkableTrigger in checkableTriggers! {
            if !checkableTrigger.isChecked { continue }
            
            userInfoDao.addTriggerToUser(AppDelegate.getUserInfo()!, trigger: checkableTrigger.trigger, kind: type)
        }
        userInfoDao.save()
        AppDelegate.initUserInfo()
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        if noTriggersSelected() { navigationController?.popViewController(animated: true) }
        else { showUnSavedChangesNotSavedAlert() }
    }
    
    fileprivate func noTriggersSelected() -> Bool{
        return checkableTriggers.filter({ $0.isChecked }).isEmpty
    }
    
    fileprivate func showUnSavedChangesNotSavedAlert() {
        let alert = UIAlertController(title: "Ikke lagret!", message: "Du har ikke lagret endringene", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Forkast", style: .destructive, handler: { result in self.navigationController?.popViewController(animated: true) }))
        alert.addAction(UIAlertAction(title: "Avbryt", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    struct CheckableTrigger {
        var trigger:Trigger
        var isChecked:Bool
    }
}
