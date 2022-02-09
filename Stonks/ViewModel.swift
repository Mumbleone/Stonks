//
//  ViewModel.swift
//  Stonks
//
//  Created by Adrian Devezin on 3/13/21.
//

import Foundation
import Combine

class ViewModel: ObservableObject {
    
    private var cancellables: [AnyCancellable] = []
    private let repo: Repostiory = RepositoryImpl()
    
    @Published
    var viewState: ViewState = .initial
    
    //TODO step 1
    enum ViewState {
        case initial
        case loading
        case results([String])
        case error(String)
    }

    deinit {
        cancellables.forEach {
            $0.cancel()
        }
    }
    
    func onSearchClick(subreddit: Subreddit) {
        // TODO step 2
        let subredditType = subreddit.rawValue
        
        // TODO step 3
        let cancellabe = repo.getStonks(subredditType: subredditType).mapError({ (error) -> Error in
            self.viewState = .error(error.localizedDescription)
            print(error)
            return error
        }).sink(receiveCompletion: { _ in }, receiveValue: { stonksResponse in
            // TODO step 4
            let results = ViewState.results(stonksResponse.stonks)
            self.viewState = results
        })
        cancellables.append(cancellabe)
    }
}
