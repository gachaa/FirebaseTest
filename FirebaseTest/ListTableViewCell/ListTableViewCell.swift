//
//  ListTableViewCell.swift
//  FirebaseTest
//
//  Created by 前本英里香 on 2018/02/17.
//  Copyright © 2018年 Erika Maemoto. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var postDateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
