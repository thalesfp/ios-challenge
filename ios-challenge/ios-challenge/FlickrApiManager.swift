//
//  RestApiManager.swift
//  ios-challenge
//
//  Created by Thales Pereira on 8/2/15.
//  Copyright (c) 2015 Thales Pereira. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FlickrApiManager: NSObject {
   static let sharedInstance = FlickrApiManager()
    
    let baseURL = "https://api.flickr.com/services/rest"
    let apiKey = "143bf911a30fd8bff698c176df62a58d"
    
    // MARK: - flickr.photos.getRecent
    
    /**
        Returns a list of the latest public photos uploaded to flickr.
    
        Reference: https://www.flickr.com/services/api/flickr.photos.getRecent.html
    
        :param: perPage Number of photos to return per page.
        :param: page The page of results to return.
        :param: onCompletion A callback invoked when the request is complete.
    */
    
    func photosGetRecent(perPage: Int, page: Int, onCompletion: ([Photo], NSError?) -> Void) {
        let method = "flickr.photos.getRecent"
        let params = ["per_page": perPage, "page": page]
        
        var photos = [Photo]()
        
        makeHTTPGetRequest(method, params: params) { json, error in
            for (index: String, value: JSON) in json["photos"]["photo"] {
                photos.append(Photo(json: value))
            }
            
            onCompletion(photos, error)
        }
    }
    
    // MARK: - flickr.photos.getInfo
    
    /**
        Get information about a photo.
    
        Reference: https://www.flickr.com/services/api/flickr.photos.getInfo.html
    
        :param: photoId The id of the photo to get information for.
        :param: onCompletion A callback invoked when the request is complete.
    */
    
    func photosGetInfo(photo: Photo, onCompletion: (Photo, NSError?) -> Void) {
        let method = "flickr.photos.getInfo"
        var photoId: String = photo.id!
        let params = ["photo_id": photoId, "extras": "views"]
        
        makeHTTPGetRequest(method, params: params) { (json, error) -> Void in
            photo.completeInfo(json["photo"])
            onCompletion(photo, error)
        }
    }
    
    // MARK: - flickr.photos.comments.getList
    
    /**
        Get all comments of a photo
    
        Reference: https://www.flickr.com/services/api/flickr.photos.comments.getList.html
    
        :param: photoId The id of the photo to get information for.
        :param: onCompletion A callback invoked when the request is complete.
    */
    
    func commentsGetList(photoId: String, onCompletion: ([Comment], NSError?) -> Void) {
        let method = "flickr.photos.comments.getList"
        let params = ["photo_id": photoId]
        
        var comments = [Comment]()
        
        makeHTTPGetRequest(method, params: params) { (json, error) -> Void in
            for (index: String, value: JSON) in json["comments"]["comment"] {
                comments.append(Comment(json: value))
            }
            
            onCompletion(comments, error)
        }
    }
    
    // MARK: - HTTP Requests
    
    private func makeHTTPGetRequest(method: String, params: [String: AnyObject], onCompletion: (JSON, NSError?) -> Void) {
        var defaultParams: [String: AnyObject] = ["method": method, "api_key": apiKey, "format": "json", "nojsoncallback": 1]

        for (key, value) in params {
            defaultParams[key] = value
        }
        
        Alamofire.request(.GET, baseURL,
            parameters: defaultParams)
            .responseJSON { request, response, data, error in
                if error != nil {
                    onCompletion(nil, error)
                } else {
                    let json:JSON = JSON(data!)
                    onCompletion(json, error)
                }
            }
    }
}
