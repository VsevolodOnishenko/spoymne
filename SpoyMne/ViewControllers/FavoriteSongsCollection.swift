//
//  FavoritesSongsCollection.swift
//  SpoyMne
//
//  Created by Vsevolod Onishchenko on 10.01.2018.
//  Copyright © 2018 Vsevolod Onishchenko. All rights reserved.
//

import UIKit

protocol ChangePlayingSongProtocol: class {
    func changePlayingSong(song: SongModel)
}

class FavoriteSongsCollection: BaseViewController {
    
    @IBOutlet weak var favoriteSongsCollection: UICollectionView!
    weak var delegate: ChangePlayingSongProtocol?
    
    var favoriteSongs: [SongModel] = [] {
        didSet {
            favoriteSongsCollection.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteSongsCollection.delegate = self
        favoriteSongsCollection.dataSource = self
        registerCell()
        fetchDataFromStore()
    }
    
    private func registerCell() {
        let nibName = UINib(nibName: "SongCollectionViewCell", bundle: nil)
        favoriteSongsCollection.register(nibName, forCellWithReuseIdentifier: "songCollectionCell")
    }
    
    private func fetchDataFromStore() {
        let store = CoreDataService()
        store.fetchSong { [weak self] (songs) in
            for song in songs {
                let castSong = SongModel(artistName: song.artistName!,
                                         songName: song.songName!,
                                         songUrl: song.songUrl!,
                                         songImage: song.songImage!)
                self?.favoriteSongs.append(castSong)
            }
        }
    }
    
}

extension FavoriteSongsCollection: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteSongs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = favoriteSongsCollection.dequeueReusableCell(withReuseIdentifier: "songCollectionCell", for: indexPath) as? SongCollectionViewCell
        guard let playlistCell = cell else { return UICollectionViewCell() }
        playlistCell.configureCell(cover: favoriteSongs[indexPath.row].songImage,
                                   name: favoriteSongs[indexPath.row].songName)
        return playlistCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let myDelegate = delegate else { return }
        myDelegate.changePlayingSong(song: favoriteSongs[indexPath.row])
        self.performSegueToReturnBack()
    }
}

extension FavoriteSongsCollection {
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
