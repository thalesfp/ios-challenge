//
//  Photo.swift
//  ios-challenge
//
//  Created by Thales Pereira on 8/2/15.
//  Copyright (c) 2015 Thales Pereira. All rights reserved.
//

import UIKit

import SwiftyJSON

class Photo: NSObject {
    var farm: Int?
    var id: String?
    var isFamily: Int?
    var isFriend: Int?
    var isPublic: Int?
    var owner: String?
    var secret: String?
    var server: String?
    var title: String?
    var desc: String?
    var posted: NSDate?
    var comments: Int?
    var author: String?
    var views: Int?
    
    init(json: JSON) {
        super.init()
        
        farm = json["farm"].int
        id = json["id"].string
        isFamily = json["isfamily"].int
        isFriend = json["isfriend"].int
        isPublic = json["ispublic"].int
        owner = json["owner"].string
        secret = json["secret"].string
        server = json["server"].string
        title = json["title"].string
    }
    
    func completeInfo(json: JSON) {
        desc = json["description"]["_content"].string
        comments = json["comments"]["_content"].string?.toInt()
        author = json["owner"]["username"].string
        posted = self.timeIntervarSince1970ToNSDate(json["dates"]["posted"].string!)
        views = json["views"].string?.toInt()
    }
    
    private func timeIntervarSince1970ToNSDate(string: String) -> NSDate {
        var stringDate: Double! = NSString(string: string).doubleValue
        
        return NSDate(timeIntervalSince1970: stringDate)
    }
    
    func postedString() -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        return dateFormatter.stringFromDate(self.posted!)
    }
    
    func photoUrl() -> NSURL {
        var url = "https://farm\(farm!).staticflickr.com/\(server!)/\(id!)_\(secret!).jpg"
        
        return NSURL(string: url)!
    }
}
