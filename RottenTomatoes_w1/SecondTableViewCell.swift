//
//  SecondTableViewCell.swift
//  RottenTomatoes_w1
//
//  Created by Lam Do on 11/12/15.
//  Copyright © 2015 Lam Do. All rights reserved.
//

import UIKit

class SecondTableViewCell: UITableViewCell {

    @IBOutlet weak var tableViewCell: UILabel!
    @IBOutlet weak var SummaryView: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
