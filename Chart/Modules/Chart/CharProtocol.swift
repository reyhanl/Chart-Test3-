//
//  CharProtocol.swift
//  Chart
//
//  Created by reyhan muhammad on 26/03/24.
//

import Foundation

protocol ChartViewToPresenterProtocol{
    var view: ChartPresenterToViewProtocol?{get set}
    var router: ChartPresenterToRouterProtocol?{get set}
    
    func viewDidLoad()
    func goToTransactionHistory(from: ChartViewController, spendingDetail: SpendingCategory)
}

protocol ChartPresenterToRouterProtocol{
    func goToTransactionHistory(from: ChartViewController, spendingDetail: SpendingCategory)
}

protocol ChartPresenterToInteractorProtocol{
    var presenter: ChartInteractorToPresenterProtocol?{get set}
    var dataProvider: DataProviderProtocol{get set}
    
    func fetchData(filename: String, ofType: String)
}

protocol ChartInteractorToPresenterProtocol{
    var interactor: ChartPresenterToInteractorProtocol?{get set}
    
    func result(result: Result<ChartSuccessType, Error>)
}

protocol ChartPresenterToViewProtocol{
    var presenter: ChartViewToPresenterProtocol?{get set}
    
    func updateDonutChart(data: [SpendingCategory])
    func updateLineChart(data: DataClass)
}

enum ChartSuccessType{
    case successfullyFetchDonutData([SpendingCategory])
    case successfullyFetchLineData(DataClass)
}
