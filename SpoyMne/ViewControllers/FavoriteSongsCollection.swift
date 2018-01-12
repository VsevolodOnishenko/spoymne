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
/**
 Класс отвечает за экран плэйлиста пользователя
 */
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
    /**
    Метод регистрации кастомной ячейки
    */
    private func registerCell() {
        let nibName = UINib(nibName: "SongCollectionViewCell", bundle: nil)
        favoriteSongsCollection.register(nibName, forCellWithReuseIdentifier: "songCollectionCell")
    }
    /**
     Функция получения песен из хранилища
     */
    private func fetchDataFromStore() {
        let store = CoreDataService()
        store.fetchSong { [weak self] (songs) in
            for song in songs {
                guard let artist = song.artistName,
                    let name = song.songName,
                    let image = song.songImage,
                    let url = song.songUrl else { return }
                let castSong = SongModel(artistName: artist,
                                         songName: name,
                                         songUrl: url,
                                         songImage: image)
                self?.favoriteSongs.append(castSong)
            }
        }
    }
    
}

// MARK: DataSource and Delegate implementation
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
        guard let collectionDelegate = delegate else { return }
        collectionDelegate.changePlayingSong(song: favoriteSongs[indexPath.row])
        self.performSegueToReturnBack()
    }
}

