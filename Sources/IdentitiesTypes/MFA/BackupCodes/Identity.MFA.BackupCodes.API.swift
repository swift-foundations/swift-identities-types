//
//  Identity.MFA.BackupCodes.API.swift
//  swift-identities
//
//  Created by Coen ten Thije Boonkkamp on 19/08/2025.
//

import Dual
import Foundation
import URLRouting

extension Identity.MFA.BackupCodes {
    /// Backup code operations.
    @Cases
    public enum API: Equatable, Sendable {
        /// Regenerate backup codes
        case regenerate

        /// Verify a backup code during authentication
        case verify(Identity.MFA.BackupCodes.Verify)

        /// Get count of remaining codes
        case remaining
    }
}

extension Identity.MFA.BackupCodes.API {
    /// Router for BackupCodes endpoints.
    public struct Router: ParserPrinter, Sendable {

        public init() {}

        public var body: some URLRouting.Router<Identity.MFA.BackupCodes.API> {
            OneOf {
                URLRouting.Route(.case(Identity.MFA.BackupCodes.API.cases.regenerate)) {
                    Method.post
                    Path { "regenerate" }
                }

                URLRouting.Route(.case(Identity.MFA.BackupCodes.API.cases.verify)) {
                    Method.post
                    Path.verify
                    URLRouting.Body(.json(Identity.MFA.BackupCodes.Verify.self))
                }

                URLRouting.Route(.case(Identity.MFA.BackupCodes.API.cases.remaining)) {
                    Method.get
                    Path { "remaining" }
                }
            }
        }
    }
}
