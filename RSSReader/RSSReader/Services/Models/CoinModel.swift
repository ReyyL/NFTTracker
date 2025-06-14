//
//  CoinModel.swift
//  RSSReader
//
//  Created by Andrey Lazarev on 26.04.2025.
//

import Foundation

struct CryptoCurrency: Codable {
    let usd: Double
    let usd24hChange: Double

    enum CodingKeys: String, CodingKey {
        case usd
        case usd24hChange = "usd_24h_change"
    }
}
