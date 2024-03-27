//
//  CustomError.swift
//  Chart
//
//  Created by reyhan muhammad on 27/03/24.
//

import Foundation

enum CustomError: Error{
    case fileDoesNotExistDataProvider
    case custom(String)
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .fileDoesNotExistDataProvider:
            return NSLocalizedString("Data provider is unable to find the file you provided", comment: "Please check the filename again and make sure they exist")
        default:
            return NSLocalizedString("Something went wrong", comment: "Something unexpected occured")
        }
    }
}
