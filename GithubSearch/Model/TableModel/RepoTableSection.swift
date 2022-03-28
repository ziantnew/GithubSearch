//
//  TableSection.swift
//  GithubSearch
//
//  Created by 윤mac on 2022/03/27.
//

import RxDataSources

struct RepoTableSection {
    var items: [Item]
}

enum SectionItem {
    case main(Repository)
 }

extension RepoTableSection: SectionModelType {
    typealias Item = SectionItem
    init(original: RepoTableSection, items: [Item]) {
        self = original
        self.items = items
    }
}


