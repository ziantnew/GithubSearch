//
//  APIService.swift
//  GithubSearch
//
//  Created by 윤mac on 2022/03/27.
//

import RxSwift
import RxCocoa


protocol RepositoryServiceProtocol {
    func search(query: String?, page: Int) ->  Observable<(items: [Repository], nextPage: Int?)>
}

struct RepositoryService: RepositoryServiceProtocol
{
    func url(for query: String?, page: Int) -> URL? {
        guard let query = query, !query.isEmpty else { return nil }
        return URL(string: "https://api.github.com/search/repositories?q=\(query)&page=\(page)")
    }
    
    func search(query: String?, page: Int) -> Observable<(items: [Repository], nextPage: Int?)> {
        let emptyResult: ([Repository], Int?) = ([], nil)
        guard let url = self.url(for: query, page: page) else { return .just(emptyResult) }
        print("url:::\(url)")
        return URLSession.shared.rx.data(request: URLRequest(url: url))
            .map {data -> ([Repository], Int?) in
   
                let decoder = JSONDecoder()
                guard let repositories = try? decoder.decode(APIResponse.self, from: data).items  else { return emptyResult}
                let nextPage =  page + 1
 
                return (repositories, nextPage)
            }
        
            .do(onError: { error in
                if case let .some(.httpRequestFailed(response, _)) = error as? RxCocoaURLError, response.statusCode == 403 {
                    print("403error")
                }
            })
            .catchAndReturn(emptyResult)
    }
}

