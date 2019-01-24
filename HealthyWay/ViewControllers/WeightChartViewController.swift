//
//  WeightChartViewController.swift
// HealthyWay
//
//  Created by Bill Weatherwax on 7/21/18.
//  Copyright © 2018 waxcruz. All rights reserved.
//

import UIKit
import HealthyWayFramework
import Charts


class WeightChartViewController: UIViewController {
    // MARK: - global model controller
    var modelController : ModelController!

    @IBOutlet weak var copyright: UILabel!
    @IBOutlet weak var lineChart: LineChartView!
    
    
    // MARK - model data
    var clientNode : [String : Any?] = [:] // key is node type journal, settings, and mealContent
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modelController = (self.parent as! HealthyWayTabBarController).getModel()
        copyright.text = makeCopyright()
        lineChart.noDataText = ""
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUser()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    
    // MARK - process users
    func getUser() {
        guard let email = modelController.signedinEmail else {return}
        if email == "" {
            return
        }
        modelController.getNodeUserData(errorHandler: errorInDatabase, handler: assembleUserData)
    }
    
    // MARK - assemble data helper methods
    func assembleUserData() {
        self.lineChart.clear()
        self.lineChartUpdate(userNode: modelController.signedinUserDataNode)
    }
    
    func errorInDatabase(message : String) {
        print(message)
        self.lineChart.clear()
    }
    
    
    // MARK: - Charting Methods
    func lineChartUpdate(userNode node : [String : Any?]) {
        guard node.count > 0 else {
            return
        }
        let nodeJournal = node[KeysForFirebase.NODE_JOURNAL] as? [String: Any?]
        if nodeJournal == nil {
            return
        }
        var sortedKeysDates = Array(nodeJournal!.keys).sorted(by: <)
        var sortedKeysDatesWithWeight = sortedKeysDates
        sortedKeysDatesWithWeight.removeAll()
        // filter dates with no weight
        for weightIndex in 0..<sortedKeysDates.count {
            let weightDate = sortedKeysDates[weightIndex]
            let nodeDate = nodeJournal![weightDate] as? [String : Any?] ?? [:]
            let weight = nodeDate[KeysForFirebase.WEIGHED] as? Double ?? 0.0
            if weight > 0.0 {
                sortedKeysDatesWithWeight.append(weightDate)
            }
        }
        // trim to 7 most recent weights
        while sortedKeysDatesWithWeight.count > 7 {
            sortedKeysDatesWithWeight.removeFirst()
        }
        var startDate = ""
        var startWeight = 0.0
        var chartDataPoint = [String : Double]()
        for weightDate in sortedKeysDatesWithWeight {
            let nodeDate = nodeJournal![weightDate] as? [String : Any?] ?? [:]
            if startDate == "" {
                startDate = weightDate // earliest date
                startWeight = nodeDate[KeysForFirebase.WEIGHED] as? Double ?? 0.0
                chartDataPoint[weightDate] = 0.0
            } else {
                chartDataPoint[weightDate] = (nodeDate[KeysForFirebase.WEIGHED] as? Double ?? 0.0) - startWeight
            }
        }
        
        // now format chart series
        var chartSeries = [ChartDataEntry]()
        var chartLabels = [String]()
        var xValue = 0.0
        for weightDate in sortedKeysDatesWithWeight {
            let weightDateAsDate = makeDateFromString(dateAsString: weightDate)
            let weightMonthSlashDayKey = weightDateAsDate.makeMonthSlashDayDisplayString()
            let point = ChartDataEntry(x: xValue, y:  chartDataPoint[weightDate]!)
            chartSeries.append(point)
            chartLabels.append(weightMonthSlashDayKey)
            xValue += 1.0
        }
        let weightDataSet = LineChartDataSet(values: chartSeries, label: Constants.CHART_DATA_DESCRIPTION)
        weightDataSet.valueColors = [UIColor .black]
        weightDataSet.circleColors = [UIColor .green]
        weightDataSet.colors = [UIColor .green]
        let weightData = LineChartData(dataSet: weightDataSet)
        lineChart.data = weightData
        lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: chartLabels)
        lineChart.xAxis.granularity = 1
        lineChart.xAxis.labelRotationAngle = -45.0
        lineChart.chartDescription?.text = Constants.CHART_DESCRIPTION
        lineChart.drawBordersEnabled = true
        
        lineChart.notifyDataSetChanged()
        
    }
    
    
    // MARK: - Navigation
 /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 */
    

}
