//
//  Playlist.swift
//  SpotiJSON
//
//  Created by Brian Hans on 7/4/16.
//  Copyright © 2016 Brian Hans. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Artist{
    var name: String
    var songs: [Song]
    var id: String
    var imageURL: String
    
    init(json: JSON){
        self.name = json["name"].stringValue
        self.songs = [Song]()
        self.imageURL = json["images"][0]["url"].stringValue
        self.id = json["id"].stringValue
    }
    
    func getSongs(completionBlock: ([Song]) -> Void){
        let url = "https://api.spotify.com/v1/artists/\(id)/top-tracks"
        let parameters = ["country" : "US"]
        SpotifyAPIManager.sharedInstance.almofireManager().request(.GET, url, parameters: parameters).responseJSON{(response) in
            switch response.result{
                case .Success:
                    self.songs = []
                    if let value = response.result.value{
                        let json = JSON(value)
                        let tracks = json["tracks"].arrayValue
                        
                        for track in tracks{
                            let song = Song(json: track)
                            self.songs.append(song)
                        }
                        completionBlock(self.songs)
                    }
                case .Failure:
                    print("failed")
            }
        }
    }
}