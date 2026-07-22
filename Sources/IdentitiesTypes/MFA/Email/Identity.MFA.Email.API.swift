//
//  Identity.MFA.Email.API.swift
//  swift-identities
//
//  Created by Coen ten Thije Boonkkamp on 19/08/2025.
//

import Dual
import Foundation
import URLRouting

extension Identity.MFA.Email {
    /// Email-based authentication operations.
    @Cases
    public enum API: Equatable, Sendable {
        /// Setup email MFA
        case setup(Identity.MFA.Email.Setup)

        /// Request a new email code
        case requestCode

        /// Verify email code during authentication
        case verify(Identity.MFA.Email.Verify)

        /// Update email address for MFA
        case updateEmail(Identity.MFA.Email.UpdateEmail)

        /// Disable email authentication
        case disable(Identity.MFA.DisableRequest)
    }
}

extension Identity.MFA.Email.API {
    /// Router for Email endpoints.
    public struct Router: ParserPrinter, Sendable {

        public init() {}

        public var body: some URLRouting.Router<Identity.MFA.Email.API> {
            OneOf {
                URLRouting.Route(.case(Identity.MFA.Email.API.cases.setup)) {
                    Method.post
                    Path.setup
                    URLRouting.Body(coding: .json(Identity.MFA.Email.Setup.self))
                }

                URLRouting.Route(.case(Identity.MFA.Email.API.cases.requestCode)) {
                    Method.post
                    Path { "request" }
                }

                URLRouting.Route(.case(Identity.MFA.Email.API.cases.verify)) {
                    Method.post
                    Path.verify
                    URLRouting.Body(coding: .json(Identity.MFA.Email.Verify.self))
                }

                URLRouting.Route(.case(Identity.MFA.Email.API.cases.updateEmail)) {
                    Method.post
                    Path.update
                    URLRouting.Body(coding: .json(Identity.MFA.Email.UpdateEmail.self))
                }

                URLRouting.Route(.case(Identity.MFA.Email.API.cases.disable)) {
                    Method.post
                    Path.disable
                    URLRouting.Body(coding: .json(Identity.MFA.DisableRequest.self))
                }
            }
        }
    }
}
