//
//  PostTableViewCell.swift
//  aerie
//
//  Created by jillianli on 2021/3/24.
//  Copyright © 2021 Christopher Ching. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var NameLabel:     UILabel!
    @IBOutlet weak var genderBtn: UIButton!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var avatarImage:   UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImage.clipsToBounds = true
        avatarImage.layer.cornerRadius = avatarImage.frame.size.width/2
        backgroundColor = .systemBackground
        contentView.backgroundColor = .systemBackground
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
