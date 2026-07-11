//
//  Identity.MFA.Verify.API.swift
//  swift-identities
//
//  Created by Coen ten Thije Boonkkamp on 21/08/2025.
//

import Foundation
import URLRouting
import URLFormCodingURLRouting

extension Identity.MFA {
    /// General MFA verification request during login.
    ///
    /// This endpoint handles MFA challenges after initial authentication.
    /// The client sends the session token received during login along with
    /// the verification code from their chosen MFA method.
    public struct Verify: Codable, Equatable, Sendable {
        /// Session token from the MFA challenge
        public let sessionToken: String

        /// MFA method to use for verification
        public let method: Identity.MFA.Method

        /// Verification code (e.g., TOTP code, SMS code, backup code)
        public let code: String

        public init(
            sessionToken: String,
            method: Identity.MFA.Method,
            code: String
        ) {
            self.sessionToken = sessionToken
            self.method = method
            self.code = code
        }
    }
}

extension Identity.MFA.Verify {
    /// Router for the MFA verify endpoint.
    public struct Router: ParserPrinter, Sendable {

        public init() {}

        public var body: some URLRouting.Router<Identity.MFA.Verify> {
            // Route-level wrap (W3): collapses the Skip-chain's `Either` failure into
            // `RFC_3986.URI.Routing.Error` (url-routing FormBodyRouteTests pattern).
            URLRouting.Route(.identity()) {
                Method.post
                URLRouting.Body(.form(Identity.MFA.Verify.self, decoder: .identities))
            }
        }
    }
}
