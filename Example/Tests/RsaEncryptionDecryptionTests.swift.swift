import XCTest
import Security
@testable import EasyPay

class EncryptionDecryptionTests: XCTestCase {
    
    let apiKey = "9B9175EF556E4DDA93303132323141303035383339"
    let hmacSecret = ""
    
    func testEncryptionDecryptionWithRandomKey() {
        let utils = EncryptionUtils(apiKey: apiKey, hmacSecret: hmacSecret)
        let textToEncrypt = "Chuck Norris can set ants on fire with a magnifying glass. At night."
        
        do {
            let keyPair = try SwiftyRSA.generateRSAKeyPair(sizeInBits: 2048)
            
            let publicKeyBase64 = try keyPair.publicKey.base64String()
            let privateKeyBase64 = try keyPair.privateKey.base64String()
            
            guard let publicKeyData = Data(base64Encoded: publicKeyBase64) else {
                fatalError("Failed to decode base64 public key")
            }
            let publicKey = try PublicKey(data: publicKeyData)
            
            let encrypted = utils.encryptBase64(text: textToEncrypt, with: publicKey)
            
            let decrypted = utils.decryptBase64(text: encrypted!, withPrivateKey: privateKeyBase64)
            
            XCTAssertEqual(textToEncrypt, decrypted)
        } catch {
            fatalError("Error: \(error)")
        }
    }
}
