//
//  ChartPresenter.swift
//  Chart
//
//  Created by reyhan muhammad on 26/03/24.
//

import Foundation

class ChartPresenter: ChartViewToPresenterProtocol{
    var router: ChartPresenterToRouterProtocol?
    var view: ChartPresenterToViewProtocol?
    var interactor: ChartPresenterToInteractorProtocol?

    
    func viewDidLoad() {
        interactor?.fetchData(filename: "data", ofType: "json")
    }
    
    func goToTransactionHistory(from: ChartViewController, spendingDetail: SpendingCategory) {
        router?.goToTransactionHistory(from: from, spendingDetail: spendingDetail)
    }
}

extension ChartPresenter: ChartInteractorToPresenterProtocol{
    
    func result(result: Result<ChartSuccessType, Error>) {
        switch result{
        case .success(let type):
            handleSuccess(type: type)
        case .failure(let error):
            print("error: \(error.localizedDescription)")
        }
    }
    
    func handleSuccess(type: ChartSuccessType){
        switch type{
        case .successfullyFetchDonutData(let donutData):
            view?.updateDonutChart(data: donutData)
        case .successfullyFetchLineData(let data):
            view?.updateLineChart(data: data)
        }
    }
}
