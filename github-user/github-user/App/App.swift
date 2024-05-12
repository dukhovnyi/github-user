//
//  github_userApp.swift
//  github-user
//
//  Created by Yurii Dukhovnyi on 12/05/2024.
//

import SwiftUI

@main
struct GitHubUserApp: App {

    @StateObject var viewModel = ViewModel(authenticator: .live)

    var body: some Scene {
        WindowGroup {
            switch viewModel.appState {
            case .authenticated(let configuration):
                SearchUserScreen(viewModel: viewModel.authenticatedViewModel(configuration: configuration))
            case .nonAuthenticated:
                ConfigurationScreen(
                    viewModel: viewModel.authenticationViewModel()
                )
            }
        }
    }
}

import Combine

extension GitHubUserApp {

    /// Defines possible application states.
    ///
    enum AppState {
        /// Not autenticated user.
        case nonAuthenticated
        /// Authenticated user with configuration.
        case authenticated(Configuration)
    }

    final class ViewModel: ObservableObject {

        @Published var appState = AppState.nonAuthenticated

        init(
            authenticator: Authenticator
        ) {
            self.authenticator = authenticator

            setup()
        }

        /// Creates authentication view model and handles authentication
        /// events.
        /// 
        func authenticationViewModel() -> ConfigurationScreen.ViewModel {

            .init(
                onConfigure: { [weak self] personalAccessToken in
                    guard let self else { return }
                    self.authenticator.authenticate(personalAccessToken)
                        .sink(
                            receiveCompletion: { _ in },
                            receiveValue: { _ in }
                        )
                        .store(in: &self.cancellables)
                }
            )
        }

        func authenticatedViewModel(configuration: Configuration) -> SearchUserScreen.ViewModel {

            .init(
                configuration: configuration,
                apiClient: Api.Client(
                    session: .shared,
                    baseUrl: Api.baseUrl,
                    middleware: .live(
                        configuration: configuration
                    )
                )
            )
        }

        // MARK: - Private

        private let authenticator: Authenticator

        private var cancellables = Set<AnyCancellable>()

        private func setup() {

            authenticator.state
                .receive(on: DispatchQueue.main)
                .sink { [weak self] appState in
                    self?.appState = appState
                }
                .store(in: &cancellables)
        }
    }
}
