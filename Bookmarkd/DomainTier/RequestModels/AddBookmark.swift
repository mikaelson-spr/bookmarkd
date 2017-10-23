//
//  AddBookmark.swift
//  Bookmarkd
//
//  Created by Mikael Son on 10/5/17.
//  Copyright © 2017 SPR. All rights reserved.
//

import Foundation

import SwiftyJSON_3_1_1

public struct AddBookmark {
    public let title: String
    public let description: String
    public let url: String
    public let tags: String
    
    init(with jsonObj: JSONObject) {
        let json = JSON(jsonObj)
        self.title = json["Title"].string ?? ""
        self.description = json["Description"].string ?? ""
        self.url = json["URL"].string ?? ""
        self.tags = json["Tags"].string ?? ""
    }
}
