//
//  NetworkRequest.swift
//  RSSReader
//
//  Created by Andrey Lazarev on 26.04.2025.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol NetworkRequest {
    var endpoint: URL? { get }
    var httpMethod: HttpMethod { get }
}
