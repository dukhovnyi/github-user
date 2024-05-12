//
// Copyright © 2024 Yurii Dukhovnyi. All rights reserved.
//
// This file is an original work developed by Yurii Dukhovnyi.
//

import SwiftUI

struct UserProfileScreen: View {

    let user: User

    var body: some View {
        GeometryReader(content: { geometry in
            VStack {
                AsyncImage(
                    url: .init(string: user.avatarUrl),
                    content: {
                        $0.image?.resizable()
                            .scaledToFit()
                            .frame(maxWidth: geometry.size.width / 2)
                    }
                )
                HStack(spacing: 32) {
                    Text("username='\(user.login)'")
                    Text("id='\(user.id)'")
                }
            }
            .frame(width: geometry.size.width)
        })
    }
}

#Preview {
    UserProfileScreen(user: .yurii)
}
