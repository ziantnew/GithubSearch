//
//  SearchViewController.swift
//  GithubSearch
//
//  Created by 윤mac on 2022/03/27.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift
import RxDataSources
import SafariServices

class SearchViewController: UIViewController, StoryboardView {
    
    @IBOutlet weak var mTableView: UITableView!
    
    let mSearchController = UISearchController(searchResultsController: nil)
    
    var disposeBag : DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.searchController = self.mSearchController
        mSearchController.obscuresBackgroundDuringPresentation = false
        
        self.setUp()
        
        self.reactor = SearchReactor(provider: RepositoryService())
        
    }
    
    func setUp()
    {
        self.mTableView.rowHeight = 80
        self.mTableView.register(UINib(nibName: "RepositoryTableViewCell", bundle: nil), forCellReuseIdentifier: "RepositoryTableViewCell")
    }
    
    func bind(reactor: SearchReactor) {
        
        mSearchController.searchBar.rx.text
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { Reactor.Action.updateQuery($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mSearchController.searchBar.rx.searchButtonClicked
            .map { Reactor.Action.updateQuery(  self.mSearchController.searchBar.text) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mTableView.rx.didScroll
            .filter { [weak self] offset in
                guard let `self` = self else { return false }
                guard self.mTableView.frame.height > 0 else { return false }
                
                let height = UIScreen.main.bounds.height
                let contentYoffset =  self.mTableView.contentOffset.y
                let distanceFromBottom = self.mTableView.contentSize.height - contentYoffset
                if distanceFromBottom < height {
                    
                }
                
                return distanceFromBottom < height
            }
            .map { _ in Reactor.Action.loadNextPage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        let dataSource = SearchViewController.dataSource()
        
        reactor.state.map(\.repos)
            .map(Array.init(with:))
            .bind(to: self.mTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
    }
    
    static func dataSource() -> RxTableViewSectionedReloadDataSource<RepoTableSection> {
        .init(
            configureCell: { _, tableView, indexPath, item in
                switch item {
                case .main(let repository):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryTableViewCell", for: indexPath) as? RepositoryTableViewCell else { fatalError() }
                    cell.__setLayout(data: repository)
                    return cell
                }
            }
            
        )
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
