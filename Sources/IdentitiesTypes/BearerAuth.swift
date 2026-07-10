//
//  BearerAuth.swift
//  swift-identities-types
//
//  TRANSITIONAL: `swift-authenticating` (coenttb) has no institute equivalent yet
//  (verified 2026-07-09 against /Users/coen/Developer/swift-foundations/swift-authentication,
//  which is an unconverted `swift-identities` clone, not an `Authenticating` product).
//  This reproduces the minimal `BearerAuth` surface this package actually consumes:
//  a bearer token value plus a `Router` that parses/prints the
//  `Authorization: Bearer <token>` header. Remove this file and restore an external
//  dependency once an institute `Authenticating`-equivalent package exists on disk.
//

import URLRouting

public struct BearerAuth: Codable, Hashable, Sendable {
    public let token: String

    public init(token: String) throws {
        self.token = token
    }
}

extension BearerAuth {
    public struct Router: URLRouting.ParserPrinter {
        public init() {}

        public var body: some URLRouting.ParserPrinter<URLRequestData, BearerAuth> {
            Headers {
                Field("Authorization") {
                    "Bearer "
                    Rest()
                }
            }
            .map(
                .convert(
                    apply: { (token: Substring) in try? BearerAuth(token: String(token)) },
                    unapply: { (bearerAuth: BearerAuth) in Substring(bearerAuth.token) }
                )
            )
        }
    }
}
