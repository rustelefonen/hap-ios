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
    var timer: Timer!
    
    var overlay:UIOverlay!
    var smokedOverlayGesture:UIGestureRecognizer!
    var resistedOverlayGesture:UIGestureRecognizer!
    
    let cardExpandedHeight:CGFloat = 250
    let cardCollapsedHeight:CGFloat = 89
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userInfo = AppDelegate.getUserInfo()
        SwiftEventBus.onMainThread(eventBusTarget as AnyObject, name: ProgramController.SCROLL_TO_BOTTOM, handler: {[weak self] _ in
            self?.perform(#selector(self?.scrollToBottom), with: self, afterDelay: 0.6)
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
        
        initPieChart(pieChart: pieChartPos)
        initPieChart(pieChart: pieChartNeg)
        
        yourPositionLegend.addGestureRecognizer(UITapGestureRecognizer(target: graph, action: #selector(UIGraphView.bounceUserSpot)))
        graph.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(graphClickListener)))
    }
    
    deinit {
        SwiftEventBus.unregister(eventBusTarget as AnyObject)
    }
    
    func scrollToBottom(){
        scrollView.scrollRectToVisible(CGRect(x: 0, y: scrollView.contentSize.height - 1, width: 1, height: 1), animated: true)
    }
    
    func graphClickListener(_ sender: UIGestureRecognizer){
        graph.bounceUserSpot()
        let sectionIndex = graph.sectionIndexAtPoint(sender.location(in: graph))
        if sectionIndex < 0 { return }
        
        if let helpInfo = HelpInfoDao().fetchHelpInfoByName(String(sections[sectionIndex].label) + "*"){
            if let vs = storyboard?.instantiateViewController(withIdentifier: HelpInfoDetailController.storyboardId) as? HelpInfoDetailController {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        overlay?.despawn()
        if (segue.identifier == "HelpInfoGraphDetails"){
            if let dest = segue.destination as? HelpInfoDetailController{
                let helpInfoDao = HelpInfoDao()
                let graphDetails = helpInfoDao.fetchHelpInfoByName("THC-metabolitter")
                dest.helpInfo = graphDetails
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userInfo = AppDelegate.getUserInfo()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
        overlay?.despawn()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUserSpot()
        graph.bounceUserSpot()
        timer = Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(updateUserSpot), userInfo: nil, repeats: true)
        
        initPieChartCard(pieChart: pieChartPos, noDataView: noDataResisted, cardHeightConstraint: resistedCardHeightConstraint, data: userInfo.getResistedTriggersAsArray())
        initPieChartCard(pieChart: pieChartNeg, noDataView: noDataSmoked, cardHeightConstraint: smokedCardHeightConstraint, data: userInfo.getSmokedTriggersAsArray())
    }
    
    func initPieChartCard(pieChart:PieChartView, noDataView:UIView, cardHeightConstraint:NSLayoutConstraint, data:[UserTrigger]){
        noDataView.superview?.gestureRecognizers = nil
        let hasData = data.count > 0
        
        noDataView.isHidden = hasData
        pieChart.isHidden = !hasData
        cardHeightConstraint.constant = hasData ? cardExpandedHeight : cardCollapsedHeight
        
        if hasData { initPieChartData(pieChart: pieChart, userTriggers: data) }
        else { noDataView.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(spawnOverlay))) }
        view.layoutIfNeeded()
    }
    
    
    func initPieChartData(pieChart:PieChartView, userTriggers:[UserTrigger]){
        var dataEntries = [ChartDataEntry]()
        var colors = [UIColor]()
        
        var highestEntryIndex = 0;
        var totalTriggerCount = 0.0
        userTriggers.forEach({totalTriggerCount += Double($0.count)})
        
        for (i, userTrigger) in userTriggers.enumerated() {
            let trigger = userTrigger.getTrigger()
            let percentage = Double(userTrigger.count) / totalTriggerCount * 100.0
            
            dataEntries.append(ChartDataEntry(x: Double(i), y: percentage, data: trigger?.title as AnyObject?? ?? "no title" as AnyObject?))
            colors.append(UIColor(rgba: trigger?.color.int64Value ?? 0))
            
            if percentage > dataEntries[highestEntryIndex].y { highestEntryIndex = i }
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "")
        pieChartDataSet.sliceSpace = 1
        pieChartDataSet.selectionShift = 10
        pieChartDataSet.colors = colors
        
        
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartData.setValueTextColor(UIColor.clear)
        pieChart.data = pieChartData
        
        pieChart.animate(yAxisDuration: 1.4, easingOption: .easeInOutQuad)
        pieChart.highlightValue(x: Double(highestEntryIndex), dataSetIndex: 0, callDelegate: true)
    }
    
    func initPieChart(pieChart:PieChartView) {
        pieChart.chartDescription?.text = ""
        pieChart.rotationEnabled = false
        pieChart.delegate = self
        
        
        let legend = pieChart.legend
        legend.enabled = false
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if let pieChart = chartView as? PieChartView {
            let percentage = Int(round(entry.y))
            if entry.data != nil {
                pieChart.centerText = "\(entry.data!) \n \(percentage)%"
            }
        }
    }
    
    func chartValueNothingSelected(chartView: ChartViewBase) {
        if let pieChart = chartView as? PieChartView {
            pieChart.centerText = "Velg sektor"
        }
    }
    
    @IBAction func alternativeButton(_ sender: UIBarButtonItem) {
        (tabBarController as? MainTabBarController)?.displayOptionsMenu(sender)
    }
    
    /*@IBAction func graphInfo(sender: UIButton) {
        let content = "Graf THC: Denne grafen viser tiden det kan ta for THC-metabolitter å skilles ut av kroppen om du har brukt cannabis regelmessig. Det kan ta opptil seks uker (og i noen tilfeller lengre) før THC-metabolitter er skilt ut av kroppen, dersom du har brukt cannabis over tid.\n\nGraf humørsvingninger: Denne grafen viser hva du kan forvente av humørsvingninger når du slutter med cannabis etter jevnlig bruk.  Grafen er en generell fremstilling, men det vil være individuelle forskjeller i graden av humørsvingninger man vil oppleve når man slutter.\n\nDen røde nålen viser hvor du befinner deg i programmet. Klikk på faseoverskriftene for å lese mer.\n\nGrafene er kun en visuell illustrasjon for at du lettere vil kunne få en oversikt over vanlige utfordringer og abstinenser i en sluttprosess, og for å vise at THC-metabolitter (nedbrytningsprodukter) skilles ut av kroppen over tid. Det er ikke nødvendigvis noe forhold mellom THC grafen og humørsvingninger. Modellen er basert på kliniske erfaringer og empiri. Det vil si brukeres erfaringer med å slutte med cannabis. Dette er ikke en modell som forteller hvordan slutteprosessen fungerer nevrobiologisk. Modellen er under revidering, og det kan komme endringer og justeringer i denne modellen over tid, når ytterligere kliniske erfaringer vil bli systematisert sammen med forskningen på feltet."
        
        //let content = "Grafen viser forholdet mellom THC-nivået i kroppen din og hva du kan forvente av emosjonell turbulens.\n\n Den røde nålen viser hvor du befinner deg i programmet."
        let alert = UIAlertController(title: "Abstinensoversikt", message: content, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }*/
    
    /*@IBAction func graphInfo(_ sender: UIButton) {
        let content = "Graf THC:\nDenne grafen viser tiden det kan ta for THC-metabolitter å skilles ut av kroppen om du har brukt cannabis regelmessig. Det kan ta opptil seks uker (og i noen tilfeller lengre) før THC-metabolitter er skilt ut av kroppen, dersom du har brukt cannabis over tid.\n\nGraf humørsvingninger:\nDenne grafen viser hva du kan forvente av humørsvingninger når du slutter med cannabis etter jevnlig bruk.  Grafen er en generell fremstilling, men det vil være individuelle forskjeller i graden av humørsvingninger man vil oppleve når man slutter.\n\nDen røde nålen viser hvor du befinner deg i programmet. Klikk på faseoverskriftene for å lese mer.\n\nGrafene er kun en visuell illustrasjon for at du lettere vil kunne få en oversikt over vanlige utfordringer og abstinenser i en sluttprosess, og for å vise at THC-metabolitter (nedbrytningsprodukter) skilles ut av kroppen over tid. Det er ikke nødvendigvis noe forhold mellom THC grafen og humørsvingninger.\n\nModellen er basert på kliniske erfaringer og empiri. Det vil si brukeres erfaringer med å slutte med cannabis. Dette er ikke en modell som forteller hvordan slutteprosessen fungerer nevrobiologisk.\n\nModellen er under revidering, og det kan komme endringer og justeringer i denne modellen over tid, når ytterligere kliniske erfaringer vil bli systematisert sammen med forskningen på feltet."
        
        //let content = "Grafen viser forholdet mellom THC-nivået i kroppen din og hva du kan forvente av emosjonell turbulens.\n\n Den røde nålen viser hvor du befinner deg i programmet."
        let alert = UIAlertController(title: "Abstinensoversikt", message: content, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        /*let height:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.40)
        alert.view.addConstraint(height)*/
        
        present(alert, animated: true, completion: nil)
    }*/
    
    @IBAction func resistedInfo(_ sender: UIButton) {
        let content = "Dersom du motstår å ruse deg kan du registrere det i triggerdagboken.\n\n Over tid vil dette vinduet gi deg en god oversikt over hva som hjelper best, når suget melder seg."
        let alert = UIAlertController(title: "Positive triggere", message: content, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func smokedInfo(_ sender: UIButton) {
        let content = "Dersom du ruser deg kan du registrere det i triggerdagboken.\n\n Over tid vil dette vinduet gi deg en god oversikt over hvilke situasjoner du bør passe deg for."
        let alert = UIAlertController(title: "Negative triggere", message: content, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
