//
//  RepositoryTableViewCell.swift
//  GithubSearch
//
//  Created by 윤mac on 2022/03/27.
//

import UIKit
import Kingfisher

class RepositoryTableViewCell: UITableViewCell {

    @IBOutlet weak var mImageView: UIImageView!
    @IBOutlet weak var mLabelRepoName: UILabel!
    @IBOutlet weak var mLabelLanguage: UILabel!
    @IBOutlet weak var mLabelForks: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.mImageView.layer.cornerRadius = mImageView.bounds.height / 2
        self.mImageView.clipsToBounds = true
    }

    func __setLayout(data: Repository)
    {
        self.mLabelRepoName.text = data.fullName
        self.mLabelLanguage.text = data.language
        
        if let forks = data.forksCount
        {
            self.mLabelForks.text = "\(forks)"
        }
        
        if let url = data.owner.avatarUrl
        {
            self.mImageView.setImage(with: url)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
