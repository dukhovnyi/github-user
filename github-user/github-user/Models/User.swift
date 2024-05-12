//
// Copyright © 2024 Yurii Dukhovnyi. All rights reserved.
//
// This file is an original work developed by Yurii Dukhovnyi.
//

import Foundation

struct User: Identifiable, Decodable {
    let id: Int
    let login: String
    let avatarUrl: String
    let url: URL
}

#if DEBUG

extension User {
    static let yurii: Self = .init(
        id: 100500,
        login: "dukhovnyi",
        avatarUrl: "https://avatars.githubusercontent.com/u/28916962?v=4",
        url: .init(string: "https://api.github.com/users/dukhovnyi")!
    )
}

#endif
