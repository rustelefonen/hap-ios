//
//  UIViewLineDrawer.swift
//  HAP
//
//  Created by Fredrik Lober on 28/01/16.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit

class UIViewLineDrawer: UIView {
    
    fileprivate func getLinePath(_ fromPoint: CGPoint, toPoint: CGPoint, lineHeight: CGFloat) -> UIBezierPath{
        let path = UIBezierPath()
        path.move(to: fromPoint)
        path.addLine(to: toPoint)
        path.lineWidth = lineHeight
        return path
    }
    
    func drawDashedLine(_ fromPoint: CGPoint, toPoint: CGPoint, dashHeight: CGFloat, dashWidth: CGFloat, dashSpacing: CGFloat){
        let path = getLinePath(fromPoint, toPoint: toPoint, lineHeight: dashHeight)
        
        let dashes: [CGFloat] = [dashWidth, dashSpacing]
        path.setLineDash(dashes, count: dashes.count, phase: 0)
        path.stroke()
    }
    
    func drawLine(_ fromPoint: CGPoint, toPoint: CGPoint, lineHeight: CGFloat){
        getLinePath(fromPoint, toPoint: toPoint, lineHeight: lineHeight).stroke()
    }
    
    func makeCircle(_ frame: CGRect, strokeColor:UIColor = UIColor(rgba: 0xE6E6E6FF), strokeEnd:CGFloat = 1) -> CAShapeLayer{
        let rectShape = CAShapeLayer()
        
        CATransaction.begin()
        CATransaction.disableActions()
        rectShape.bounds = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        rectShape.position = CGPoint(x: frame.origin.x, y: frame.origin.y)
        rectShape.cornerRadius = frame.width / 2
        
        rectShape.path = UIBezierPath(ovalIn: rectShape.bounds).cgPath
        rectShape.lineWidth = 3.0
        rectShape.strokeColor = strokeColor.cgColor
        rectShape.fillColor = UIColor.clear.cgColor
        rectShape.transform = CATransform3DMakeRotation(4.7, 0.0, 0.0, 1.0);
        rectShape.strokeStart = 0
        rectShape.strokeEnd = strokeEnd
        CATransaction.commit()
        
        return rectShape
    }
}
