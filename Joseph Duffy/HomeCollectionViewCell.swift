//
//  HomeCollectionViewCell.swift
//  Joseph Duffy
//
//  Created by Joseph Duffy on 15/04/2015.
//  Copyright (c) 2015 Yetii Ltd. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var sectionTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.contentView.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        self.contentView.setTranslatesAutoresizingMaskIntoConstraints(true)
    }
}
