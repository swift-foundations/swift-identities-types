//
//  Identity.MFA.WebAuthn.API.swift
//  swift-identities
//
//  Created by Coen ten Thije Boonkkamp on 19/08/2025.
//

import Dual
import Foundation
import URLRouting

extension Identity.MFA.WebAuthn {
    /// WebAuthn/FIDO2 authentication operations.
    @Cases
    public enum API: Equatable, Sendable {
        /// Initialize WebAuthn registration
        case beginRegistration

        /// Complete WebAuthn registration
        case finishRegistration(Identity.MFA.WebAuthn.FinishRegistration)

        /// Begin WebAuthn authentication
        case beginAuthentication

        /// Complete WebAuthn authentication
        case finishAuthentication(Identity.MFA.WebAuthn.FinishAuthentication)

        /// List registered credentials
        case listCredentials

        /// Remove a credential
        case removeCredential(Identity.MFA.WebAuthn.RemoveCredential)

        /// Disable all WebAuthn
        case disable(Identity.MFA.DisableRequest)
    }
}

extension Identity.MFA.WebAuthn.API {
    /// Router for WebAuthn endpoints.
    public struct Router: ParserPrinter, Sendable {

        public init() {}

        public var body: some URLRouting.Router<Identity.MFA.WebAuthn.API> {
            OneOf {
                URLRouting.Route(.case(Identity.MFA.WebAuthn.API.cases.beginRegistration)) {
                    Method.post
                    Path { "register" }
                    Path { "begin" }
                }

                URLRouting.Route(.case(Identity.MFA.WebAuthn.API.cases.finishRegistration)) {
                    Method.post
                    Path { "register" }
                    Path { "finish" }
                    URLRouting.Body(coding: .json(Identity.MFA.WebAuthn.FinishRegistration.self))
                }

                URLRouting.Route(.case(Identity.MFA.WebAuthn.API.cases.beginAuthentication)) {
                    Method.post
                    Path { "authenticate" }
                    Path { "begin" }
                }

                URLRouting.Route(.case(Identity.MFA.WebAuthn.API.cases.finishAuthentication)) {
                    Method.post
                    Path { "authenticate" }
                    Path { "finish" }
                    URLRouting.Body(coding: .json(Identity.MFA.WebAuthn.FinishAuthentication.self))
                }

                URLRouting.Route(.case(Identity.MFA.WebAuthn.API.cases.listCredentials)) {
                    Method.get
                    Path { "credentials" }
                }

                URLRouting.Route(.case(Identity.MFA.WebAuthn.API.cases.removeCredential)) {
                    Method.post
                    Path { "credentials" }
                    Path { "remove" }
                    URLRouting.Body(coding: .json(Identity.MFA.WebAuthn.RemoveCredential.self))
                }

                URLRouting.Route(.case(Identity.MFA.WebAuthn.API.cases.disable)) {
                    Method.post
                    Path.disable
                    URLRouting.Body(coding: .json(Identity.MFA.DisableRequest.self))
                }
            }
        }
    }
}
