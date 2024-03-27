//
//  DataProvider.swift
//  Chart
//
//  Created by reyhan muhammad on 26/03/24.
//

import Foundation

class DataProvider: DataProviderProtocol{
    func getData<T: Decodable>(filename: String, ofType: String) throws -> T{
        if let path = getPath(filename: filename, ofType: ofType){
            do{
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
                
                let decoder = JSONDecoder()
                let model = try decoder.decode(T.self, from: data)
                return model
                
            }catch{
                print("error: \(error.localizedDescription)")
                throw error
            }
        }else{
            print("error: path does not exist")
            throw CustomError.fileDoesNotExistDataProvider
        }
    }
    
    func getPath(filename: String, ofType: String) -> String? {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: filename, ofType: ofType)
        return path
    }
}

protocol DataProviderProtocol{
    
    func getData<T: Decodable>(filename: String, ofType: String) throws -> T
    func getPath(filename: String, ofType: String) -> String?
}
