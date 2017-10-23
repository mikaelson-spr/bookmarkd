//
//  BookmarkCell.swift
//  Bookmarkd
//
//  Created by Mikael Son on 10/3/17.
//  Copyright © 2017 SPR. All rights reserved.
//

import UIKit

class BookmarkCell: UITableViewCell {

    var dataModel: BookmarkVVO?
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
