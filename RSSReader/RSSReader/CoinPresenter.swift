//
//  CoinPresenter.swift
//  RSSReader
//
//  Created by Andrey Lazarev on 26.04.2025.
//

import Foundation

protocol ICoinPresenter {
    var coins: [CryptoItem]? { get }
    func viewDidLoad()
}

final class CoinPresenter: ICoinPresenter {
    
    private let coinService: ICoinService
    
    private(set) var coins: [CryptoItem]?
    
    private var selectedCoins: [String] = UserDefaults.standard.stringArray(forKey: "selectedCoins") ?? []
    
    weak var view: ICoinViewController?
    
    init(coinService: ICoinService) {
        self.coinService = coinService
    }
    
    func viewDidLoad() {
        view?.showLoader()
        
        coinService.loadCoins(cryptos: selectedCoins) { result in
            switch result {
            case .success(let coins):
                self.coins = coins.sorted(by: {
                    $0.name < $1.name
                })
                self.view?.updateView()
            case .failure(let failure):
                print("echo2", failure)
            }
        }
    }
}

extension CoinPresenter: SettingsDelegate {
    func didUpdateSettings(selectedCoins: [String]) {
        self.selectedCoins = selectedCoins
    }
}
