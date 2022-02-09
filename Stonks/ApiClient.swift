//
//  ApiClient.swift
//  Stonks
//
//  Created by Adrian Devezin on 3/14/21.
//

import Foundation
import Combine

struct ApiClient {
    struct Result<T> {
        let value: T
        let response: URLResponse
    }
    
    func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<Result<T>, Error> {
        var requestToSend = request
        requestToSend.cachePolicy = .useProtocolCachePolicy
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> Result<T> in
                var value: T?
                var caughtError: Error?
                do {
                    value = try JSONDecoder().decode(T.self, from: result.data)
                } catch {
                    caughtError = error
                }
                if let value = value {
                    return Result(value: value , response: result.response)
                } else if let response = result.response as? HTTPURLResponse {
                    if (response.statusCode == 200) {
                        throw caughtError!
                    } else {
                        caughtError = NSError(domain: response.description, code: response.statusCode, userInfo: nil)
                        throw caughtError!
                    }
                } else {
                    throw caughtError!
                }
                
        }.receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
