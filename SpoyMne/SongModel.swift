//
//  SongCellModel.swift
//  SpoyMne
//
//  Created by Vsevolod Onishchenko on 09.01.2018.
//  Copyright © 2018 Vsevolod Onishchenko. All rights reserved.
//

class SongModel {
    
    let artistName: String
    let songName: String
    let songUrl: String
    let songImage: String
    
    init(artistName: String, songName: String, songUrl: String, songImage: String) {
        self.artistName = artistName
        self.songName = songName
        self.songUrl = songUrl
        self.songImage = songImage
    }
}
