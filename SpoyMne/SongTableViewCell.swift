//
//  SongTableViewCell.swift
//  SpoyMne
//
//  Created by Vsevolod Onishchenko on 05.01.2018.
//  Copyright © 2018 Vsevolod Onishchenko. All rights reserved.
//

import UIKit

final class SongTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var songNameLabel: UILabel!
    @IBOutlet private weak var artistNameLabel: UILabel!
    
    func configureCell(_ viewModel: SongModel) {
        self.songNameLabel.text = viewModel.songName
        self.artistNameLabel.text = viewModel.artistName
    }
}
