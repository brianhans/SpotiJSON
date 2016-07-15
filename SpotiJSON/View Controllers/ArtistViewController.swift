//
//  ArtistView.swift
//  SpotiJSON
//
//  Created by Brian Hans on 7/4/16.
//  Copyright © 2016 Brian Hans. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import AVFoundation

class ArtistViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    
    var artist: Artist?
    var songs: [Song]?
    var player: AVPlayer?
    
    override func viewDidLoad() {
        if let artist = artist{
            artistLabel.text = artist.name
            artistImageView.af_setImageWithURL(NSURL(string: artist.imageURL)!)
            artist.getSongs{(songs) in
                self.songs = songs
                self.tableView.reloadData()
            }
        }
    }
    
    
}

extension ArtistViewController: UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SongTableViewCell") as! SongTableViewCell
        cell.songLabel.text = songs![indexPath.row].name
        return cell
    }
    
}

extension ArtistViewController: UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        playSong(songs![indexPath.row].previewUrl)
        print(songs![indexPath.row].previewUrl)
    }
    
    func playSong(songUrl: String){
        let playerItem = AVPlayerItem(URL: NSURL(string: songUrl)!)
        player = AVPlayer(playerItem: playerItem)
        player!.volume = 1.0
        player!.play()
    }
}
