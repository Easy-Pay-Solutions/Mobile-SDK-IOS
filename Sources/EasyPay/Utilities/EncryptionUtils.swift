import UIKit
import CommonCrypto
import Security

enum EncryptionUtilsError: Error {
    case couldNotGetHashable
    case couldNotCreateSessionKey
}

final class EncryptionUtils {
    private let apiKey: String
    private let hmacSecret: String
    private let userDevice: String
    
    init(apiKey: String, hmacSecret: String) {
        self.apiKey = apiKey
        self.hmacSecret = hmacSecret
        self.userDevice = UIDevice.current.identifierForVendor?.uuidString.uppercased() ?? ""
    }
    
    func hashableSession() throws -> (epoch: Int, hashed: String)  {
        let epoch = Int(Date().timeIntervalSince1970)
        let hashable = "\(apiKey)_\(epoch)_\(userDevice)"
        
        if let secretData = hmacSecret.data(using: .utf8) {
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
    
    func sessionKey() throws -> String {
        do {
            let hash = try hashableSession()
            let signature = "\(apiKey)_\(hash.epoch)_\(userDevice)_\(hash.hashed)"
            return signature
        } catch {
            throw EncryptionUtilsError.couldNotCreateSessionKey
        }
    }
    // Convert: https://cheapsslsecurity.com/p/convert-a-certificate-to-pem-crt-to-pem-cer-to-pem-der-to-pem/
    // Verify: https://knowledge.digicert.com/solution/verify-the-integrity-of-an-ssl-tls-certificate-and-private-key-pair
    func publicKey(from data: Data) throws -> PublicKey? {
        guard let certificate = SecCertificateCreateWithData(nil, data as CFData) else {
            throw RsaCertificateError.failedToCreateCertificate
        }
        
        guard let certificate = try? PublicKey.init(reference: SecCertificateCopyKey(certificate)!) else {
            throw RsaCertificateError.failedToCreateCertificate
        }
        
        return certificate
    }
        
    func encryptBase64(text: String, with publicKey: PublicKey) -> String? {
        guard let clear = try? ClearMessage(string: text, using: .utf8) else {
            return nil
        }
        guard let encrypted = try? clear.encrypted(with: publicKey, padding: .OAEP) else {
            return nil
        }

        return encrypted.data.base64EncodedString()
    }
    
    func decryptBase64(text: String, withPrivateKey privateKeyBase64: String) -> String? {
        guard let privateKeyData = Data(base64Encoded: privateKeyBase64) else {
            return nil
        }
        
        do {
            let privateKey = try PrivateKey(data: privateKeyData)
            
            guard let encryptedData = Data(base64Encoded: text) else {
                return nil
            }
            let encrypted = EncryptedMessage(data: encryptedData)
            let clearMessage = try encrypted.decrypted(with: privateKey, padding: .OAEP)
            let decryptedData = clearMessage.data
            
            guard let decryptedText = String(data: decryptedData, encoding: .utf8) else {
                return nil
            }
            return decryptedText
        } catch {
            return nil
        }
    }
}
