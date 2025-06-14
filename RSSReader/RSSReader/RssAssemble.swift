//
//  CoinAssemble.swift
//  RSSReader
//
//  Created by Andrey Lazarev on 26.04.2025.
//

import UIKit

public final class RssAssemble {
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func assemble() -> UIViewController {
        let coinService = CoinService(networkManager: networkManager)
        let presenter = CoinPresenter(coinService: coinService)
        let controller = CoinViewController(presenter: presenter)
        
        presenter.view = controller
        controller.delegate = presenter
        
        return UINavigationController(rootViewController: controller)
    }
}
