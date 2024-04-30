
@testable import EasyPay
import XCTest
import CommonCrypto

class SessionKeyEncryptionUtilsTests: XCTestCase {
    private let userDevice = "123"
    private let apiKey = "9B9175EF556E4DDA93303132323141303035383339"
    private let hmacSecret = ""
    private let epoch = 1702565789

    lazy var expectedMockKey = "9B9175EF556E4DDA93303132323141303035383339_1702565789_123_F30FF9C473F7287BAA1A7C5A8DFAF337F5399AA6453E4EF4BBFA98B55DF59B7D"
    private let expectedMockHash = "F30FF9C473F7287BAA1A7C5A8DFAF337F5399AA6453E4EF4BBFA98B55DF59B7D"
    
    // Mock implementation of sessionKey method for testing
    func mockSessionKey() throws -> String {
        do {
            let hash = try mockHashableSession()
            let signature = "\(apiKey)_\(hash.epoch)_\(userDevice)_\(hash.hashed)"
            return signature
        } catch {
            throw EncryptionUtilsError.couldNotCreateSessionKey
        }
    }
    
    // Mock implementation of sessionKey method for testing
    func mockHashableSession() throws -> (epoch: Int, hashed: String)  {
        let hashable = "\(apiKey)_\(epoch)_\(userDevice)"
        
        if let secretData = hmacSecret.data(using: .ascii) {
            var hmac = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
            secretData.withUnsafeBytes { secretBufferPointer in
                hashable.withCString { hashableCString in
                    CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), secretBufferPointer.baseAddress, secretData.count, hashableCString, hashable.utf8.count, &hmac)
                }
            }
            return (epoch, hmac.map { String(format: "%02hhx", $0) }.joined().uppercased())
        } else {
            throw EncryptionUtilsError.couldNotGetHashable
        }
    }
    
    func testHashableSessionMock() {
        do {
            let hash = try mockHashableSession()
            XCTAssertEqual(expectedMockHash, hash.hashed)
            XCTAssertEqual(epoch, hash.epoch)
            XCTAssertFalse(hash.hashed.isEmpty)
        } catch {
            XCTFail("Failed to generate hash: \(error)")
        }
    }
    
    func testHashableSession() {
        let utils = EncryptionUtils(apiKey: apiKey, hmacSecret: hmacSecret)
        
        do {
            let hash = try utils.hashableSession()
            XCTAssertNotNil(hash)
            XCTAssertFalse(hash.hashed.isEmpty)
        } catch {
            XCTFail("Failed to generate hash: \(error)")
        }
    }
}
