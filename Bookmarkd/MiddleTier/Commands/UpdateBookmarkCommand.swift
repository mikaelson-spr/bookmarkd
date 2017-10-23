//
//  UpdateBookmarkCommand.swift
//  Bookmarkd
//
//  Created by Mikael Son on 10/6/17.
//  Copyright © 2017 SPR. All rights reserved.
//

import Foundation
import SPRingboard

public class UpdateBookmarkCommand {
    
    public func execute(with authentication: Authentication, request: AddBookmark) -> FutureResult<UpdateBookmarkVVO> {
        let deferred = DeferredResult<UpdateBookmarkVVO>()
        
        let client = BookmarkdClient.shared
        client.updateBookmark(with: authentication, and: request).then { result in
            switch result {
            case .success(let dm):
                let model = UpdateBookmarkVVO(updateTime: dm.updateTime)
                deferred.fill(value: model)
            case .failure:
                break
            }
        }
        
        return deferred
    }
}
