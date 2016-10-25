//
//  ClockView.swift
//  HAP
//
//  Created by Simen Fonnes on 27.01.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit

class UIClockView: UIViewLineDrawer {

    @IBOutlet weak var daysLabel: UILabel?
    @IBOutlet weak var hoursLabel: UILabel?
    @IBOutlet weak var minutesLabel: UILabel?
    
    @IBOutlet weak var daysNumberLabel: UILabel?
    @IBOutlet weak var hoursNumberLabel: UILabel?
    @IBOutlet weak var minutesNumberLabel: UILabel?
    
    @IBInspectable var progressBarColor:UIColor = UIColor.red
    
    @IBInspectable var daySingularText:String?
    @IBInspectable var hourSingularText:String?
    @IBInspectable var minuteSingularText:String?
    
    @IBInspectable var daysPluralText:String?
    @IBInspectable var hoursPluralText:String?
    @IBInspectable var minutesPluralText:String?
    
    var leftGreyCircle:CAShapeLayer?
    var middleGreyCircle:CAShapeLayer?
    var rightGreyCircle:CAShapeLayer?
    
    var leftProgressCircle:CAShapeLayer?
    var middleProgressCircle:CAShapeLayer?
    var rightProgressCircle:CAShapeLayer?
    
    var circleDiameter:CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .redraw
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentMode = .redraw
    }
    
    override func draw(_ rect: CGRect){
        removePreviousCircles()
        drawCircles()
        positionLabels()
    }
    
    fileprivate func drawCircles(){
        circleDiameter = frame.height
        while circleDiameter * 3 + 25 > frame.width { circleDiameter -= 1} // to better fit iphone 4 and 5
        
        let circleY = frame.height / 2
        let leftCircleX = frame.width / 3 / 2
        let rightCircleX = frame.width - leftCircleX
        
        let leftCircleRect = CGRect(x: leftCircleX, y: circleY, width: circleDiameter, height: circleDiameter)
        let middleCircleRect = CGRect(x: frame.width / 2, y: circleY, width: circleDiameter, height: circleDiameter)
        let rightCircleRect = CGRect(x: rightCircleX, y: circleY, width: circleDiameter, height: circleDiameter)
        
        leftGreyCircle = makeCircle(leftCircleRect)
        middleGreyCircle = makeCircle(middleCircleRect)
        rightGreyCircle = makeCircle(rightCircleRect)
            
        layer.insertSublayer(leftGreyCircle!, at: 1)
        layer.insertSublayer(middleGreyCircle!, at: 1)
        layer.insertSublayer(rightGreyCircle!, at: 1)
        
        leftProgressCircle = makeCircle(leftCircleRect, strokeColor: progressBarColor, strokeEnd: 0)
        middleProgressCircle = makeCircle(middleCircleRect, strokeColor: progressBarColor, strokeEnd: 0)
        rightProgressCircle = makeCircle(rightCircleRect, strokeColor: progressBarColor, strokeEnd: 0)
        
        layer.insertSublayer(leftProgressCircle!, above: leftGreyCircle)
        layer.insertSublayer(middleProgressCircle!, above: middleGreyCircle)
        layer.insertSublayer(rightProgressCircle!, above: rightGreyCircle)
    }
    
    fileprivate func removePreviousCircles(){
        leftGreyCircle?.removeFromSuperlayer()
        middleGreyCircle?.removeFromSuperlayer()
        rightGreyCircle?.removeFromSuperlayer()
        leftProgressCircle?.removeFromSuperlayer()
        middleProgressCircle?.removeFromSuperlayer()
        rightProgressCircle?.removeFromSuperlayer()
    }
    
    fileprivate func positionLabels() {
        let offset:CGFloat = 7.5
        
        let labelWidth = (circleDiameter + 1) - offset*2
        let leftLabelX:CGFloat = leftGreyCircle!.frame.origin.x + offset
        let middleLabelX = middleGreyCircle!.frame.origin.x + offset
        let rightLabelX = rightGreyCircle!.frame.origin.x + offset
        
        let descriptorLabelYPos = frame.height - 45
        let numberLabelsYPos = frame.height / 3.4
        
        let labels = ["days", "hours", "minutes"]
        
        prepare(&daysLabel, text: labels[0], xPos: leftLabelX, yPos: descriptorLabelYPos, width: labelWidth, height: 25)
        prepare(&hoursLabel, text: labels[1], xPos: middleLabelX, yPos: descriptorLabelYPos, width: labelWidth, height: 25)
        prepare(&minutesLabel, text: labels[2], xPos: rightLabelX, yPos: descriptorLabelYPos, width: labelWidth, height: 25)
        
        prepare(&daysNumberLabel, text: nil, xPos: leftLabelX, yPos: numberLabelsYPos-7, width: labelWidth, height: 35)
        prepare(&hoursNumberLabel,text: nil, xPos: middleLabelX, yPos: numberLabelsYPos-7, width: labelWidth, height: 35)
        prepare(&minutesNumberLabel, text: nil, xPos: rightLabelX, yPos: numberLabelsYPos-7, width: labelWidth, height: 35)
    }
    
    fileprivate func prepare(_ label: inout UILabel?, text: String?, xPos: CGFloat, yPos: CGFloat, width: CGFloat, height: CGFloat){
        if label == nil {
            label = UILabel()
            label!.text = text
            addSubview(label!)
        }
        
        label!.textAlignment = .center
        label!.frame = CGRect(x: xPos, y: yPos, width: width, height: height)
    }
    
    func updateClock(_ counter:Double) {
        let days = Int(counter / 86400)
        let hours = Int((counter / 3600).truncatingRemainder(dividingBy: 24))
        let minutes = Int((counter / 60).truncatingRemainder(dividingBy: 60))
        
        daysNumberLabel?.updateText("\(days)")
        hoursNumberLabel?.updateText("\(hours)")
        minutesNumberLabel?.updateText("\(minutes)")
        
        updateClockLabels(days, hours: hours, minutes: minutes)
        updateClockCircularProgressBar(counter)
    }
    
    fileprivate func updateClockLabels(_ days:Int, hours:Int, minutes:Int){
        if days == 1 { daysLabel?.updateText(daySingularText) }
        else { daysLabel?.updateText(daysPluralText) }
        
        if hours == 1 { hoursLabel?.updateText(hourSingularText) }
        else { hoursLabel?.updateText(hoursPluralText) }
        
        if minutes == 1 { minutesLabel?.updateText(minuteSingularText) }
        else { minutesLabel?.updateText(minutesPluralText) }
    }
    
    fileprivate func updateClockCircularProgressBar(_ counter:Double){
        let dayPercentage = CGFloat(((counter / 3600).truncatingRemainder(dividingBy: 24)) / 24)
        let hourPercentage = CGFloat(((counter / 60).truncatingRemainder(dividingBy: 60)) / 60)
        let minutePercentage = CGFloat((counter.truncatingRemainder(dividingBy: 60.0)) / 60.0)
        
        if !leftProgressCircle!.strokeEnd.isEqualTo(dayPercentage, decimalsToCompare: 3) {
            leftProgressCircle!.strokeEnd = dayPercentage
        }
        if !middleProgressCircle!.strokeEnd.isEqualTo(hourPercentage, decimalsToCompare: 3) {
            middleProgressCircle!.strokeEnd = hourPercentage
        }
        if !rightProgressCircle!.strokeEnd.isEqualTo(minutePercentage, decimalsToCompare: 3) {
            rightProgressCircle!.strokeEnd = minutePercentage
        }
    }
}
