//
//  StonksApi.swift
//  Stonks
//
//  Created by Adrian Devezin on 3/14/21.
//

import Foundation
import Combine

enum StonksApi {
    static let client = ApiClient()
    static let baseUrl = URL(string: "https://reddit-stonks-empowr.herokuapp.com")!
}

extension StonksApi {
    
    static func getStonks(subredditType: Int) -> AnyPublisher<StonksResponse, Error> {
        guard let components = URLComponents(url: URL(string:"\(baseUrl)/stonks?subreddit=\(subredditType)")!, resolvingAgainstBaseURL: true) else {
            fatalError("Couldn't create URLCompoents for getCategories")
        }
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        
        return client.run(request)
            .map(\.value)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
