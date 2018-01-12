//
//  SongCollectionViewCell.swift
//  SpoyMne
//
//  Created by Vsevolod Onishchenko on 11.01.2018.
//  Copyright © 2018 Vsevolod Onishchenko. All rights reserved.
//

import UIKit

class SongCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var songCover: UIImageView!
    @IBOutlet weak var songName: UILabel!
    
    func configureCell(cover: String, name: String) {
        songCover.image = UIImage(data: cover.getDataFromUrl())
        songName.text = name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
        songCover.contentMode = .scaleAspectFill
        songCover.clipsToBounds = true
    }
}
