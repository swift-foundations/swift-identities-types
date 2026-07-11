//
//  Identity.OAuth.API.swift
//  swift-identities-types
//
//  Created by Coen ten Thije Boonkkamp on 10/09/2025.
//

import Dual
import Foundation
import URLRouting

extension Identity.OAuth {
    /// OAuth-related API endpoints
    @Cases
    public enum API: Equatable, Sendable {
        /// Get list of available OAuth providers
        case providers

        /// Initiate OAuth authorization flow
        case authorize(provider: String)

        /// Handle OAuth callback with code and state
        case callback(Identity.OAuth.CallbackRequest)

        /// Get current OAuth connections
        case connections

        /// Disconnect an OAuth provider
        case disconnect(provider: String)
    }
}

extension Identity.OAuth.API {
    /// Router for OAuth API endpoints
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<Identity.OAuth.API> {
            OneOf {
                // GET /oauth/providers
                URLRouting.Route(.case(Identity.OAuth.API.cases.providers)) {
                    Method.get
                    Path { "providers" }
                }

                // GET /oauth/authorize/:provider
                URLRouting.Route(.case(Identity.OAuth.API.cases.authorize)) {
                    Method.get
                    Path { "authorize" }
                    Path { Parse(.string) }  // provider
                }

                // GET /oauth/callback
                URLRouting.Route(.case(Identity.OAuth.API.cases.callback)) {
                    Method.get
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
                URLRouting.Route(.case(Identity.OAuth.API.cases.connections)) {
                    Method.get
                    Path { "connections" }
                }

                // DELETE /oauth/disconnect/:provider
                URLRouting.Route(.case(Identity.OAuth.API.cases.disconnect)) {
                    Method.delete
                    Path { "disconnect" }
                    Path { Parse(.string) }  // provider
                }
            }
        }
    }
}
