//
//  ViewController.swift
//  SpoyMne
//
//  Created by Vsevolod Onishchenko on 05.01.2018.
//  Copyright © 2018 Vsevolod Onishchenko. All rights reserved.
//

import UIKit

class SearchSongViewController: BaseViewController {
    
    @IBOutlet private weak var songsTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private let networkService = NetworkService()
    private var pendingRequestWorkItem: DispatchWorkItem?
    private var songs: [SongModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.songsTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        songsTableView.delegate = self
        songsTableView.dataSource = self
        searchBar.delegate = self
        searchBar.placeholder = "Let`s search!"
        registerCell()
    }
    
    private func getSearchResultsInformation(from dict: [String: Any]) {
        guard let songName = dict["title"] as? String,
            let artist = dict["artist"] as? [String: Any],
            let artistName = artist["name"] as? String,
            let url = dict["preview"] as? String,
            let album = dict["album"] as? [String: Any],
            let albumCover = album["cover_big"] as? String else { return }
        
        let song = SongModel(artistName: artistName,
                             songName: songName,
                             songUrl: url,
                             songImage: albumCover)
        songs.append(song)
    }
    
    private func registerCell() {
        let nibName = UINib(nibName: "SongTableViewCell", bundle: nil)
        songsTableView.register(nibName, forCellReuseIdentifier: "cell")
    }
}

extension SearchSongViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = songsTableView.dequeueReusableCell(withIdentifier: "cell") as? SongTableViewCell
        guard let songCell = cell else { return UITableViewCell() }
        songCell.configureCell(songs[indexPath.row])
        return songCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let s = storyboard?.instantiateViewController(withIdentifier: "PlayerViewController")
        guard let playerView = s as? PlayerViewController else {
            return
        }
        playerView.song = songs[indexPath.row]
        navigationController?.pushViewController(playerView, animated: true)
    }
}

extension SearchSongViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        pendingRequestWorkItem?.cancel()
        songs.removeAll()
        let requestWorkItem = DispatchWorkItem { [weak self] in
            self?.networkService.searchRequest(searchText) { [weak self] (dict) in
                guard let data = dict["data"] as? [[String: Any]] else { return }
                for element in data {
                    self?.getSearchResultsInformation(from: element)
                }
            }
        }
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() +
            .milliseconds(250), execute: requestWorkItem)
    }
}
