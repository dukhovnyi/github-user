//
// Copyright © 2024 Yurii Dukhovnyi. All rights reserved.
//
// This file is an original work developed by Yurii Dukhovnyi.
//

import Foundation
import Combine

extension SearchUserScreen {

    final class ViewModel: ObservableObject {

        enum ViewState {
            case empty, error(Error), list([User])
        }

        @Published var searchText = ""
        @Published var state = ViewState.empty

        init(configuration: Configuration, apiClient: ApiClientProtocol) {
            self.configuration = configuration
            self.apiClient = apiClient

            setup()
        }

        #if DEBUG
        func emulateTextChanging(newText: String = "some new text") {
            searchText = newText
        }
        #endif

        // MARK: - Private

        private let apiClient: ApiClientProtocol
        private let configuration: Configuration

        private var cancellables = Set<AnyCancellable>()
        private var searchRequestCancellable: AnyCancellable?

        private func setup() {

            $searchText
                .debounce(for: 1, scheduler: DispatchQueue.main)
                .sink { [weak self] text in
                    if text.trimmingCharacters(in: .whitespacesAndNewlines).count > 2 {
                        self?.sendRequest()
                    } else {
                        self?.state = .empty
                    }
                }
                .store(in: &cancellables)
        }

        private func sendRequest() {

            let request = Api.SearchRequestBuilder.users(query: searchText)
            searchRequestCancellable = apiClient.send(request: request)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    guard case .failure(let error) = completion else { return }
                    self?.state = .error(error)
                } receiveValue: { [weak self] response in
                    self?.state = .list(response.items)
                }

        }
    }
}
