//
//  Identity.MFA.Status.API.swift
//  swift-identities
//
//  Created by Coen ten Thije Boonkkamp on 19/08/2025.
//

import Dual
import Foundation
import URLRouting

extension Identity.MFA.Status {
    /// General MFA status operations.
    @Cases
    public enum API: Equatable, Sendable {
        /// Get the current MFA status including configured methods and requirements
        case get

        /// Get MFA challenge after authentication
        case challenge
    }
}

extension Identity.MFA.Status.API {
    /// Router for Status endpoints.
    public struct Router: ParserPrinter, Sendable {

        public init() {}

        public var body: some URLRouting.Router<Identity.MFA.Status.API> {
            OneOf {
                URLRouting.Route(.case(Identity.MFA.Status.API.cases.get)) {
                    Method.get
                }

                URLRouting.Route(.case(Identity.MFA.Status.API.cases.challenge)) {
                    Method.get
                    Path.challenge
                }
            }
        }
    }
}
