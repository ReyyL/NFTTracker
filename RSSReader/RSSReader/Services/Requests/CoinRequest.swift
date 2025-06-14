//
//  CoinRequest.swift
//  RSSReader
//
//  Created by Andrey Lazarev on 26.04.2025.
//

import Foundation

struct CoinRequest: NetworkRequest {
    
    var cryptos: [String]
    
    var endpoint: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.coingecko.com"
        components.path = "/api/v3/simple/price"
        components.queryItems = [
            URLQueryItem(name: "ids", value: cryptos.joined(separator: ",")),
            URLQueryItem(name: "vs_currencies", value: "usd"),
            URLQueryItem(name: "include_24hr_change", value: "true")
        ]
        return components.url
    }
    
    var httpMethod: HttpMethod {
        .get
    }
}
