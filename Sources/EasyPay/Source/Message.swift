//
//  Message.swift
//  SwiftyRSA
//
//  Created by Loïs Di Qual on 9/19/16.
//  Copyright © 2016 Scoop. All rights reserved.
//

import Foundation
import Sentry
// Taken from: https:github.com/TakeScoop/SwiftyRSA
public protocol Message {
    var data: Data { get }
    var base64String: String { get }
    init(data: Data)
    init(base64Encoded base64String: String) throws
}

public extension Message {
    
    /// Base64-encoded string of the message data
    var base64String: String {
        return data.base64EncodedString()
    }
    
    /// Creates an encrypted message with a base64-encoded string.
    ///
    /// - Parameter base64String: Base64-encoded data of the encrypted message
    /// - Throws: SwiftyRSAError
    init(base64Encoded base64String: String) throws {
        guard let data = Data(base64Encoded: base64String) else {
            let error = SwiftyRSAError.invalidBase64String
            SentrySDK.capture(error: error)
            throw error
        }
        self.init(data: data)
    }
}
