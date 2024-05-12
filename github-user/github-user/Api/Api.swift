//
// Copyright © 2024 Yurii Dukhovnyi. All rights reserved.
//
// This file is an original work developed by Yurii Dukhovnyi.
//

import Foundation

enum Api {
    
    /// Defines official GitHub endpoint URL.
    ///
    static let baseUrl = URL(string: "https://api.github.com")!

    /// Defines supported HTTP Methods
    ///
    enum HttpMethod: String {
        case get, post, put, delete
    }

    struct Response<T: Decodable>: Decodable {
        let totalCount: Int
        let incompleteResults: Bool
        let items: [T]
    }

    /// Defines generic API request.
    /// This request expects to know response type
    /// and decoding specific.
    ///
    struct Request<T> {
        /// Relative path.
        /// It expects to have relative path starting
        /// `/` symbol. During URL request this path
        /// will be added to base URL.
        let relativePath: String
        /// Array of URL queries
        let query: [URLQueryItem]
        /// Request HTTP method.
        let httpMethod: HttpMethod
        /// HTTP body, if exists.
        let httpBody: Data?
        /// HTTP headers.
        let httpHeaders: [String: String]
        /// Decoder for request response.
        let decoder: (Data, URLResponse) throws -> T

        init(
            relativePath: String,
            query: [URLQueryItem] = [],
            httpMethod: HttpMethod,
            httpBody: Data? = nil,
            httpHeaders: [String: String] = [:],
            jsonDecoder: JSONDecoder = .api
        ) where T: Decodable {

            self.relativePath = relativePath
            self.query = query
            self.httpMethod = httpMethod
            self.httpBody = httpBody
            self.httpHeaders = httpHeaders
            self.decoder = { data, _ in
                try jsonDecoder.decode(T.self, from: data)
            }
        }

        func urlRequest(baseUrl: URL) -> URLRequest {
            let absoluteUrl = baseUrl.appending(path: relativePath)
                .appending(queryItems: query)

            var request = URLRequest(url: absoluteUrl)
            request.httpMethod = httpMethod.rawValue
            request.httpBody = httpBody
            request.allHTTPHeaderFields = httpHeaders

            return request
        }
    }
}

extension JSONDecoder {

    static var api: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
