//
//  Identity.MFA.SMS.API.swift
//  swift-identities
//
//  Created by Coen ten Thije Boonkkamp on 19/08/2025.
//

import Dual
import Foundation
import URLRouting

extension Identity.MFA.SMS {
    /// SMS-based authentication operations.
    @Cases
    public enum API: Equatable, Sendable {
        /// Setup SMS with phone number
        case setup(Identity.MFA.SMS.Setup)

        /// Request a new SMS code
        case requestCode

        /// Verify SMS code during authentication
        case verify(Identity.MFA.SMS.Verify)

        /// Update phone number
        case updatePhoneNumber(Identity.MFA.SMS.UpdatePhoneNumber)

        /// Disable SMS authentication
        case disable(Identity.MFA.DisableRequest)
    }
}

extension Identity.MFA.SMS.API {
    /// Router for SMS endpoints.
    public struct Router: ParserPrinter, Sendable {

        public init() {}

        public var body: some URLRouting.Router<Identity.MFA.SMS.API> {
            OneOf {
                URLRouting.Route(.case(Identity.MFA.SMS.API.cases.setup)) {
                    Method.post
                    Path.setup
                    URLRouting.Body(.json(Identity.MFA.SMS.Setup.self))
                }

                URLRouting.Route(.case(Identity.MFA.SMS.API.cases.requestCode)) {
                    Method.post
                    Path { "request" }
                }

                URLRouting.Route(.case(Identity.MFA.SMS.API.cases.verify)) {
                    Method.post
                    Path.verify
                    URLRouting.Body(.json(Identity.MFA.SMS.Verify.self))
                }

                URLRouting.Route(.case(Identity.MFA.SMS.API.cases.updatePhoneNumber)) {
                    Method.post
                    Path.update
                    URLRouting.Body(.json(Identity.MFA.SMS.UpdatePhoneNumber.self))
                }

                URLRouting.Route(.case(Identity.MFA.SMS.API.cases.disable)) {
                    Method.post
                    Path.disable
                    URLRouting.Body(.json(Identity.MFA.DisableRequest.self))
                }
            }
        }
    }
}
