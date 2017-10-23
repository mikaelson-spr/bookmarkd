//
//  BookmarkVVO.swift
//  Bookmarkd
//
//  Created by Mikael Son on 10/3/17.
//  Copyright © 2017 SPR. All rights reserved.
//

import Foundation

import SwiftyJSON_3_1_1


public struct BookmarkVVO {
    public let title: String
    public let description: String
    public let tags: String
    public let url: String
    public let lastModified: String
    
    init(model: BookmarkDVO) {
        self.title = model.title
        self.description = model.description
        self.tags = model.tags
        self.url = model.url
        self.lastModified = model.lastModified
    }
    
    init(from jsonObj: JSONObject) {
        let json = JSON(jsonObj)
        self.title = json["Title"].string ?? ""
        self.description = json["Description"].string ?? ""
        self.tags = json["Tags"].string ?? ""
        self.url = json["URL"].string ?? ""
        self.lastModified = json["LastModified"].string ?? ""
    }
}
