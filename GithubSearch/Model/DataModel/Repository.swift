//
//  Repository.swift
//  GithubSearch
//
//  Created by 윤mac on 2022/03/27.
//

import Foundation

struct APIResponse: Codable {
    let total_count: Int
    let items: [Repository]
}

struct Repository: Codable {
    let id: Int
    let fullName: String
    let forksCount: Int
    let user: User
    let language: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case fullName = "full_name"
        case forksCount = "forks_count"
        case user = "owner"
        case language = "language"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.fullName = try container.decode(String.self, forKey: .fullName)
        self.forksCount = try container.decode(Int.self, forKey: .forksCount)
        self.user = try container.decode(User.self, forKey: .user)
        self.language = try container.decode(String.self, forKey: .language)
    }
    
}

struct User: Codable {
    let reposUrl: String
    let avatarUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case reposUrl = "repos_url"
        case avatarUrl = "avatar_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.reposUrl = try container.decode(String.self, forKey: .reposUrl)
        self.avatarUrl = try container.decode(String.self, forKey: .avatarUrl)
    }
    
}


