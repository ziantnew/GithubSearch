//
//  TableSection.swift
//  GithubSearch
//
//  Created by 윤mac on 2022/03/27.
//

import RxDataSources

struct RepoTableSection {
    var header: String // 필요 없으면 안써도 됨
    var items: [Item]
}

extension RepoTableSection: SectionModelType {
    typealias Item = Repository
    init(original: RepoTableSection, items: [Item]) {
        self = original
        self.items = items
    }
}
