//
//  ChartInteractor.swift
//  Chart
//
//  Created by reyhan muhammad on 26/03/24.
//

import Foundation

class ChartInteractor: ChartPresenterToInteractorProtocol{
    var presenter: ChartInteractorToPresenterProtocol?
    var dataProvider: DataProviderProtocol
    
    init(dataProvider: DataProviderProtocol) {
        self.dataProvider = dataProvider
    }
    
    func fetchData(filename: String, ofType: String) {
        do{
            let chartData: [ChartDataModel] = try dataProvider.getData(filename: filename, ofType: ofType)
            for data in chartData{
                switch data.data {
                case .dataClass(let dataClass):
                    presenter?.result(result: .success(.successfullyFetchLineData(dataClass)))
                case .dataDatumArray(let donutData):
                    presenter?.result(result: .success(.successfullyFetchDonutData(donutData)))
                }
            }
        }catch{
            presenter?.result(result: .failure(error))
        }
    }
}
