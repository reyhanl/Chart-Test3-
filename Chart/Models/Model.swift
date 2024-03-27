//
//  Model.swift
//  Chart
//
//  Created by reyhan muhammad on 26/03/24.
//

import Foundation

struct ChartDataModel: Codable {
    let type: String
    let data: DataUnion
}

enum DataUnion: Codable {
    case dataClass(DataClass)
    case dataDatumArray([SpendingCategory])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([SpendingCategory].self) {
            self = .dataDatumArray(x)
            return
        }
        if let x = try? container.decode(DataClass.self) {
            self = .dataClass(x)
            return
        }
        throw DecodingError.typeMismatch(DataUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for DataUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .dataClass(let x):
            try container.encode(x)
        case .dataDatumArray(let x):
            try container.encode(x)
        }
    }
}

struct SpendingCategory: Codable {
    let label, percentage: String
    let data: [SpendingDetail]
}

struct SpendingDetail: Codable {
    let trxDate: TrxDate
    let nominal: Int

    enum CodingKeys: String, CodingKey {
        case trxDate = "trx_date"
        case nominal
    }
}

enum TrxDate: String, Codable {
    case the19012023 = "19/01/2023"
    case the20012023 = "20/01/2023"
    case the21012023 = "21/01/2023"
}

struct DataClass: Codable {
    let month: [Int]
}

typealias ChartDataModels = [ChartDataModel]
