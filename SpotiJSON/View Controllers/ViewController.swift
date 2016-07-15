//
//  ViewController.swift
//  SpotiJSON
//
//  Created by Brian Hans on 7/4/16.
//  Copyright © 2016 Brian Hans. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var artists: [Artist] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if(!defaults.boolForKey("loadingOAuthToken")){
            getKey();
        }
    }
    
    func getKey(){
        if(!SpotifyAPIManager.sharedInstance.hasOAuthToken()){
            SpotifyAPIManager.sharedInstance.OAuthCompletionHandler = { (error) -> Void in
                if let error = error{
                    print(error)
                }
            }
            SpotifyAPIManager.sharedInstance.startOAuthLogin()
        }
    }
    
    func search(searchTerm: String){
        if(!SpotifyAPIManager.sharedInstance.hasOAuthToken()){
            SpotifyAPIManager.sharedInstance.OAuthCompletionHandler = { (error) -> Void in
                if let error = error{
                    print(error)
                }
            }
            SpotifyAPIManager.sharedInstance.startOAuthLogin()
        }else{
            let url = "https://api.spotify.com/v1/search"
            let parameters = ["q":searchTerm, "type": "artist", "market": "US"]
            SpotifyAPIManager.sharedInstance.almofireManager().request(.GET, url, parameters: parameters).responseJSON{ (response) in
                switch response.result{
                case .Success:
                    self.artists = []
                    if let value = response.result.value{
                        let json = JSON(value)
                        let artistsJson = json["artists"]["items"].arrayValue
                        for artist in artistsJson{
                            self.artists.append(Artist(json: artist))
                        }
                        self.tableView.reloadData()
                    }
                case .Failure:
                    print("failed")
                }
            
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier{
            if(identifier == "showArtist"){
                let indexPath = tableView.indexPathForSelectedRow
                let artist = artists[indexPath!.row]
                let artistViewController = segue.destinationViewController as! ArtistViewController
                artistViewController.artist = artist
            }
        }
    }

}

extension ViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserTableViewCell") as! UserTableViewCell
        
        cell.nameLabel.text = artists[indexPath.row].name
        
        return cell;
    }
}

extension ViewController: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(searchBar: UISearchBar){
        search(searchBar.text!)
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        search(searchBar.text!)
    }
} 

