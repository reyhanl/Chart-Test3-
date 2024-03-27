//
//  Int+Extension.swift
//  Chart
//
//  Created by reyhan muhammad on 26/03/24.
//

import Foundation

extension Int{
    func getCurrency(_ useLocale: Bool = true) -> String{
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        if useLocale{
            currencyFormatter.locale = Locale.current

        }

        let priceString = currencyFormatter.string(from: NSNumber(value: self))!
        return priceString
    }
}
