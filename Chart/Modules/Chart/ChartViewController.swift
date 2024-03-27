//
//  ViewController.swift
//  Chart
//
//  Created by reyhan muhammad on 26/03/24.
//

import UIKit
import DGCharts

class ChartViewController: BaseViewController, ChartViewDelegate, ChartPresenterToViewProtocol {
    
    lazy var chartView: PieChartView = {
        let view = PieChartView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.usePercentValuesEnabled = true
        view.drawSlicesUnderHoleEnabled = false
        view.holeRadiusPercent = 0.58
        view.transparentCircleRadiusPercent = 0.61
        view.chartDescription.enabled = false
        view.setExtraOffsets(left: 5, top: 10, right: 5, bottom: 5)
        view.delegate = self
        view.drawCenterTextEnabled = true
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        
        let centerText = NSMutableAttributedString(string: "Spending Chart")
        view.centerAttributedText = centerText;
        
        view.drawHoleEnabled = true
        view.rotationAngle = 0
        view.rotationEnabled = true
        view.highlightPerTapEnabled = true
        
        let l = view.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.drawInside = false
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        view.accessibilityIdentifier = "donutChart"
        return view
    }()
    
    lazy var lineChart: LineChartView = {
        let chartView = LineChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.delegate = self
        
        chartView.delegate = self
        
        chartView.chartDescription.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        
        let l = chartView.legend
        l.form = .line
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.textColor = .white
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        
        let xAxis = chartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 11)
        xAxis.labelTextColor = .white
        xAxis.drawAxisLineEnabled = false
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelTextColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        leftAxis.axisMaximum = 200
        leftAxis.axisMinimum = 0
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = true
        
        let rightAxis = chartView.rightAxis
        rightAxis.labelTextColor = .red
        rightAxis.axisMaximum = 900
        rightAxis.axisMinimum = -200
        rightAxis.granularityEnabled = false
        
        chartView.animate(xAxisDuration: 2.5)
        return chartView
    }()
    
    
    var presenter: ChartViewToPresenterProtocol?
    var SpendingCategories: [SpendingCategory] = []
    var months: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChartView()
        addLineChartView()
        presenter?.viewDidLoad()
        navigationItem.title = "Spending Summary"
    }
    
    func updateDonutChart(data: [SpendingCategory]) {
        SpendingCategories = data
        setDataCount()
        print("chartView: \(chartView.maxVisibleCount)")
    }
    
    func updateLineChart(data: DataClass) {
        months = data.month
        setLineChartData()
    }
    
    func addChartView(){
        view.addSubview(chartView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: chartView, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: chartView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: chartView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: chartView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        ])
        
    }
    
    func addLineChartView(){
        view.addSubview(lineChart)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: lineChart, attribute: .top, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: lineChart, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: lineChart, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: lineChart, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
        ])
        
    }
    
    func setDataCount() {
        let entries = (0..<SpendingCategories.count).map { (i) -> PieChartDataEntry in
            // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
            return PieChartDataEntry(value: Double(SpendingCategories[i].percentage) ?? 0,
                                     label: SpendingCategories[i].label,
                                     icon: .init(systemName: "qrcode"))
        }
        
        let set = PieChartDataSet(entries: entries, label: "")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        
        set.colors = ChartColorTemplates.vordiplom()
        + ChartColorTemplates.joyful()
        + ChartColorTemplates.colorful()
        + ChartColorTemplates.liberty()
        + ChartColorTemplates.pastel()
        + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.black)
        
        chartView.data = data
        chartView.highlightValues(nil)
    }
    
    func setLineChartData(){
        let count = months.count
        let yVals1 = months.enumerated().map { (index, i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(index), y: Double(i))
        }
        lineChart.leftAxis.axisMaximum = Double(months.max() ?? 0) * 2
        lineChart.leftAxis.axisMinimum = Double(months.min() ?? 0)
        let set1 = LineChartDataSet(entries: yVals1, label: "DataSet 1")
        set1.axisDependency = YAxis.AxisDependency.left
        set1.setColor(UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1))
        set1.setCircleColor(NSUIColor.white)
        set1.lineWidth = 2
        set1.circleRadius = 3
        set1.fillAlpha = 65/255
        set1.fillColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set1.drawCircleHoleEnabled = false
        
        let data: LineChartData = [set1]
        data.setValueTextColor(.white)
        data.setValueFont(.systemFont(ofSize: 9))
        chartView.animate(xAxisDuration: 2.5)
        
        
        lineChart.data = data
        
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if chartView == self.chartView{
            guard let details = SpendingCategories.first(where: {Double($0.percentage) == entry.y}) else{return}
            presenter?.goToTransactionHistory(from: self, spendingDetail: details)
        }
    }
}

