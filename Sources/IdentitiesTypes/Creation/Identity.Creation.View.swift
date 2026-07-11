//
//  Identity.Creation.Route.swift
//  swift-identities
//
//  Feature-based routing for Create functionality
//

import Dual
import URLRouting

extension Identity.Creation {
    /// View routes for identity creation pages.
    ///
    /// Provides frontend routes for:
    /// - Creation request form
    /// - Email verification page
    @Cases
    public enum View: Equatable, Sendable {
        /// Identity creation request page
        case request

        /// Email verification page with token and email
        case verify(Identity.Creation.Verification)

        public static let verify: Self = .verify(.init())
    }
}

extension Identity.Creation.View {
    /// Router for creation view endpoints.
    ///
    /// Maps view routes to their URL paths:
    /// - Request: `/create/request`
    /// - Verify: `/create/verify`
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<Identity.Creation.View> {
            OneOf {
                URLRouting.Route(.case(Identity.Creation.View.cases.request)) {
                    Path { "request" }
                }

                URLRouting.Route(.case(Identity.Creation.View.cases.verify)) {
                    Path { "verify" }

                    Parse(
                        .memberwise(
                            Identity.Creation.Verification.init(token:email:),
                            { ($0.token, $0.email) }
                        )
                    ) {
                        URLRouting.Query {
                            RFC_3986.URI.Query.Field(
                                Identity.Creation.Verification.CodingKeys.token.rawValue,
                                .string,
                                default: ""
                            )
                            RFC_3986.URI.Query.Field(
                                Identity.Creation.Verification.CodingKeys.email.rawValue,
                                .string,
                                default: ""
                            )
                        }
                    }
                }
            }
        }
    }
}
