//
//  SignInCommand.swift
//  Bookmarkd
//
//  Created by Mikael Son on 9/28/17.
//  Copyright © 2017 SPR. All rights reserved.
//

import Foundation
import SPRingboard

public class SignInCommand {
    
    public func execute(with credentials: Credentials) -> FutureResult<AuthenticationVVO> {
        let deferred = DeferredResult<AuthenticationVVO>()

        let client = BookmarkdClient.shared
        client.getAuthenticationToken(with: credentials).then { result in
            switch result {
            case .success(let dm):
                let model = AuthenticationVVO(token: dm.token)
                deferred.fill(value: model)
            case .failure:
                break
            }
        }
        return deferred
    }
}

