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

class SearchViewController: UIViewController {

    @IBOutlet weak var mTableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var disposeBag : DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.searchController = self.searchController
        searchController.obscuresBackgroundDuringPresentation = false
      
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
