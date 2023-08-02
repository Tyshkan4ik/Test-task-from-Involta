//
//  MessageRequest.swift
//  Test task from Involta
//
//  Created by Виталий Троицкий on 26.07.2023.
//

import Foundation

struct MessageRequest: RequestApiProtocol {
    
    let offset: String
    
    var url: URL {
        return URL(string: "https://numia.ru/api/getMessages?offset=\(offset)")!
    }
    
    var urlRequest: URLRequest? {
        return URLRequest(url: url)
    }
}
