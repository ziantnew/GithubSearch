//
//  Repository.swift
//  GithubSearch
//
//  Created by 윤mac on 2022/03/27.
//

import Foundation


struct APIResponse: Codable {
    let totalCount: Int
    let items: [Repository]
}

struct Repository: Codable {
    let id: Int
    let fullName, language: String?
    let owner: User
    let forksCount:Int?
}

struct User: Codable {
    var avatarUrl: String?
}






