//
//  PlayerViewController.swift
//  SpoyMne
//
//  Created by Vsevolod Onishchenko on 05.01.2018.
//  Copyright © 2018 Vsevolod Onishchenko. All rights reserved.
//

import UIKit
import AVFoundation
import UIKit.UIGestureRecognizerSubclass

class PlayerViewController: BaseViewController {
    
    @IBOutlet private var successView: UIView!
    
    @IBOutlet private weak var songLogo: UIImageView!
    @IBOutlet private weak var songNameLabel: UILabel!
    @IBOutlet private weak var artistNameLabel: UILabel!
    @IBOutlet private weak var songDurationSlider: UISlider!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var pauseButton: UIButton!
    @IBOutlet private weak var addToFavoriteButton: UIButton!
    @IBOutlet private weak var openPlaylistButton: UIButton!
    @IBOutlet private weak var songDurationLabel: UILabel!
    @IBOutlet private weak var songTimerLabel: UILabel! {
        didSet {
            alreadyPlaying()
        }
    }
    var song: SongModel?
    private var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSongImage()
        configureSuccessView()

        guard let songToPlay = song else { return }

        do {
            audioPlayer = try AVAudioPlayer(data: songToPlay.songUrl.getDataFromUrl())
            songDurationLabel.text = convertSongDuration(for: audioPlayer.duration)
            songDurationSlider.maximumValue = Float(audioPlayer.duration)
            configureSongPresentation(songToPlay: songToPlay)
            audioPlayer.play()
        }
        catch {
            print(error)
        }
    }

    private func openPlaylist() {
        let s = storyboard?.instantiateViewController(withIdentifier: "FavoriteSongsCollection")
        guard let playlistView = s as? FavoriteSongsCollection else { return }
        playlistView.delegate = self
        navigationController?.pushViewController(playlistView, animated: true)
    }
    
    private func configureSongImage(){
        songLogo.contentMode = .scaleAspectFit
        songLogo.layer.shadowColor = UIColor.black.cgColor
        songLogo.layer.shadowOpacity = 1
        songLogo.layer.shadowOffset = CGSize.zero
        songLogo.layer.shadowRadius = 10
    }
    
    private func configureSongPresentation(songToPlay: SongModel) {
        songLogo.image = UIImage(data: songToPlay.songImage.getDataFromUrl())
        songNameLabel.text = songToPlay.songName
        artistNameLabel.text = songToPlay.artistName
    }
    
    @IBAction private func playButtonPressed(_ sender: Any) {
        audioPlayer.play()
    }
    
    @IBAction private func pauseButtonPressed(_ sender: Any) {
        audioPlayer.pause()
    }
    
    @IBAction private func addToFavoriteButtonPressed(_ sender: Any) {
        guard let favoriteSong = song else { return }
        let storage = CoreDataService()
        storage.saveSong(favoriteSong)
        animateIn()
    }

    @IBAction private func openPlaylistButtonPressed(_ sender: Any) {
        openPlaylist()
    }
    
    @IBAction private func closeSuccessViewButtonPressed(_ sender: Any) {
        animateOut()
    }
    
    private func configureSuccessView() {
        successView.layer.cornerRadius = 10
    }
    
    private func animateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.successView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.successView.alpha = 0
        }) { (success) in
            self.successView.removeFromSuperview()
        }
    }
    
    private func animateIn() {
        self.view.addSubview(successView)
        successView.center = self.view.center
        successView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        successView.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.successView.alpha = 1
            self.successView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    private func convertSongDuration(for duration: Double) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        
        guard let convertedDuration = formatter.string(from: duration) else { return "0:00" }
        return convertedDuration
    }
    
    private func alreadyPlaying() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] (timer) in
            guard let playing = self?.audioPlayer.currentTime,
                let currentTime = self?.audioPlayer.currentTime else { return }
            self?.songTimerLabel.text = self?.convertSongDuration(for:Double(playing))
            self?.songDurationSlider.value = Float(currentTime)
        }
    }
    
    @IBAction private func changeAudioTime(_ sender: Any) {
        audioPlayer.pause()
        audioPlayer.currentTime = TimeInterval(songDurationSlider.value)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
}

extension String {
    func getDataFromUrl() -> Data {
        guard let url = URL.init(string: self),
            let data = NSData(contentsOf: url) else { return Data() }
        return data as Data
    }
}

extension PlayerViewController: ChangePlayingSongProtocol {
    func changePlayingSong(song: SongModel) {
        audioPlayer.stop()
        do {
            audioPlayer = try AVAudioPlayer(data: song.songUrl.getDataFromUrl())
            songDurationLabel.text = convertSongDuration(for: audioPlayer.duration)
            songDurationSlider.maximumValue = Float(audioPlayer.duration)
            configureSongPresentation(songToPlay: song)
            audioPlayer.play()
        }
        catch {
            print(error)
        }
    }
}










