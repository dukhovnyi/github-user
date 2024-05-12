//
// Copyright © 2024 Yurii Dukhovnyi. All rights reserved.
//
// This file is an original work developed by Yurii Dukhovnyi.
//

import Foundation
import Combine

struct Authenticator {

    let state: AnyPublisher<GitHubUserApp.AppState, Never>
    let authenticate: (_ personalAccessToken: String) -> AnyPublisher<Configuration, Error>
    let deauthenticate: () -> AnyPublisher<Void, Error>
}


extension Authenticator {

    static let live: Self = {

        let subj = CurrentValueSubject<GitHubUserApp.AppState, Never>(.nonAuthenticated)

        return .init(
            state: subj.eraseToAnyPublisher(),
            authenticate: { token in
                Just<Configuration>(Configuration(personalAccessToken: token))
                    .handleEvents(
                        receiveOutput: { conf in
                            subj.send(.authenticated(conf))
                        }
                    )
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            },
            deauthenticate: {
                Just<Void>(Void())
                    .handleEvents(
                        receiveOutput: {
                            subj.send(.nonAuthenticated)
                        }
                    )
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        )
    }()
}

#if DEBUG

extension Authenticator {

    static func mock(
        state: CurrentValueSubject<GitHubUserApp.AppState, Never> = .init(.nonAuthenticated),
        authenticate: @escaping (String) -> AnyPublisher<Configuration, Error> = { _ in
            Just<Configuration>(.init(personalAccessToken: "mock-access-token"))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        },
        deauthenticate: @escaping () -> AnyPublisher<Void, Error> = {
            Just<Void>(Void())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    ) -> Self {

        .init(
            state: state.eraseToAnyPublisher(),
            authenticate: authenticate,
            deauthenticate: deauthenticate
        )
    }
}

#endif
