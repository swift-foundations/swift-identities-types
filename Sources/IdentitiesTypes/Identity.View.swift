//
//  Identity.View.swift
//  swift-web
//
//  Created by Coen ten Thije Boonkkamp on 07/10/2024.
//

import Dual
import URLRouting

extension Identity {
    /// View routing and navigation states for the identity consumer interface.
    ///
    /// This namespace defines the possible view states and navigation flows for client-side
    /// identity management, including:
    /// - Authentication (login/logout)
    /// - Account creation and verification
    /// - Profile management (email, password)
    /// - Account deletion
    @Cases
    public enum View: Equatable, Sendable {
        case authenticate(Identity.Authentication.View)
        case create(Identity.Creation.View)
        case delete(Identity.Deletion.View)
        case logout
        case email(Identity.Email.View)
        case password(Identity.Password.View)
        case mfa(Identity.MFA.View)
        case oauth(Identity.View.OAuth)
    }
}

extension Identity.View {
    /// Convenience accessor for the login view state.
    public static let login: Self = .authenticate(.credentials)
}

// Note: The nested type definitions have been removed as we're now using
// the feature-based types directly (Identity.Authentication.View, Identity.Creation.View, etc.)
// These are defined in their respective feature modules.

extension Identity.View {
    /// URL router for mapping between URLs and view states.
    ///
    /// This router handles bidirectional conversion between URLs and view states,
    /// defining the client-side routing structure for all identity management flows.
    public struct Router: ParserPrinter {

        public init() {}

        /// The routing configuration for all view states.
        ///
        /// Defines URL patterns for each view state:
        /// - /create/* - Account creation flows
        /// - /login, /credentials - Authentication
        /// - /password/* - Password management
        /// - /email/* - Email management
        public var body: some URLRouting.Router<Identity.View> {
            OneOf {

                URLRouting.Route(.case(Identity.View.cases.create)) {
                    Path.create
                    // Delegate to the feature's view router
                    Identity.Creation.View.Router()
                }

                URLRouting.Route(.case(Identity.View.cases.logout)) {
                    Path.logout
                }

                URLRouting.Route(.case(Identity.View.cases.delete)) {
                    Path.delete
                    Identity.Deletion.View.Router()
                }

                URLRouting.Route(.case(Identity.View.cases.password)) {
                    Path.password
                    // Delegate to the feature's view router
                    Identity.Password.View.Router()
                }

                URLRouting.Route(.case(Identity.View.cases.email)) {
                    Path.email
                    // Delegate to the feature's view router
                    Identity.Email.View.Router()
                }

                URLRouting.Route(.case(Identity.View.cases.mfa)) {
                    Path { "mfa" }
                    // Delegate to the feature's view router
                    Identity.MFA.View.Router()
                }

                URLRouting.Route(.case(Identity.View.cases.oauth)) {
                    // Delegate to the feature's view router
                    Identity.View.OAuth.Router()
                }

                URLRouting.Route(.case(Identity.View.cases.authenticate)) {
                    // Delegate to the feature's view router
                    Identity.Authentication.View.Router()
                }
            }
        }
    }
}
