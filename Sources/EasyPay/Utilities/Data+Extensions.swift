
import Foundation
import Security
import CommonCrypto

extension Data {
    public func sha1() -> Data {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        self.withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(self.count), &digest)
        }
        return Data(digest)
    }
}
