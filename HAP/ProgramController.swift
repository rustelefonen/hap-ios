//
//  ProgramController.swift
//  HAP
//
//  Created by Fredrik Lober on 26/01/16.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit
import Charts

class ProgramController: UIViewController, ChartViewDelegate {
    static let SCROLL_TO_BOTTOM = "scroll_to_bottom"
    let eventBusTarget = 1
    
    @IBOutlet weak var pieChartPos: PieChartView!
    @IBOutlet weak var pieChartNeg: PieChartView!
    @IBOutlet weak var graph: UIGraphView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var resistedCardHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var noDataResisted: UIView!
    @IBOutlet weak var noDataSmoked: UIView!
    @IBOutlet weak var smokedCardHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var yourPositionLegend: UIView!
    
    var sections: [UIGraphView.Section]!
    
    var userInfo: UserInfo!
    var timer: NSTimer!
    
    var overlay:UIOverlay!
    var smokedOverlayGesture:UIGestureRecognizer!
    var resistedOverlayGesture:UIGestureRecognizer!
    
    let cardExpandedHeight:CGFloat = 250
    let cardCollapsedHeight:CGFloat = 89
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userInfo = AppDelegate.getUserInfo()
        SwiftEventBus.onMainThread(eventBusTarget, name: ProgramController.SCROLL_TO_BOTTOM, handler: {[weak self] _ in
            self?.performSelector(#selector(self?.scrollToBottom), withObject: self, afterDelay: 0.6)
        })
        
        let thc = GraphData(data: [100, 97, 90, 75, 50, 45, 40, 25, 20, 15, 10, 0])
        let feelings = GraphData(data: [15, 25, 30, 50, 80, 75, 73, 50, 25, 15, 13, 7, 0])
        
        feelings.lineColor = UIColor(rgba: 0x92D6EDFF)
        feelings.gradientFillBottomColor = UIColor(rgba: 0x82C6DD1A)
        feelings.gradientFillTopColor = UIColor(rgba: 0x82C6DDCC)
        thc.lineColor = UIColor(rgba: 0xA0D988FF)
        thc.gradientFillBottomColor = UIColor(rgba: 0x90c9781A)
        thc.gradientFillTopColor = UIColor(rgba: 0x90c978CC)
        
        graph.data = [thc, feelings]
        let xAxisDetails = [
            UIGraphView.AxisDetails(label: "Uke:", atPercentage: 0, drawLine: false),
            UIGraphView.AxisDetails(label: "1", atPercentage: 0.1666),
            UIGraphView.AxisDetails(label: "2", atPercentage: 0.3333),
            UIGraphView.AxisDetails(label: "3", atPercentage: 0.5),
            UIGraphView.AxisDetails(label: "4", atPercentage: 0.6666),
            UIGraphView.AxisDetails(label: "5", atPercentage: 0.8333),
            UIGraphView.AxisDetails(label: "6", atPercentage: 1)
        ]
        
        let yAxisDetails = [
            UIGraphView.AxisDetails(label: "Høy", atPercentage: 0),
            UIGraphView.AxisDetails(label: "Lav", atPercentage: 1)
        ]
        
        sections = [
            UIGraphView.Section(label: "Fase 1", atPercentage: 0.262),
            UIGraphView.Section(label: "Fase 2", atPercentage: 0.5),
            UIGraphView.Section(label: "Fase 3", atPercentage: 1)
        ]
        
        graph.xAxisDetails = xAxisDetails
        graph.yAxisDetails = yAxisDetails
        graph.sections = sections
        
        initPieChart(pieChartPos)
        initPieChart(pieChartNeg)
        
        yourPositionLegend.addGestureRecognizer(UITapGestureRecognizer(target: graph, action: #selector(UIGraphView.bounceUserSpot)))
        graph.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(graphClickListener)))
    }
    
    deinit {
        SwiftEventBus.unregister(eventBusTarget)
    }
    
    func scrollToBottom(){
        scrollView.scrollRectToVisible(CGRectMake(0, scrollView.contentSize.height - 1, 1, 1), animated: true)
    }
    
    func graphClickListener(sender: UIGestureRecognizer){
        graph.bounceUserSpot()
        let sectionIndex = graph.sectionIndexAtPoint(sender.locationInView(graph))
        if sectionIndex < 0 { return }
        
        if let helpInfo = HelpInfoDao().fetchHelpInfoByName(String(sections[sectionIndex].label) + "*"){
            if let vs = storyboard?.instantiateViewControllerWithIdentifier(HelpInfoDetailController.storyboardId) as? HelpInfoDetailController {
                vs.helpInfo = helpInfo
                navigationController?.pushViewController(vs, animated: true)
            }
        }
    }
    
    func updateUserSpot(){
        let programDuration:CGFloat = 86400 * 42; // 42 days
        graph.animateUserSpotTo(CGFloat(userInfo.timeInSecondsSinceStarted()) / programDuration);
    }
    
    func spawnOverlay() {
        overlay = UIOverlay.spawnDefault()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        overlay?.despawn()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        userInfo = AppDelegate.getUserInfo()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
        overlay?.despawn()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateUserSpot()
        graph.bounceUserSpot()
        timer = NSTimer.scheduledTimerWithTimeInterval(15.0, target: self, selector: #selector(updateUserSpot), userInfo: nil, repeats: true)
        
        initPieChartCard(pieChartPos, noDataView: noDataResisted, cardHeightConstraint: resistedCardHeightConstraint, data: userInfo.getResistedTriggersAsArray())
        initPieChartCard(pieChartNeg, noDataView: noDataSmoked, cardHeightConstraint: smokedCardHeightConstraint, data: userInfo.getSmokedTriggersAsArray())
    }
    
    func initPieChartCard(pieChart:PieChartView, noDataView:UIView, cardHeightConstraint:NSLayoutConstraint, data:[UserTrigger]){
        noDataView.superview?.gestureRecognizers = nil
        let hasData = data.count > 0
        
        noDataView.hidden = hasData
        pieChart.hidden = !hasData
        cardHeightConstraint.constant = hasData ? cardExpandedHeight : cardCollapsedHeight
        
        if hasData { initPieChartData(pieChart, userTriggers: data) }
        else { noDataView.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(spawnOverlay))) }
        view.layoutIfNeeded()
    }
    
    
    func initPieChartData(pieChart:PieChartView, userTriggers:[UserTrigger]){
        var dataEntries = [ChartDataEntry]()
        var labels = [String]()
        var colors = [UIColor]()
        
        var highestEntryIndex = 0;
        var totalTriggerCount = 0.0
        userTriggers.forEach({totalTriggerCount += Double($0.count)})
        
        for (i, userTrigger) in userTriggers.enumerate() {
            let trigger = userTrigger.getTrigger()
            let percentage = Double(userTrigger.count) / totalTriggerCount * 100.0
            
            dataEntries.append(ChartDataEntry(value: percentage, xIndex: i))
            labels.append(trigger?.title ?? "no title")
            colors.append(UIColor(rgba: trigger?.color.longLongValue ?? 0))
            
            if percentage > dataEntries[highestEntryIndex].value { highestEntryIndex = i }
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        pieChartDataSet.sliceSpace = 1
        pieChartDataSet.selectionShift = 10
        pieChartDataSet.colors = colors
        
        let pieChartData = PieChartData(xVals: labels, dataSet: pieChartDataSet)
        pieChartData.setValueTextColor(UIColor.clearColor())
        pieChart.data = pieChartData
        
        pieChart.animate(yAxisDuration: 1.4, easingOption: .EaseInOutQuad)
        pieChart.highlightValue(highlight: ChartHighlight(xIndex: highestEntryIndex, dataSetIndex: 0), callDelegate: true)
    }
    
    func initPieChart(pieChart:PieChartView) {
        pieChart.descriptionText = ""
        pieChart.rotationEnabled = false
        pieChart.delegate = self
        
        
        let legend = pieChart.legend
        legend.enabled = false
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight){
        if let pieChart = chartView as? PieChartView {
            let percentage = Int(round(entry.value))
            pieChart.centerText = "\(pieChart.data!.xVals[highlight.xIndex]!) \n \(percentage)%"
        }
    }
    
    func chartValueNothingSelected(chartView: ChartViewBase) {
        if let pieChart = chartView as? PieChartView {
           pieChart.centerText = "Velg sektor"
        }
    }
    
    @IBAction func alternativeButton(sender: UIBarButtonItem) {
        (tabBarController as? MainTabBarController)?.displayOptionsMenu(sender)
    }
    
    @IBAction func graphInfo(sender: UIButton) {
        let content = "Grafen viser forholdet mellom THC-nivået i kroppen din og hva du kan forvente av emosjonell turbulens.\n\n Den røde nålen viser hvor du befinner deg i programmet."
        let alert = UIAlertController(title: "Abstinensoversikt", message: content, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func resistedInfo(sender: UIButton) {
        let content = "Dersom du motstår å ruse deg kan du registrere det i triggerdagboken.\n\n Over tid vil dette vinduet gi deg en god oversikt over hva som hjelper best, når suget melder seg."
        let alert = UIAlertController(title: "Positive triggere", message: content, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func smokedInfo(sender: UIButton) {
        let content = "Dersom du ruser deg kan du registrere det i triggerdagboken.\n\n Over tid vil dette vinduet gi deg en god oversikt over hvilke situasjoner du bør passe deg for."
        let alert = UIAlertController(title: "Negative triggere", message: content, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
}
