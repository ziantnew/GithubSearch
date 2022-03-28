//
//  SearchReactor.swift
//  GithubSearch
//
//  Created by 윤mac on 2022/03/27.
//

import Foundation
import ReactorKit
import RxCocoa

class SearchReactor: Reactor {
    
    enum Action {
        case updateQuery(String?)
        case loadNextPage
    }
    
    enum Mutation {
        case setQuery(String?)
        case setRepos([RepoTableSection.Item], nextPage: Int?)
        case appendRepos([RepoTableSection.Item], nextPage: Int?)
        case setLoadingNextPage(Bool)
    }
    
    struct State {
        var query: String?
        var nextPage: Int?
        var isLoadingNextPage: Bool = false
    
        var repos = RepoTableSection(items: [])
            
        
    }
    
    let initialState: State = State()
    
    let provider: RepositoryServiceProtocol
    
    init(provider: RepositoryServiceProtocol) {
        self.provider = provider
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateQuery(let query):
            return Observable.concat([
                Observable.just(Mutation.setQuery(query)),
                
                self.provider.search(query: query, page: 1)
                    .take(until: self.action.filter(Action.isUpdateQueryAction(_:)))
                    .map { Mutation.setRepos($0.map(RepoTableSection.Item.main), nextPage: $1) }
            ])
        case .loadNextPage:
            guard !self.currentState.isLoadingNextPage else { return Observable.empty() }
            guard let page = self.currentState.nextPage else { return Observable.empty() }
            return Observable.concat([
                Observable.just(Mutation.setLoadingNextPage(true)),
                
                self.provider.search(query: self.currentState.query, page: page)
                    .take(until: self.action.filter(Action.isUpdateQueryAction(_:)))
                    .map { Mutation.appendRepos($0.map(RepoTableSection.Item.main), nextPage: $1) },
                
                Observable.just(Mutation.setLoadingNextPage(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setQuery(query):
            newState.query = query
            
        case let .setRepos(repos, nextPage: nextPage):
            newState.repos.items = repos
            newState.nextPage = nextPage
            
        case let .appendRepos(repos, nextPage: nextPage):
            newState.repos.items.append(contentsOf: repos)
            newState.nextPage = nextPage
            
        case let .setLoadingNextPage(isLoadingNextPage):
            newState.isLoadingNextPage = isLoadingNextPage
        }
        return newState
    }
    

}

extension SearchReactor.Action {
    static func isUpdateQueryAction(_ action: SearchReactor.Action) -> Bool {
        if case .updateQuery = action {
            return true
        } else {
            return false
        }
    }
}


