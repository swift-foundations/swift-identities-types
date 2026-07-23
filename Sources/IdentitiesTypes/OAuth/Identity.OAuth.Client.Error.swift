//
//  Identity.OAuth.Client.Error.swift
//  swift-identities-types
//
//  Created by Coen ten Thije Boonkkamp on 23/07/2026.
//

extension Identity.OAuth.Client {
    /// Failure conditions for OAuth client operations.
    public enum Error: Swift.Error, Equatable, Sendable {
        /// A provider with the same identifier is already registered.
        case duplicate(identifier: String)

        /// The implementation refused to register the provider.
        case rejected(identifier: String, reason: String)
    }
}
