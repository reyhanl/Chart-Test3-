//
//  ChartRouter.swift
//  Chart
//
//  Created by reyhan muhammad on 26/03/24.
//

import Foundation

class ChartRouter: ChartPresenterToRouterProtocol{
    
    static func makeComponent(dataProvider: DataProviderProtocol) -> ChartViewController {
        var interactor: ChartPresenterToInteractorProtocol = ChartInteractor(dataProvider: dataProvider)
        var presenter: ChartViewToPresenterProtocol & ChartInteractorToPresenterProtocol = ChartPresenter()
        let view = ChartViewController()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = ChartRouter()
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    

    func goToTransactionHistory(from: ChartViewController, spendingDetail: SpendingCategory) {
        let vc = SpendingHistoryViewController()
        vc.donutData = spendingDetail
        from.navigationController?.pushViewController(vc, animated: true)
    }
    
}
