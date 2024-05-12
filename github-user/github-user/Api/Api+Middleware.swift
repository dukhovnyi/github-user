//
// Copyright © 2024 Yurii Dukhovnyi. All rights reserved.
//
// This file is an original work developed by Yurii Dukhovnyi.
//

import Foundation
extension Api {

    struct Middleware {
        let prepare: (URLRequest) -> URLRequest
    }
}


extension Api.Middleware {

    static func live(configuration: Configuration) -> Self {

        .init { request in
            var newRequest = request
            if newRequest.allHTTPHeaderFields == nil {
                newRequest.allHTTPHeaderFields = [:]
            }
            newRequest.allHTTPHeaderFields?["X-GitHub-Api-Version"] = "2022-11-28"
            newRequest.allHTTPHeaderFields?["Authorization"] = "Bearer \(configuration.personalAccessToken)"

            return newRequest
        }
    }

    #if DEBUG
    static func mock() -> Self {
        .init { $0 }
    }
    #endif
}
