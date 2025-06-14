//
//  NetworkManager.swift
//  RSSReader
//
//  Created by Andrey Lazarev on 26.04.2025.
//

import Foundation

enum NetworkClientError: Error {
    case httpStatusCode(Int)
    case parsingError
    case urlSessionError
    case urlRequestError(Error)
}

protocol INetworkManager {
    func getData<T: Decodable>(for request: NetworkRequest,
                               type: T.Type,
                               onResponse: @escaping (Result<T, Error>) -> Void)
    
    func getCryptoItems(for request: NetworkRequest,
                        onResponse: @escaping (Result<[CryptoItem], Error>) -> Void)
}

struct CryptoItem {
    let name: String
    let coin: CryptoCurrency
}

class NetworkManager: INetworkManager {
    
    private let urlSession = URLSession.shared
    
    func getData<T: Decodable>(
        for request: NetworkRequest,
        type: T.Type,
        onResponse: @escaping (Result<T, Error>) -> Void
    ) {
        let onResponse: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                onResponse(result)
            }
        }
        guard let urlRequest = create(request: request) else { return }
        
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            
            if let error {
                print("Ошибка запроса: \(error)")
                return
            }
            
            guard let data else {
                print("Данные отсутствуют")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                onResponse(.success(response))
            } catch {
                onResponse(.failure(NetworkClientError.parsingError))
            }
        }
        
        task.resume()
    }
    
    func getCryptoItems(for request: NetworkRequest,
                        onResponse: @escaping (Result<[CryptoItem], Error>) -> Void) {
        getData(for: request, type: [String: CryptoCurrency].self) { result in
            switch result {
            case .success(let cryptoDict):
                let items = cryptoDict.map { CryptoItem(name: $0.key, coin: $0.value) }
                onResponse(.success(items))
            case .failure(let error):
                onResponse(.failure(error))
            }
        }
    }
    
    // MARK: - Private
    
    private func create(request: NetworkRequest) -> URLRequest? {
        guard let endpoint = request.endpoint else { return nil }
        
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = request.httpMethod.rawValue
        
        return urlRequest
    }
}
