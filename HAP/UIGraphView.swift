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
    @IBInspectable var lineColor:UIColor = UIColor.black
    @IBInspectable var topBackgroundGradientColor:UIColor = UIColor.yellow
    @IBInspectable var bottomBackgroundGradientColor:UIColor = UIColor.red
    @IBInspectable var userSpotLineColor:UIColor = UIColor.white
    @IBInspectable var userSpotDotDiameter: CGFloat = 15
    @IBInspectable var userSpotDotColor:UIColor = UIColor.red
    
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
    
    fileprivate func inits(){
        data = []
        contentMode = .redraw
    }
    
    func sectionIndexAtPoint(_ point:CGPoint) -> Int{
        let minX = graphXPadding
        let maxX = frame.width - graphXPadding
        var lastX = minX
        
        for (i, section) in sections?.enumerated() ?? [].enumerated() {
            let endX = section.atPercentage * abs(minX - maxX) + minX
            if touchIsInSquare(point, startX: lastX, startY: 0, endX: endX, endY: graphYPadding + 20){
                return i
            }
            lastX = endX
        }
        return -1
    }
    
    fileprivate func touchIsInSquare(_ point:CGPoint, startX:CGFloat, startY:CGFloat, endX:CGFloat, endY:CGFloat) -> Bool{
        return point.x >= startX && point.x <= endX
            && point.y >= startY && point.y <= endY
    }

    override func draw(_ rect: CGRect){
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
    
    fileprivate func drawDataGraph(_ context: CGContext, graphData: GraphData, constraints: GraphConstraints){
        let graphPath = UIBezierPath()
        let graphDots = UIBezierPath()
        
        //making the graphLine and graphPoints
        var point = CGPoint(x: CGFloat(graphXPadding), y: getYLocForData(graphData.data[0], constraints: constraints))
        graphPath.move(to: point)
        graphDots.move(to: point)
        graphDots.append(drawGraphDot(point))
        for i in 1..<graphData.data.count {
            point.x += constraints.pointDistance
            point.y = getYLocForData(graphData.data[i], constraints: constraints)
            graphPath.addLine(to: point)
            graphDots.addLine(to: point)
            graphDots.append(drawGraphDot(point))
            graphDots.move(to: point)
        }
        
        //Closing graphPath and filling with gradient
        point.y = CGFloat(frame.height - graphYPadding)
        graphPath.addLine(to: point)
        point.x = graphXPadding
        graphPath.addLine(to: point)
        point.y = getYLocForData(graphData.data[0], constraints: constraints)
        graphPath.addLine(to: point)
        drawGraphGradientFill(context, path: graphPath, graphData: graphData)
        
        //adding line and dots in seperate layer to make them on top of gradient background
        let lineAndDotsLayer = CAShapeLayer()
        lineAndDotsLayer.lineWidth = 2
        lineAndDotsLayer.path = graphDots.cgPath
        lineAndDotsLayer.fillColor = graphData.lineColor.cgColor
        lineAndDotsLayer.strokeColor = graphData.lineColor.cgColor
        layer.insertSublayer(lineAndDotsLayer, at: 1)
        lineAndDotsLayers?.append(lineAndDotsLayer)
    }
    
    fileprivate func markSpotOnGraph(){
        let radius = userSpotDotDiameter / 2
        let lineWidth:CGFloat = 2
        let circle = UIBezierPath(ovalIn: CGRect(x: graphXPadding - radius, y: graphYPadding-userSpotDotDiameter, width: userSpotDotDiameter, height: userSpotDotDiameter))
        
        let line = UIBezierPath()
        line.move(to: CGPoint(x: graphXPadding, y: graphYPadding))
        line.addLine(to: CGPoint(x: graphXPadding, y: frame.height - graphYPadding))
        
        userSpot = CAShapeLayer()
        userSpot!.path = line.cgPath
        userSpot!.lineWidth = lineWidth
        userSpot!.strokeColor = userSpotDotColor.cgColor
        
        let circleLayer = CAShapeLayer()
        circleLayer.path = circle.cgPath
        circleLayer.fillColor = userSpotDotColor.cgColor
        userSpot!.insertSublayer(circleLayer, at: 2)
        layer.insertSublayer(userSpot!, at: 4)
    }
    
    fileprivate func calculateConstraints() -> GraphConstraints{
        var constrains = GraphConstraints()
        var maxCount = 0
        
        for graphData in data{
            maxCount = max(maxCount, graphData.data.count)
            constrains.lowestPoint = min(constrains.lowestPoint, CGFloat(graphData.data.min()!))
            constrains.highestPoint = max(constrains.highestPoint, CGFloat(graphData.data.max()!))
        }
        
        constrains.pointDistance = ceil((frame.width - (graphXPadding * 3)) / CGFloat(maxCount - 1))
        return constrains
    }
    
    fileprivate func getYLocForData(_ data: CGFloat, constraints: GraphConstraints) -> CGFloat{
        let maxDistance = abs(constraints.lowestPoint - constraints.highestPoint)
        let y = (CGFloat(data) - constraints.lowestPoint) / maxDistance
        return (frame.height - graphYPadding) - ((frame.height - (graphYPadding*2)) * y)
    }
    
    fileprivate func drawGraphDot(_ point: CGPoint) -> UIBezierPath{
        let lineDiff = dotDiameter / 2 //To center the ovalRect on point
        return UIBezierPath(ovalIn: CGRect(x: point.x - lineDiff, y: point.y - lineDiff, width: dotDiameter, height: dotDiameter))
    }
    
    fileprivate func drawTopSeparatorLine(){
        let fromPoint = CGPoint(x: graphXPadding-5, y: graphYPadding)
        let toPoint = CGPoint(x: frame.width - graphXPadding+5, y: fromPoint.y)
        drawLine(fromPoint, toPoint: toPoint, lineHeight: 0.5)
    }
    
    fileprivate func drawMiddleLine(){
        let fromPoint = CGPoint(x: graphXPadding-5, y: frame.height/2)
        let toPoint = CGPoint(x: frame.width - graphXPadding+5, y: fromPoint.y)
        drawDashedLine(fromPoint, toPoint: toPoint, dashHeight: 0.5, dashWidth: 3, dashSpacing: 2)
    }
    
    fileprivate func drawBottomSeparatorLine(){
        let fromPoint = CGPoint(x: graphXPadding-5, y: frame.height - graphYPadding)
        let toPoint = CGPoint(x: frame.width - graphXPadding+5, y: fromPoint.y)
        drawLine(fromPoint, toPoint: toPoint, lineHeight: 0.5)
    }
    
    fileprivate func drawXDetails(){
        let fromX = graphXPadding
        let toX = frame.width - graphXPadding
        let fromY = frame.height - graphYPadding
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .center
        
        let attributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 10),
            NSForegroundColorAttributeName: lineColor,
            NSParagraphStyleAttributeName: titleParagraphStyle
        ] as [String : Any]
        
        for xDetail in xAxisDetails ?? []{
            let xLoc = xDetail.atPercentage * abs(fromX - toX) + fromX
            if xDetail.drawLine { drawLine(CGPoint(x: xLoc, y: fromY), toPoint: CGPoint(x: xLoc, y: fromY + 5), lineHeight: 0.5) }
            xDetail.label.draw(in: CGRect(x: xLoc - 15, y: fromY + 5, width: 30, height: 20), withAttributes: attributes)
        }
    }
    
    fileprivate func drawYDetails(){
        let fromY = graphYPadding + 5
        let toY = frame.height - graphYPadding - 5
        let fromX = graphXPadding - 35
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .right
        
        let attributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 10),
            NSForegroundColorAttributeName: lineColor,
            NSParagraphStyleAttributeName: titleParagraphStyle,
        ] as [String : Any]
        
        for yDetail in yAxisDetails ?? []{
            let yLoc = yDetail.atPercentage * abs(fromY - toY) + fromY
            yDetail.label.draw(in: CGRect(x: fromX, y: yLoc - 7, width: 30, height: 20), withAttributes: attributes)
        }
    }
    
    fileprivate func drawSections(){
        if sections == nil { return }
    
        let minX = graphXPadding
        let maxX = frame.width - graphXPadding
        let yLoc = graphYPadding - 13
    
        var lastX = minX
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .center
        
        let attributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 10),
            NSForegroundColorAttributeName: lineColor,
            NSParagraphStyleAttributeName: titleParagraphStyle,
        ] as [String : Any]
        
        for section in sections ?? []{
            let endX = section.atPercentage * abs(minX - maxX) + minX
            let width = abs(lastX - endX)
            section.label.draw(in: CGRect(x: lastX, y: yLoc, width: width, height: 20), withAttributes: attributes)
            if section.atPercentage < 1 {
                drawLine(CGPoint(x: endX, y: graphYPadding), toPoint: CGPoint(x: endX, y: frame.height - graphYPadding), lineHeight: 0.5)
            }
            lastX = endX
        }
    }
    
    fileprivate func drawGraphGradientFill(_ context: CGContext, path: UIBezierPath, graphData: GraphData){
        let startPoint = CGPoint(x: graphXPadding, y: frame.height-graphYPadding)
        let endPoint = CGPoint(x: graphXPadding, y: graphYPadding)
        let gradientColors = prepareGraphGradientFillColors(graphData)
        let gradientLocations: [CGFloat] = [0.0, 1.0]
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors as CFArray, locations: gradientLocations)
        
        context.saveGState()
        path.addClip()
        context.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
        context.restoreGState()
    }
    
    fileprivate func drawGradientBackground(_ rect: CGRect, context: CGContext){
        let gradientColors = [topBackgroundGradientColor.cgColor, bottomBackgroundGradientColor.cgColor]
        let gradientLocations: [CGFloat] = [0.2, 1]
        
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors as CFArray, locations: gradientLocations)
        let startPoint = CGPoint(x: rect.midX, y: rect.minY)
        let endPoint = CGPoint(x: rect.midX, y: rect.maxY)
        context.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
    }
    
    fileprivate func prepareGraphGradientFillColors(_ graphData: GraphData) -> [CGColor]{
        var gradientColors = [CGColor]()
        gradientColors.append((graphData.gradientFillBottomColor != nil) ? (graphData.gradientFillBottomColor?.cgColor)! : bottomBackgroundGradientColor.makeUIColorLighter(0.1).cgColor)
        gradientColors.append((graphData.gradientFillTopColor != nil) ? (graphData.gradientFillTopColor?.cgColor)! : topBackgroundGradientColor.makeUIColorLighter(0.8).cgColor)
        return gradientColors
    }
    
    func animateUserSpotTo(_ percentage:CGFloat){
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
        
        userSpot!.add(animation, forKey: "bounce")
    }
}
