//
//  AddBookmarkCommand.swift
//  Bookmarkd
//
//  Created by Mikael Son on 10/5/17.
//  Copyright © 2017 SPR. All rights reserved.
//

import Foundation
import SPRingboard

public class AddBookmarkCommand {
    
    public func execute(with authentication: Authentication, request: AddBookmark) -> FutureResult<Bool> {
        let deferred = DeferredResult<Bool>()
        
        let client = BookmarkdClient.shared
        client.addBookmark(with: authentication, and: request).then { result in
            switch result {
            case .success:
                deferred.fill(value: true)
            case .failure:
                break
            }
        }
        
        return deferred
    }
}
