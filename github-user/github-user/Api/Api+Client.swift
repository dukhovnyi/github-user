//
// Copyright © 2024 Yurii Dukhovnyi. All rights reserved.
//
// This file is an original work developed by Yurii Dukhovnyi.
//

import Combine
import Foundation

protocol ApiClientProtocol {

    func send<T>(
        request: Api.Request<T>
    ) -> AnyPublisher<T, Error>

    func send<T>(
        request: Api.Request<T>,
        httpStatusCodes: Range<Int>
    ) -> AnyPublisher<T, Error>
}

extension Api {

    struct Client: ApiClientProtocol {

        init(
            session: URLSession,
            baseUrl: URL,
            middleware: Middleware
        ) {
            self.baseUrl = baseUrl
            self.middleware = middleware
            self.session = session
        }

        func send<T>(
            request: Request<T>
        ) -> AnyPublisher<T, Error> {
            send(
                request: request,
                httpStatusCodes: 200 ..< 300
            )
        }

        func send<T>(
            request: Request<T>,
            httpStatusCodes: Range<Int>
        ) -> AnyPublisher<T, Error> {
            
            var urlRequest = request.urlRequest(baseUrl: baseUrl)
            urlRequest.timeoutInterval = 3
            urlRequest = middleware.prepare(urlRequest)
            
            return session.dataTaskPublisher(for: urlRequest)
                .mapError { urlError in
                    switch urlError.code {
                    case URLError.notConnectedToInternet:
                        return ApiError.notConnectedToInternet
                    default:
                        return ApiError.urlResponseError(urlError)
                    }
                }
                .tryMap { data, response in

                    guard let httpResponse = response as? HTTPURLResponse else {
                        throw ApiError.unexpectedUrlResponse(response)
                    }
                    guard httpStatusCodes ~= httpResponse.statusCode else {
                        throw ApiError.unexpectedStatusCode(httpResponse.statusCode)
                    }

                    return try request.decoder(data, httpResponse)
                }
                .eraseToAnyPublisher()
        }

        // MARK: - Private

        private let baseUrl: URL
        private let middleware: Middleware
        private let session: URLSession
    }
}

extension Api {
    enum ApiError: Equatable, Error {
        case unexpectedUrlResponse(URLResponse)
        case unexpectedStatusCode(Int)
        case notConnectedToInternet
        case urlResponseError(URLError)
    }
}
