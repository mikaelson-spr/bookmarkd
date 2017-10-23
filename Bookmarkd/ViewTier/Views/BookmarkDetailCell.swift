//
//  BookmarkDetailCell.swift
//  Bookmarkd
//
//  Created by Mikael Son on 10/5/17.
//  Copyright © 2017 SPR. All rights reserved.
//

import UIKit

class BookmarkDetailCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
