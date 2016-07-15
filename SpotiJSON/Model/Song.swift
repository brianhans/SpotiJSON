//
//  Song.swift
//  SpotiJSON
//
//  Created by Brian Hans on 7/4/16.
//  Copyright © 2016 Brian Hans. All rights reserved.
//

import Foundation
import SwiftyJSON

class Song{
    
    var previewUrl: String
    var name: String
    var artist: String
    
    
    init(json: JSON){
        self.previewUrl = json["preview_url"].stringValue
        self.name = json["name"].stringValue
        self.artist = json["artists"][0]["name"].stringValue
    }
    
    
}