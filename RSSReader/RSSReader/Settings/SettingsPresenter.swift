//
//  SettingsPresenter.swift
//  RSSReader
//
//  Created by Andrey Lazarev on 24.05.2025.
//

import Foundation

protocol ISettingsPresenter {
    func viewDidLoad()
    var coins: [String] { get }
}

final class SettingsPresenter: ISettingsPresenter {
    
    weak var view: SettingsViewController?
    
    var coins = [
        "Bitcoin",
        "Ethereum",
        "Dogecoin",
        "Tether",
        "TrumpCoin",
        "BinanceCoin",
        "Solana",
        "Ripple",
        "Cardano",
        "The-open-network",
    ]
    
    func viewDidLoad() {
        view?.setCoins()
    }
}
