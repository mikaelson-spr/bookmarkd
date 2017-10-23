//
//  FetchBookmarksCommand.swift
//  Bookmarkd
//
//  Created by Mikael Son on 10/2/17.
//  Copyright © 2017 SPR. All rights reserved.
//

import Foundation
import SPRingboard

public class FetchBookmarksCommand {
    
    public func execute(with authentication: Authentication) -> FutureResult<[BookmarkVVO]> {
        let deferred = DeferredResult<[BookmarkVVO]>()
        
        let client = BookmarkdClient.shared
        client.fetchBookmarks(with: authentication).then { result in
            switch result {
            case .success(let array):
                let models = array.map({ (dm) -> BookmarkVVO in
                    let model = BookmarkVVO(model: dm)
                    return model
                })
                deferred.fill(value: models)
            case .failure:
                break
            }
        }
        
        return deferred
    }
}
