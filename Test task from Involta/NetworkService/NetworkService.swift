//
//  NetworkService.swift
//  Test task from Involta
//
//  Created by Виталий Троицкий on 26.07.2023.
//

import Foundation

struct NetworkService {
    private func get<T: Decodable>(with request: URLRequest, decoder: JSONDecoder = JSONDecoder(), completion: @escaping (Result<T, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                completion(.failure(FetchError.noDataReceived))
                return
            }
            do {
                let object = try decoder.decode(T.self, from: data)
                completion(.success(object))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private enum FetchError: Error {
        case noHTTPResponse
        case noDataReceived
        case unacceptableStatusCode
    }
}

extension NetworkService {
    func getMessage(for source: RequestApiProtocol, completion: @escaping (Result<MessageResponce, Error>) -> Void) {
        let request = source
        get(with: request.urlRequest!, completion: completion)
    }
}
