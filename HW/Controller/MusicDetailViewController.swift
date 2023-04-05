//
//  MusicDetailViewController.swift
//  HW
//
//  Created by Leo Lui on 2023/3/21.
//

import UIKit
import SafariServices
import Kingfisher
import AVFoundation
import AVKit


class MusicDetailViewController: UIViewController,SFSafariViewControllerDelegate,TrackManagerDelegate{
    var trackID: Int = 0
    var artistName: String?
    var albumName: String?
    var songName: String?
    var artworkURL: String?
    var artistURL: String?
    var albumURL: String?
    var trackManager = TrackManager()
    var previewURL: String?
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var artworkImage: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var albumLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackManager.delegate = self
        trackManager.getTrackInfo(trackId: String(trackID))
        
    }
    
    func outputTrackInfo(track: Track) {
        DispatchQueue.main.async {
            self.artistLabel.text = "歌手：\(track.artistName)"
            self.albumLabel.text = "專輯：\(track.collectionName)"
            self.trackLabel.text = "曲名：\(track.trackName)"
            self.artworkURL = track.artworkUrl100
            self.artworkImage.kf.setImage(with: URL(string: self.artworkURL!))
            self.backgroundImage.kf.setImage(with: URL(string: self.artworkURL!))
            blurImage(inputImage: self.backgroundImage)
            self.artistURL = track.artistViewUrl
            self.albumURL = track.collectionViewUrl
            self.previewURL = track.previewUrl
            self.releaseDateLabel.text = "發行日期：\(decodeTime(timeString: track.releaseDate))"
        }
        
    }
    
    
    @IBAction func artistReview(_ sender: Any) {
        if let url = URL(string: self.artistURL!){
        let safari = SFSafariViewController(url: url)
        safari.delegate = self
        present(safari, animated: true, completion: nil)
                         }
    }
    
    
    @IBAction func albumView(_ sender: Any) {
        if let url = URL(string: self.albumURL!){
        let safari = SFSafariViewController(url: url)
        safari.delegate = self
        present(safari, animated: true, completion: nil)
                         }
    }
    
    
    @IBAction func playMusic(_ sender: Any) {
        let playerViewController = AVPlayerViewController()
        let url = URL(string: previewURL! )
        let player = AVPlayer(url: url!)
        playerViewController.player = player
        present(playerViewController, animated: true) {
            player.play()
        }
        
        
        
    }
    
    
    
    
    
    
    
}
