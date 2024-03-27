//
//  ChartUITests.swift
//  ChartUITests
//
//  Created by reyhan muhammad on 26/03/24.
//

import XCTest
import DGCharts
@testable import Chart

final class ChartUITests: XCTestCase {

    var app: XCUIApplication?


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        let app = XCUIApplication()
        self.app = app
    }

    override func tearDownWithError() throws {
        self.app = nil
    }


    func testChartDisplayingTheRightData() throws {
        // UI tests must launch the application that they test.
        app?.launch()
        let dataProvider = DataProvider()
        do{
            let data: [ChartDataModel] = try dataProvider.getData(filename: "data", ofType: "json")
            let donutChart = app?.otherElements.matching(identifier: "donutChart").element as? PieChartView
            if let donutChart = donutChart{
                print("count: \(donutChart.maxVisibleCount)")
                XCTAssertTrue(donutChart.maxVisibleCount == data.count)
            }else{
                print("button is not found")
            }
        }catch{
            print("error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func testClickingPieChart() throws {
        // UI tests must launch the application that they test.
        app?.launch()
        let donutChart = app?.otherElements.matching(identifier: "donutChart").element
        donutChart?.tap()
        let spendingVC = app?.otherElements.matching(identifier: "SpendingHistoryViewController").element
        XCTAssert(spendingVC != nil)
    }
}
