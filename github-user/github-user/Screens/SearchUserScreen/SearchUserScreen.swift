//
// Copyright © 2024 Yurii Dukhovnyi. All rights reserved.
//
// This file is an original work developed by Yurii Dukhovnyi.
//

import SwiftUI

struct SearchUserScreen: View {

    @ObservedObject var viewModel: ViewModel

    var body: some View {

        NavigationStack {

            switch viewModel.state {

            case .list(let users) where users.isEmpty:
                ContentUnavailableView(
                    "Nothing found...",
                    systemImage: "questionmark.circle.fill"
                )
                
            case .list(let users):
                buildUsersList(users)
                
            case .error(let error) where (error as? Api.ApiError) == Api.ApiError.notConnectedToInternet:
                ContentUnavailableView(
                    "No Internet connection",
                    systemImage: "xmark"
                )

            case .error(let error):
                ContentUnavailableView(
                    "Error occured='\(error)'.",
                    systemImage: "xmark"
                )

            case .empty:
                ContentUnavailableView(
                    "Start typing to find GitHub users...",
                    systemImage: "textformat.size"
                )
            }
        }
        .searchable(text: $viewModel.searchText)
    }

    @ViewBuilder
    func buildUsersList(_ users: [User]) -> some View {
        List(users) { user in
            NavigationLink(
                destination: { UserProfileScreen(user: user) },
                label: { RowView(user: user) }
            )
        }
        .listStyle(.plain)
    }
}

#Preview {
    SearchUserScreen(
        viewModel: .init(
            configuration: Configuration(personalAccessToken: ""),
            apiClient: Api.Client(session: .shared, baseUrl: Api.baseUrl, middleware: .mock())
        )
    )
}
