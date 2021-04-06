//
//  ManagePostViewCell.swift
//  aerie
//
//  Created by Gitjillian on 2021/3/26.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import UIKit

class ManagePostViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var expectedLocation: UILabel!
    @IBOutlet weak var budget: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
