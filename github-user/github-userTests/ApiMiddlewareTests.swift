//
// Copyright © 2024 Yurii Dukhovnyi. All rights reserved.
//
// This file is an original work developed by Yurii Dukhovnyi.
//

import XCTest

@testable import github_user

final class ApiMiddlewareTests: XCTestCase {

    let mock = (
        config: Configuration(personalAccessToken: "i'm mocked token"),
        ()
    )

    var middleware: Api.Middleware?

    override func setUp() {
        super.setUp()
        middleware = .live(configuration: mock.config)
    }

    func test_githubApiVersion() {
        let request = URLRequest(url: .init(string: "www.github.com")!)
        let result = middleware?.prepare(request)

        XCTAssertEqual(result?.allHTTPHeaderFields?["X-GitHub-Api-Version"], "2022-11-28")
    }

    func test_addingAccessToken() {
        let request = URLRequest(url: .init(string: "www.github.com")!)
        let result = middleware?.prepare(request)

        XCTAssertEqual(result?.allHTTPHeaderFields?["Authorization"], "Bearer i'm mocked token")
    }
}
