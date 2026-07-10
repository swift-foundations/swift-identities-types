// swift-tools-version: 6.3.1

import Foundation
import PackageDescription

extension String {
    static let identitiesTypes: Self = "IdentitiesTypes"
}

extension Target.Dependency {
    static var identitiesTypes: Self { .target(name: .identitiesTypes) }
}

extension Target.Dependency {
    static var jwt: Self { .product(name: "JWT", package: "swift-json-web-token") }
    static var emailAddress: Self { .product(name: "EmailAddress", package: "swift-emailaddress") }
    static var casePaths: Self { .product(name: "CasePaths", package: "swift-case-paths") }
    static var urlRouting: Self { .product(name: "URLRouting", package: "swift-url-routing") }
    static var urlFormCoding: Self { .product(name: "URLFormCoding", package: "swift-url-form-coding") }
    static var urlFormCodingURLRouting: Self {
        .product(name: "URLFormCodingURLRouting", package: "swift-url-form-coding")
    }
    static var dependencies: Self { .product(name: "Dependencies", package: "swift-dependencies") }
    static var dependenciesTestSupport: Self {
        .product(name: "Dependencies Test Support", package: "swift-dependencies")
    }
    static var taggedPrimitives: Self { .product(name: "Tagged Primitives", package: "swift-tagged-primitives") }
}

let package = Package(
    name: "swift-identities-types",
    platforms: [
        // Bumped from macOS(.v14)/iOS(.v17): the swift-foundations/swift-json-web-token
        // dependency's own Package.swift declares macOS(.v26)/iOS(.v26) as its minimum —
        // SwiftPM propagates a dependency's platform floor upward to consumers.
        .macOS(.v26),
        .iOS(.v26)
    ],
    products: [
        .library(name: .identitiesTypes, targets: [.identitiesTypes])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-foundations/swift-dependencies.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-emailaddress.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-json-web-token.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-tagged-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-url-form-coding.git", branch: "main"),
        // TRANSITIONAL third-party debt: no institute equivalent yet (see MANIFEST/report).
        .package(url: "https://github.com/pointfreeco/swift-case-paths", from: "1.7.2"),
        .package(url: "https://github.com/swift-foundations/swift-url-routing.git", from: "0.6.0")
    ],
    targets: [
        .target(
            name: .identitiesTypes,
            dependencies: [
                .dependencies,
                .emailAddress,
                .jwt,
                .casePaths,
                .urlRouting,
                .urlFormCoding,
                .urlFormCodingURLRouting,
                .taggedPrimitives
            ]
        ),
        .testTarget(
            name: .identitiesTypes.tests,
            dependencies: [
                .identitiesTypes,
                .dependenciesTestSupport
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)

extension String { var tests: Self { "\(self) Tests" } }
