//
//  Comment.swift
//  ios-challenge
//
//  Created by Thales Pereira on 8/3/15.
//  Copyright (c) 2015 Thales Pereira. All rights reserved.
//

import UIKit

import SwiftyJSON

class Comment: NSObject {
    var id: String?
    var author: String?
    var created: NSDate?
    var message: String?
    var farm: String?
    var server: String?
    
    init(json: JSON) {
        super.init()
        
        self.id = json["author"].string
        self.author = json["authorname"].string
        self.created = self.timeIntervarSince1970ToNSDate(json["datecreate"].string!)
        self.message = json["_content"].string
        self.farm = String(json["iconfarm"].int!)
        self.server = json["iconserver"].string
    }
    
    func createdString() -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        return dateFormatter.stringFromDate(self.created!)
    }
    
    func buddyIconUrl() -> NSURL {
        var url = "http://farm\(farm!).staticflickr.com/\(server!)/buddyicons/\(id!).jpg"
        
        return NSURL(string: url)!
    }
    
    private func timeIntervarSince1970ToNSDate(string: String) -> NSDate {
        var stringDate: Double! = NSString(string: string).doubleValue
        
        return NSDate(timeIntervalSince1970: stringDate)
    }
}
