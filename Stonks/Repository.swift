//
//  Repository.swift
//  Stonks
//
//  Created by Adrian Devezin on 3/13/21.
//

import Foundation
import Combine

protocol Repostiory {
    func getStonks(subredditType: Int) -> AnyPublisher<StonksResponse, Error>
}

class RepositoryImpl: Repostiory {
    func getStonks(subredditType: Int) -> AnyPublisher<StonksResponse, Error> {
        StonksApi.getStonks(subredditType: subredditType)
    }
}
