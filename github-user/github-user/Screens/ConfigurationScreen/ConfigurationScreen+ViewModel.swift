//
// Copyright © 2024 Yurii Dukhovnyi. All rights reserved.
//
// This file is an original work developed by Yurii Dukhovnyi.
//

import Foundation
import Combine

extension ConfigurationScreen {

    final class ViewModel: ObservableObject {

        @Published var personalAccessToken = "" {
            didSet {
                let trimmed = personalAccessToken.trimmingCharacters(in: .whitespacesAndNewlines)
                isSubmitEnabled = !trimmed.isEmpty
            }
        }
        @Published var isSubmitEnabled = false

        init(onConfigure: @escaping (String) -> Void) {
            self.onConfigure = onConfigure
        }

        func configure() {

            let trimmedToken = personalAccessToken.trimmingCharacters(in: .whitespacesAndNewlines)
            onConfigure(trimmedToken)
        }

        // MARK: - Private

        private let onConfigure: (String) -> Void
    }
}
