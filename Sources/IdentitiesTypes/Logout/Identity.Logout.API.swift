//
//  Identity.Logout.API.swift
//  swift-identities
//
//  Created by Coen ten Thije Boonkkamp on 19/08/2025.
//

import Dual
import URLRouting

extension Identity.Logout {
    /// Logout operations for terminating user sessions.
    ///
    /// This enum provides different logout strategies:
    /// - `current`: Logs out only the current session
    /// - `all`: Logs out all sessions across all devices by incrementing sessionVersion
    @Cases
    public enum API: Equatable, Sendable {
        /// Logs out the current session only
        case current

        /// Logs out all sessions for the user across all devices
        case all
    }
}

extension Identity.Logout.API {
    /// Router for logout endpoints
    public struct Router: ParserPrinter, Sendable {

        public init() {}

        public var body: some URLRouting.Router<Identity.Logout.API> {
            OneOf {
                // POST /logout (current session)
                URLRouting.Route(.case(Identity.Logout.API.cases.current)) {
                    Method.post
                }

                // POST /logout/all (all sessions)
                URLRouting.Route(.case(Identity.Logout.API.cases.all)) {
                    Path { "all" }
                    Method.post
                }
            }
        }
    }
}
