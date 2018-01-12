//
//  PlayerViewController.swift
//  SpoyMne
//
//  Created by Vsevolod Onishchenko on 05.01.2018.
//  Copyright © 2018 Vsevolod Onishchenko. All rights reserved.
//

import UIKit
import AVFoundation
/**
 Класс отвечает за экран отображения плеера
*/
final class PlayerViewController: BaseViewController {
    
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
        configurePlayer(with: songToPlay)
    }
    /**
     Конфигурация и запуск плеера
    */
    private func configurePlayer(with songToPlay: SongModel) {
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
    /**
     Функция, осуществляющая переход на страницу с плэйлистом пользователя
    */
    private func openPlaylist() {
        let s = storyboard?.instantiateViewController(withIdentifier: "FavoriteSongsCollection")
        guard let playlistView = s as? FavoriteSongsCollection else { return }
        playlistView.delegate = self
        navigationController?.pushViewController(playlistView, animated: true)
    }
    //MARK: Configurations methods
    /**
     Конфигурация обложки песни
    */
    private func configureSongImage(){
        songLogo.contentMode = .scaleAspectFit
        songLogo.layer.shadowColor = UIColor.black.cgColor
        songLogo.layer.shadowOpacity = 1
        songLogo.layer.shadowOffset = CGSize.zero
        songLogo.layer.shadowRadius = 10
    }
    /**
     Конфигурация представления песни
     */
    private func configureSongPresentation(songToPlay: SongModel) {
        songLogo.image = UIImage(data: songToPlay.songImage.getDataFromUrl())
        songNameLabel.text = songToPlay.songName
        artistNameLabel.text = songToPlay.artistName
    }
    /**
     Конфигурация вью, которое уведомляет пользователя
     об успешном занесении песни в плэйлист
     */
    private func configureSuccessView() {
        successView.layer.cornerRadius = 10
    }
    /**
     Конфигурация представления продолжительности песни
     */
    private func convertSongDuration(for duration: Double) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]

        guard let convertedDuration = formatter.string(from: duration) else { return "0:00" }
        return convertedDuration
    }
    /**
     Конфигурация проигрываемого времени и изменения слайдера
     */
    private func alreadyPlaying() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] (timer) in
            guard let playing = self?.audioPlayer.currentTime,
                let currentTime = self?.audioPlayer.currentTime else { return }
            self?.songTimerLabel.text = self?.convertSongDuration(for:Double(playing))
            self?.songDurationSlider.value = Float(currentTime)
        }
    }

    // MARK: IBActions
    @IBAction private func playButtonPressed(_ sender: Any) {
        audioPlayer.play()
    }
    
    @IBAction private func pauseButtonPressed(_ sender: Any) {
        audioPlayer.pause()
    }
    /**
     Сохрание песни в хранилище
    */
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
    /**
     Функция, осуществляющая изменения проигрываемого времени
     с помощью слайдера
    */
    @IBAction private func changeAudioTime(_ sender: Any) {
        audioPlayer.pause()
        audioPlayer.currentTime = TimeInterval(songDurationSlider.value)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }

    //MARK: Animation
    /*
    Данный блок настраивает анимацию появления и исчезновения
    вью успешного добавления трека в хранилище
    */
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
}

extension PlayerViewController: ChangePlayingSongProtocol {
    func changePlayingSong(song: SongModel) {
        audioPlayer.stop()
        configurePlayer(with: song)
    }
}










