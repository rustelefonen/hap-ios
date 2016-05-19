//
//  Graph.swift
//  HAP
//
//  Created by Fredrik Lober on 26/01/16.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit

class UIGraphView: UIViewLineDrawer {
    struct AxisDetails{
        let label:NSString
        let atPercentage:CGFloat
        let drawLine:Bool
        
        init(label:NSString, atPercentage:CGFloat, drawLine:Bool = true){
            self.label = label
            self.atPercentage = atPercentage
            self.drawLine = drawLine
        }
    }
    
    struct GraphConstraints {
        var lowestPoint: CGFloat = 0
        var highestPoint: CGFloat = 0
        var pointDistance: CGFloat = 0
    }
    
    struct Section {
        let label:NSString
        let atPercentage:CGFloat
    }
    
    var xAxisDetails: [AxisDetails]?
    var yAxisDetails: [AxisDetails]?
    var data:[GraphData]!
    var sections:[Section]?
    
    var shouldDrawMiddleLine:Bool?
    
    @IBInspectable var dotDiameter:CGFloat = 4
    @IBInspectable var lineThickness:CGFloat = 2
    @IBInspectable var lineColor:UIColor = UIColor.blackColor()
    @IBInspectable var topBackgroundGradientColor:UIColor = UIColor.yellowColor()
    @IBInspectable var bottomBackgroundGradientColor:UIColor = UIColor.redColor()
    @IBInspectable var userSpotLineColor:UIColor = UIColor.whiteColor()
    @IBInspectable var userSpotDotDiameter: CGFloat = 15
    @IBInspectable var userSpotDotColor:UIColor = UIColor.redColor()
    
    var graphXPadding:CGFloat = 25
    var graphYPadding:CGFloat = 15
    var userSpot: CAShapeLayer?
    var lineAndDotsLayers: [CAShapeLayer?]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        inits()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        inits()
    }
    
    private func inits(){
        data = []
        contentMode = .Redraw
    }
    
    func sectionIndexAtPoint(point:CGPoint) -> Int{
        let minX = graphXPadding
        let maxX = frame.width - graphXPadding
        var lastX = minX
        
        for (i, section) in sections?.enumerate() ?? [].enumerate() {
            let endX = section.atPercentage * abs(minX - maxX) + minX
            if touchIsInSquare(point, startX: lastX, startY: 0, endX: endX, endY: graphYPadding + 20){
                return i
            }
            lastX = endX
        }
        return -1
    }
    
    private func touchIsInSquare(point:CGPoint, startX:CGFloat, startY:CGFloat, endX:CGFloat, endY:CGFloat) -> Bool{
        return point.x >= startX && point.x <= endX
            && point.y >= startY && point.y <= endY
    }

    override func drawRect(rect: CGRect){
        lineAndDotsLayers?.forEach({$0?.removeFromSuperlayer()})
        lineAndDotsLayers = []
        userSpot?.removeFromSuperlayer()
        
        let context = UIGraphicsGetCurrentContext()!
        drawGradientBackground(rect, context: context)
        lineColor.set()
        drawTopSeparatorLine()
        if shouldDrawMiddleLine ?? false { drawMiddleLine() }
        drawBottomSeparatorLine()
        drawXDetails()
        drawYDetails()
        drawSections()
        
        let graphConstraints = calculateConstraints()
        for graphData in data{
            drawDataGraph(context, graphData: graphData, constraints: graphConstraints)
        }
        markSpotOnGraph()
    }
    
    private func drawDataGraph(context: CGContext, graphData: GraphData, constraints: GraphConstraints){
        let graphPath = UIBezierPath()
        let graphDots = UIBezierPath()
        
        //making the graphLine and graphPoints
        var point = CGPoint(x: CGFloat(graphXPadding), y: getYLocForData(graphData.data[0], constraints: constraints))
        graphPath.moveToPoint(point)
        graphDots.moveToPoint(point)
        graphDots.appendPath(drawGraphDot(point))
        for i in 1..<graphData.data.count {
            point.x += constraints.pointDistance
            point.y = getYLocForData(graphData.data[i], constraints: constraints)
            graphPath.addLineToPoint(point)
            graphDots.addLineToPoint(point)
            graphDots.appendPath(drawGraphDot(point))
            graphDots.moveToPoint(point)
        }
        
        //Closing graphPath and filling with gradient
        point.y = CGFloat(frame.height - graphYPadding)
        graphPath.addLineToPoint(point)
        point.x = graphXPadding
        graphPath.addLineToPoint(point)
        point.y = getYLocForData(graphData.data[0], constraints: constraints)
        graphPath.addLineToPoint(point)
        drawGraphGradientFill(context, path: graphPath, graphData: graphData)
        
        //adding line and dots in seperate layer to make them on top of gradient background
        let lineAndDotsLayer = CAShapeLayer()
        lineAndDotsLayer.lineWidth = 2
        lineAndDotsLayer.path = graphDots.CGPath
        lineAndDotsLayer.fillColor = graphData.lineColor.CGColor
        lineAndDotsLayer.strokeColor = graphData.lineColor.CGColor
        layer.insertSublayer(lineAndDotsLayer, atIndex: 1)
        lineAndDotsLayers?.append(lineAndDotsLayer)
    }
    
    private func markSpotOnGraph(){
        let radius = userSpotDotDiameter / 2
        let lineWidth:CGFloat = 2
        let circle = UIBezierPath(ovalInRect: CGRect(x: graphXPadding - radius, y: graphYPadding-userSpotDotDiameter, width: userSpotDotDiameter, height: userSpotDotDiameter))
        
        let line = UIBezierPath()
        line.moveToPoint(CGPoint(x: graphXPadding, y: graphYPadding))
        line.addLineToPoint(CGPoint(x: graphXPadding, y: frame.height - graphYPadding))
        
        userSpot = CAShapeLayer()
        userSpot!.path = line.CGPath
        userSpot!.lineWidth = lineWidth
        userSpot!.strokeColor = userSpotDotColor.CGColor
        
        let circleLayer = CAShapeLayer()
        circleLayer.path = circle.CGPath
        circleLayer.fillColor = userSpotDotColor.CGColor
        userSpot!.insertSublayer(circleLayer, atIndex: 2)
        layer.insertSublayer(userSpot!, atIndex: 4)
    }
    
    private func calculateConstraints() -> GraphConstraints{
        var constrains = GraphConstraints()
        var maxCount = 0
        
        for graphData in data{
            maxCount = max(maxCount, graphData.data.count)
            constrains.lowestPoint = min(constrains.lowestPoint, CGFloat(graphData.data.minElement()!))
            constrains.highestPoint = max(constrains.highestPoint, CGFloat(graphData.data.maxElement()!))
        }
        
        constrains.pointDistance = ceil((frame.width - (graphXPadding * 3)) / CGFloat(maxCount - 1))
        return constrains
    }
    
    private func getYLocForData(data: CGFloat, constraints: GraphConstraints) -> CGFloat{
        let maxDistance = abs(constraints.lowestPoint - constraints.highestPoint)
        let y = (CGFloat(data) - constraints.lowestPoint) / maxDistance
        return (frame.height - graphYPadding) - ((frame.height - (graphYPadding*2)) * y)
    }
    
    private func drawGraphDot(point: CGPoint) -> UIBezierPath{
        let lineDiff = dotDiameter / 2 //To center the ovalRect on point
        return UIBezierPath(ovalInRect: CGRect(x: point.x - lineDiff, y: point.y - lineDiff, width: dotDiameter, height: dotDiameter))
    }
    
    private func drawTopSeparatorLine(){
        let fromPoint = CGPoint(x: graphXPadding-5, y: graphYPadding)
        let toPoint = CGPoint(x: frame.width - graphXPadding+5, y: fromPoint.y)
        drawLine(fromPoint, toPoint: toPoint, lineHeight: 0.5)
    }
    
    private func drawMiddleLine(){
        let fromPoint = CGPoint(x: graphXPadding-5, y: frame.height/2)
        let toPoint = CGPoint(x: frame.width - graphXPadding+5, y: fromPoint.y)
        drawDashedLine(fromPoint, toPoint: toPoint, dashHeight: 0.5, dashWidth: 3, dashSpacing: 2)
    }
    
    private func drawBottomSeparatorLine(){
        let fromPoint = CGPoint(x: graphXPadding-5, y: frame.height - graphYPadding)
        let toPoint = CGPoint(x: frame.width - graphXPadding+5, y: fromPoint.y)
        drawLine(fromPoint, toPoint: toPoint, lineHeight: 0.5)
    }
    
    private func drawXDetails(){
        let fromX = graphXPadding
        let toX = frame.width - graphXPadding
        let fromY = frame.height - graphYPadding
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .Center
        
        let attributes = [
            NSFontAttributeName: UIFont.systemFontOfSize(10),
            NSForegroundColorAttributeName: lineColor,
            NSParagraphStyleAttributeName: titleParagraphStyle
        ]
        
        for xDetail in xAxisDetails ?? []{
            let xLoc = xDetail.atPercentage * abs(fromX - toX) + fromX
            if xDetail.drawLine { drawLine(CGPoint(x: xLoc, y: fromY), toPoint: CGPoint(x: xLoc, y: fromY + 5), lineHeight: 0.5) }
            xDetail.label.drawInRect(CGRectMake(xLoc - 15, fromY + 5, 30, 20), withAttributes: attributes)
        }
    }
    
    private func drawYDetails(){
        let fromY = graphYPadding + 5
        let toY = frame.height - graphYPadding - 5
        let fromX = graphXPadding - 35
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .Right
        
        let attributes = [
            NSFontAttributeName: UIFont.systemFontOfSize(10),
            NSForegroundColorAttributeName: lineColor,
            NSParagraphStyleAttributeName: titleParagraphStyle,
        ]
        
        for yDetail in yAxisDetails ?? []{
            let yLoc = yDetail.atPercentage * abs(fromY - toY) + fromY
            yDetail.label.drawInRect(CGRectMake(fromX, yLoc - 7, 30, 20), withAttributes: attributes)
        }
    }
    
    private func drawSections(){
        if sections == nil { return }
    
        let minX = graphXPadding
        let maxX = frame.width - graphXPadding
        let yLoc = graphYPadding - 13
    
        var lastX = minX
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .Center
        
        let attributes = [
            NSFontAttributeName: UIFont.systemFontOfSize(10),
            NSForegroundColorAttributeName: lineColor,
            NSParagraphStyleAttributeName: titleParagraphStyle,
        ]
        
        for section in sections ?? []{
            let endX = section.atPercentage * abs(minX - maxX) + minX
            let width = abs(lastX - endX)
            section.label.drawInRect(CGRectMake(lastX, yLoc, width, 20), withAttributes: attributes)
            if section.atPercentage < 1 {
                drawLine(CGPointMake(endX, graphYPadding), toPoint: CGPointMake(endX, frame.height - graphYPadding), lineHeight: 0.5)
            }
            lastX = endX
        }
    }
    
    private func drawGraphGradientFill(context: CGContext, path: UIBezierPath, graphData: GraphData){
        let startPoint = CGPoint(x: graphXPadding, y: frame.height-graphYPadding)
        let endPoint = CGPoint(x: graphXPadding, y: graphYPadding)
        let gradientColors = prepareGraphGradientFillColors(graphData)
        let gradientLocations: [CGFloat] = [0.0, 1.0]
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), gradientColors, gradientLocations)
        
        CGContextSaveGState(context)
        path.addClip()
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, CGGradientDrawingOptions(rawValue: 0))
        CGContextRestoreGState(context)
    }
    
    private func drawGradientBackground(rect: CGRect, context: CGContext){
        let gradientColors = [topBackgroundGradientColor.CGColor, bottomBackgroundGradientColor.CGColor]
        let gradientLocations: [CGFloat] = [0.2, 1]
        
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), gradientColors, gradientLocations)
        let startPoint = CGPoint(x: CGRectGetMidX(rect), y: CGRectGetMinY(rect))
        let endPoint = CGPoint(x: CGRectGetMidX(rect), y: CGRectGetMaxY(rect))
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, CGGradientDrawingOptions(rawValue: 0))
    }
    
    private func prepareGraphGradientFillColors(graphData: GraphData) -> [CGColor]{
        var gradientColors = [CGColor]()
        gradientColors.append((graphData.gradientFillBottomColor != nil) ? (graphData.gradientFillBottomColor?.CGColor)! : bottomBackgroundGradientColor.makeUIColorLighter(0.1).CGColor)
        gradientColors.append((graphData.gradientFillTopColor != nil) ? (graphData.gradientFillTopColor?.CGColor)! : topBackgroundGradientColor.makeUIColorLighter(0.8).CGColor)
        return gradientColors
    }
    
    func animateUserSpotTo(percentage:CGFloat){
        let totalDistance = frame.width - (graphXPadding * 2)
        let x = percentage * totalDistance
    
        if !x.isEqualTo(userSpot!.position.x, decimalsToCompare: 2) {
            userSpot!.position.x = x
        }
    }
    
    func bounceUserSpot(){
        let from = userSpot!.position.y
        let to = from - 25
        let rebounce = from - 10
        
        let animation = CAKeyframeAnimation(keyPath: "position.y")
        animation.values = [from, to, from, rebounce, from]
        animation.keyTimes = [0, 0.6, 0.75, 0.85, 1]
        animation.duration = 0.3
        
        userSpot!.addAnimation(animation, forKey: "bounce")
    }
}