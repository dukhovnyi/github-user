//
// Copyright © 2024 Yurii Dukhovnyi. All rights reserved.
//
// This file is an original work developed by Yurii Dukhovnyi.
//

import SwiftUI

extension SearchUserScreen {

    struct RowView: View {

        let user: User

        var body: some View {
            
            HStack {
                AsyncImage(
                    url: URL(string: user.avatarUrl),
                    content: {
                        $0.image?.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(
                                width: 36,
                                height: 36
                            )
                            .clipShape(.circle)
                            .clipped()
                    }
                )

                Text(user.login)
            }
        }
    }
}

#Preview {
    SearchUserScreen.RowView(user: .yurii)
}
