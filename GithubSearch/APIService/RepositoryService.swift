//
//  APIService.swift
//  GithubSearch
//
//  Created by 윤mac on 2022/03/27.
//

import RxSwift
import RxCocoa
import Alamofire
import RxSwift


protocol RepositoryServiceProtocol {
    func search(query: String?, page: Int) ->  Observable<(items: [Repository], nextPage: Int?)>
}

struct RepositoryService: RepositoryServiceProtocol
{
    private let baseURL = "https://api.github.com"
//    private let token = "token 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"
    
    func  search(query: String?, page: Int) -> Observable<(items: [Repository], nextPage: Int?)> {
        
        let emptyResult: ([Repository], Int?) = ([], nil)
        
        guard let query = query, !query.isEmpty else { return .just(emptyResult) }
                
        let url = baseURL + "/search/repositories"
        let params: Parameters = [
            "q": query,
            "page": page
        ]
        let headers: HTTPHeaders = ["Accept": "application/vnd.github.v3+json"]
        
        return .create() { subscriber in
            guard
                let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            else {
                subscriber.onError(NSError.init(domain: "error", code: -1, userInfo: nil))
                return Disposables.create()
            }
            AF.request(encodedURL, method: .get, parameters: params, headers: headers)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        guard let repositories = try? decoder.decode(APIResponse.self, from: data).items  else {
                            return  subscriber.onNext(emptyResult)}
                        
                        let nextPage =  page + 1
                        subscriber.onNext((repositories, nextPage))
                        
                    case .failure(let error):
                        subscriber.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
    
    
}




