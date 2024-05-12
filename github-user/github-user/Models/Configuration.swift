//
// Copyright © 2024 Yurii Dukhovnyi. All rights reserved.
//
// This file is an original work developed by Yurii Dukhovnyi.
//

import Foundation

/// Defines configuration that is required for
/// application work.
struct Configuration {

    /// Access token as an alternative to using passwords
    /// for authentication to GitHub when using the GitHub API or the command line.
    ///
    /// [GitHub personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
    let personalAccessToken: String
}
