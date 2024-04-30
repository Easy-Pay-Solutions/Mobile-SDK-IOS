
import Foundation

public struct Config {
    let apiVersion: String
    let apiKey: String //SessionKey
    let hmacSecret: String
    private(set) var publicKey: PublicKey? = nil
    private(set) var thumbprint: String?
    
    
    public init(apiKey: String,
                hmacToken: String) {
        self.apiVersion = "1.0"
        self.apiKey = apiKey
        self.hmacSecret = hmacToken
    }
    
    mutating func configureCertificate(encryptionUtils: EncryptionUtils, certificateData: Data) {
        self.publicKey = try? encryptionUtils.publicKey(from: certificateData)
    }
    
    mutating func setupThumbprint(_ thumbprint: String?) {
        self.thumbprint = thumbprint
    }
}
