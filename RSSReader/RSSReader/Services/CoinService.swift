//
//  CoinService.swift
//  RSSReader
//
//  Created by Andrey Lazarev on 26.04.2025.
//

import Foundation

protocol ICoinService {
    func loadCoins(cryptos: [String], completion: @escaping (Result<[CryptoItem], Error>) -> Void)
}

final class CoinService: ICoinService {
    
    private let networkManager: NetworkManager
    private var timer: Timer?
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func loadCoins(cryptos: [String], completion: @escaping (Result<[CryptoItem], Error>) -> Void) {
        let request = CoinRequest(cryptos: cryptos)
        
        networkManager.getCryptoItems(for: request, onResponse: completion)
    }
}
