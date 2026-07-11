//
//  Identity.View.OAuth.swift
//  swift-identities-types
//
//  Created by Coen ten Thije Boonkkamp on 10/09/2025.
//

import Dual
import Foundation
import URLRouting

extension Identity.View {
    /// OAuth view routes for UI pages
    @Cases
    public enum OAuth: Equatable, Sendable {
        /// OAuth login page showing available providers
        case login

        /// OAuth callback handling page
        case callback(Identity.OAuth.CallbackRequest)

        /// OAuth connection management page
        case connections

        /// OAuth error page
        case error(String)
    }
}

extension Identity.View.OAuth {
    /// Router for OAuth view routes
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<Identity.View.OAuth> {
            OneOf {
                // GET /oauth/login
                URLRouting.Route(.case(Identity.View.OAuth.cases.login)) {
                    Method.get
                    Path { "oauth" }
                    Path { "login" }
                }

                // GET /oauth/callback
                URLRouting.Route(.case(Identity.View.OAuth.cases.callback)) {
                    Method.get
                    Path { "oauth" }
                    Path { "callback" }

                    // The builder pairs left-associatively, so four values arrive as the
                    // nested tuple `(((String, String), String), String?)` (url-routing
                    // RoutingErrorTests pattern), not a flat 4-tuple.
                    Parse(
                        .memberwise(
                            { (values: (((String, String), String), String?)) in
                                Identity.OAuth.CallbackRequest(
                                    provider: values.0.0.0,
                                    code: values.0.0.1,
                                    state: values.0.1,
                                    redirectURI: values.1
                                )
                            },
                            { ((($0.provider, $0.code), $0.state), $0.redirectURI) }
                        )
                    ) {
                        URLRouting.Query {
                            RFC_3986.URI.Query.Field("provider", .string, default: "github")
                            RFC_3986.URI.Query.Field("code") { Parse(.string) }
                            RFC_3986.URI.Query.Field("state") { Parse(.string) }

                            Optionally {
                                RFC_3986.URI.Query.Field("redirect_uri") { Parse(.string) }
                            }
                        }
                    }
                }

                // GET /oauth/connections
                URLRouting.Route(.case(Identity.View.OAuth.cases.connections)) {
                    Method.get
                    Path { "oauth" }
                    Path { "connections" }
                }

                // GET /oauth/error
                URLRouting.Route(.case(Identity.View.OAuth.cases.error)) {
                    Method.get
                    Path { "oauth" }
                    Path { "error" }
                    URLRouting.Query {
                        RFC_3986.URI.Query.Field("message") { Parse(.string) }
                    }
                }
            }
        }
    }
}
