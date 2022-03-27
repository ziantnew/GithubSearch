//
//  RepositoryTableViewCell.swift
//  GithubSearch
//
//  Created by 윤mac on 2022/03/27.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {

    @IBOutlet weak var mImageView: ImageLoader!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
