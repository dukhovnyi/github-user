//
// Copyright © 2024 Yurii Dukhovnyi. All rights reserved.
//
// This file is an original work developed by Yurii Dukhovnyi.
//

import Foundation

extension Api {

    /// Search requests builder
    ///
    enum SearchRequestBuilder {
        /// Search users endpoint.
        /// [GitHub doc](https://docs.github.com/en/rest/search/search?apiVersion=2022-11-28#search-users)
        static func users(query: String) -> Request<Response<User>> {

            .init(
                relativePath: "/search/users",
                query: [.init(name: "q", value: query)],
                httpMethod: .get,
                httpBody: nil
            )
        }
    }
}
