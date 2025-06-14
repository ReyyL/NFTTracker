//
//  NetworkTask.swift
//  RSSReader
//
//  Created by Andrey Lazarev on 04.05.2025.
//

import Foundation

protocol NetworkTask {
    func cancel()
}

struct DefaultNetworkTask: NetworkTask {
    let dataTask: URLSessionDataTask

    func cancel() {
        dataTask.cancel()
    }
}
