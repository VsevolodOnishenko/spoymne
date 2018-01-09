//
//  PlayerViewController.swift
//  SpoyMne
//
//  Created by Vsevolod Onishchenko on 05.01.2018.
//  Copyright © 2018 Vsevolod Onishchenko. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerViewController: BaseViewController {
    
    @IBOutlet private weak var songLogo: UIImageView!
    @IBOutlet private weak var songNameLabel: UILabel!
    @IBOutlet private weak var artistNameLabel: UILabel!
    @IBOutlet private weak var songDurationSlider: UISlider!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var pauseButton: UIButton!
    @IBOutlet private weak var addToFavoriteButton: UIButton!
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
    
    @IBAction func playButtonPressed(_ sender: Any) {
        audioPlayer.play()
    }
    
    @IBAction func pauseButtonPressed(_ sender: Any) {
        audioPlayer.pause()
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
    
    @IBAction func changeAudioTime(_ sender: Any) {
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











