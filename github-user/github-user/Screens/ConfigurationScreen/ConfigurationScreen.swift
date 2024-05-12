//
// Copyright © 2024 Yurii Dukhovnyi. All rights reserved.
//
// This file is an original work developed by Yurii Dukhovnyi.
//

import SwiftUI

struct ConfigurationScreen: View {

    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack(spacing: 16) {

            Text("GitHub personal access token")
                .font(.title3)
                .bold()

            TextField(
                text: $viewModel.personalAccessToken,
                label: {
                    Text("Please enter access token here")
                        .frame(alignment: .center)
                }
            )
        }
        .multilineTextAlignment(.center)

        Button(
            action: viewModel.configure,
            label: {
                HStack(spacing: 8) {
                    Text("Configure")
                }
            }
        )
        .buttonStyle(BorderedProminentButtonStyle())
        .disabled(!viewModel.isSubmitEnabled)
    }
}

#Preview {
    ConfigurationScreen(
        viewModel: .init(onConfigure: { _ in })
    )
    .padding()
}
