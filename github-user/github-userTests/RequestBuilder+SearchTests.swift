//
// Copyright © 2024 Yurii Dukhovnyi. All rights reserved.
//
// This file is an original work developed by Yurii Dukhovnyi.
//

import XCTest

@testable import github_user

final class RequestBuilder_SearchTests: XCTestCase {

    func test_searchUserQuery() {
        let request = Api.SearchRequestBuilder.users(query: "immockedquery")
        let urlRequest = request.urlRequest(baseUrl: URL(string: "www.github.com")!)
        XCTAssertEqual(urlRequest.url?.absoluteString, "www.github.com/search/users?q=immockedquery")
    }

    func test_searchUserHttpMethod() {
        let request = Api.SearchRequestBuilder.users(query: "immockedquery")
        let urlRequest = request.urlRequest(baseUrl: URL(string: "www.github.com")!)
        XCTAssertEqual(urlRequest.httpMethod, "GET")
    }
}
