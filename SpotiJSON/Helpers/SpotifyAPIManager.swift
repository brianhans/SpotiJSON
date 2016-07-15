//
//  SpotifyAPIManager.swift
//  SpotiJSON
//
//  Created by Brian Hans on 7/4/16.
//  Copyright © 2016 Brian Hans. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SpotifyAPIManager{
    
    static let sharedInstance = SpotifyAPIManager()
    
    let clientId = "6d3d63e867ba4181aa02dd56481c7554"
    let clientSecret = "2ab8127996ed4fd0a34e52478db31aba"
    
    var OAuthToken: String?
    
    var OAuthCompletionHandler:(NSError? -> Void)?
    
    
    init(){
        if (hasOAuthToken()){
             addSessionHeader("Authorization", value: "token \(OAuthToken)")
        }
    }
    
    func hasOAuthToken() -> Bool{
        if let token = self.OAuthToken{
            return !token.isEmpty
        }
        
        return false
    }
    
    func startOAuthLogin(){
        let authPath = "https://accounts.spotify.com/authorize?client_id=\(clientId)&response_type=code&redirect_uri=spotiJson%3A%2F%2F"
        
        if let authURL = NSURL(string: authPath){
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(true, forKey: "loadingOAuthToken")
            
            UIApplication.sharedApplication().openURL(authURL)
        }
    }
    
    func processOAuthStep1Response(url: NSURL){
        let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: false)
        
        var code: String?
        
        
        //Finds code parameter
        if let queryItems = components?.queryItems{
            for item in queryItems{
                if (item.name.lowercaseString == "code"){
                    code = item.value
                    break
                }
            }
        }
        
        if let code = code{
            let url = "https://accounts.spotify.com/api/token"
            let parameters = ["grant_type": "authorization_code", "code": code, "redirect_uri": "spotiJson://", "client_id": clientId, "client_secret": clientSecret, ]
            
            Alamofire.request(.POST, url, parameters: parameters).responseJSON{(response) in
                if(response.result.isSuccess){
                    var json = JSON(response.result.value!)
                    self.OAuthToken = json["access_token"].stringValue
                }
                if self.hasOAuthToken(){
                    if let completionHandler = self.OAuthCompletionHandler{
                        completionHandler(nil)
                    }
                }else{
                    if let completionHandler = self.OAuthCompletionHandler{
                        let noOAuthError = NSError(domain: "com.alamofire.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not obtain key"])
                        completionHandler(noOAuthError)
                    }
                }
            }
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(false, forKey: "loadingOAuthToken")
    }
    
    func almofireManager() -> Manager{
        let manager = Alamofire.Manager.sharedInstance
        return manager
    }
    
    func addSessionHeader(key: String, value: String){
        let manager = Alamofire.Manager.sharedInstance
        if var sessionHeaders = manager.session.configuration.HTTPAdditionalHeaders as? Dictionary<String, String>{
            sessionHeaders[key] = value
            manager.session.configuration.HTTPAdditionalHeaders = sessionHeaders
        }else{
            manager.session.configuration.HTTPAdditionalHeaders = [key: value]
        }
        
    }
    
    func removeSessionHeaderIfExists(key: String){
        let manager = Alamofire.Manager.sharedInstance
        if var sessionheadHeaders = manager.session.configuration.HTTPAdditionalHeaders as? Dictionary<String, String>{
            sessionheadHeaders.removeValueForKey(key)
            manager.session.configuration.HTTPAdditionalHeaders = sessionheadHeaders
        }
    }
}
