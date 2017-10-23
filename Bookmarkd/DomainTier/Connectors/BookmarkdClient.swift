//
//  BookmarkdClient.swift
//  Bookmarkd
//
//  Created by Mikael Son on 9/29/17.
//  Copyright © 2017 SPR. All rights reserved.
//

import Foundation

import Alamofire
import SPRingboard

public class BookmarkdClient {
  
    public static let shared = BookmarkdClient()
    private let alamofire: SessionManager
    
    init() {
        self.alamofire = SessionManager(configuration: URLSessionConfiguration.ephemeral)
    }
    
    public func addBookmark(with authentication: Authentication, and request: AddBookmark) -> FutureResult<Bool> {
        let deferred = DeferredResult<Bool>()
        
        let parameter: JSONObject = [
            "url": request.url,
            "description": request.title,
            "extended": request.description,
            "tags": request.tags,
            "format": "json",
            "auth_token": "\(authentication.username):\(authentication.token)"
        ]
        
        self.alamofire.request(
            "https://api.pinboard.in/v1/posts/add",
            method: .get,
            parameters: parameter,
            encoding: URLEncoding.default
            ).validate().responseJSON { response in
                print("response: \(response)")
                switch response.result {
                case .success(let value):
                    print("success: \(value)")
                    deferred.fill(value: true)
                case .failure(let error):
                    print("Error occurred: \(error)")
                }
        }
        
        return deferred
    }
    
    public func fetchBookmarks(with authentication: Authentication) -> FutureResult<[BookmarkDVO]> {
        let deferred = DeferredResult<[BookmarkDVO]>()
        
        self.alamofire.request(
            "https://api.pinboard.in/v1/posts/all",
            parameters: ["format": "json", "auth_token": "\(authentication.username):\(authentication.token)"]
            ).validate().responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    if let jsonArray = value as? JSONArray {
                        var modelArray = [BookmarkDVO]()
                        for json in jsonArray {
                            print("\n\(json)\n")
                            guard
                                let title = json["description"] as? String,
                                let tags = json["tags"] as? String,
                                let url = json["href"] as? String,
                                let lastModified = json["time"] as? String,
                                let extended = json["extended"] as? String
                            else {
                                continue
                            }
                            let model = BookmarkDVO(title: title, description: extended, tags: tags, url: url, lastModified: lastModified)
                            modelArray.append(model)
                        }
                        deferred.fill(value: modelArray)
                    }
                case .failure(let error):
                    print("Error occurred: \(error)")
                }
        }
        
        return deferred
    }
    
    public func getAuthenticationToken(with credentials: Credentials) -> FutureResult<AuthenticationDVO> {
        let deferred = DeferredResult<AuthenticationDVO>()

        let username = "testymctestface"
        let password = "kale.persist.testbed.PF7"
        
        let authString = "\(username):\(password)"
        let authBase64 = self.encodeToBase64(string: authString)
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(authBase64)"
        ]
        
        self.alamofire.request(
            "https://api.pinboard.in/v1/user/api_token",
            parameters: ["format":"json"],
            headers: headers
            ).validate().responseJSON { response in
                if let json = response.value as? JSONObject {
                    guard let token = json["result"] as? String else { return }
                    let model = AuthenticationDVO(token: token)
                    deferred.fill(value: model)
                } else {
                    // handle error
//                    deferred.fill(value: true)
                }
                
        }
        
        return deferred
    }
    
    public func updateBookmark(with authentication: Authentication, and request: AddBookmark) -> FutureResult<UpdateBookmarkDVO> {
        let deferred = DeferredResult<UpdateBookmarkDVO>()
        
        let parameter: JSONObject = [
            "url": request.url,
            "description": request.title,
            "extended": request.description,
            "tags": request.tags,
            "format": "json",
            "auth_token": "\(authentication.username):\(authentication.token)"
        ]
        
        self.alamofire.request(
            "https://api.pinboard.in/v1/posts/update",
            method: .get,
            parameters: parameter,
            encoding: URLEncoding.default
            ).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("success: \(value)")
                    guard
                        let json = value as? JSONObject,
                        let time = json["update_time"] as? String
                    else {
                        return
                    }
                    let dm = UpdateBookmarkDVO(updateTime: time)
                    deferred.fill(value:dm)
                case .failure(let error):
                    print("Error occurred: \(error)")
                }
        }
        
        return deferred
    }
    
    // MARK: - Helper Functions
    
    private func encodeToBase64(string: String) -> String {
        let authStringUTF8 = string.data(using: .utf8)
        var authBase64: String = ""
        if let base64Encoded = authStringUTF8?.base64EncodedString() {
            authBase64 = base64Encoded
        }
        return authBase64
    }
}
