//
//  File 2.swift
//  swift-identities
//
//  Created by Coen ten Thije Boonkkamp on 26/07/2025.
//

import Foundation
import HTML_Form_Coder_Codable
import HTML_Standard

extension HTML.Form.Coder.Decoder {
    public static var identities: HTML.Form.Coder.Decoder {
        HTML.Form.Coder.Decoder(arrayParsingStrategy: .bracketsWithIndices)
    }
}

extension HTML.Form.Coder.Encoder {
    public static var identities: HTML.Form.Coder.Encoder {
        HTML.Form.Coder.Encoder(arrayEncodingStrategy: .bracketsWithIndices)
    }
}
