
import Foundation
import Sentry
import IOSSecuritySuite

public final class EasyPay {
    private var mApiClient: ApiClient
    private(set) public var config: Config
    static public let shared = EasyPay()
    public var certificateStatus: CertificateStatus? {
        return mApiClient.certificateStatus
    }
    public var apiClient: ApiClient {
        mApiClient
    }
    private var encryptionUtils: EncryptionUtils?

    private init() {
        self.config = Config(apiKey: "", hmacToken: "", sentryKey: "")
        self.mApiClient = ApiClient(configuration: config)
        self.encryptionUtils = nil
    }
    
    public func configureSecrets(apiKey: String,
                                   hmacSecret: String,
                                   sentryKey: String?,
                                   isProduction: Bool = true) {
          if isProduction && IOSSecuritySuite.amIJailbroken() {
              fatalError("Jailbroken device detected")
          }
        self.config = Config(apiKey: apiKey, hmacToken: hmacSecret, sentryKey: sentryKey)
        self.mApiClient = ApiClient(configuration: config)
        mApiClient.downloadManuallyCertificate { result in
            switch result {
            case .success(let data):
                let encryptionUtils = EncryptionUtils(apiKey: apiKey, hmacSecret: hmacSecret)
                self.encryptionUtils = encryptionUtils
                self.config.configureCertificate(encryptionUtils: encryptionUtils, certificateData: data)
                self.setupThumbprint(self.mApiClient.thumbprint(for: data))
            default:
                break
            }
        }
        if let sentryKey {
            SentrySDK.start { options in
                options.dsn = sentryKey
                options.enableCaptureFailedRequests = true
                options.debug = false
            }
        }
    }
    
    public func loadCertificate(_ completion: @escaping (Result<Data, Error>) -> Void) {
        mApiClient.downloadManuallyCertificate { result in
            switch result {
            case .success(let data):
                self.config.configureCertificate(encryptionUtils: EncryptionUtils(apiKey: self.config.apiKey, hmacSecret: self.config.hmacSecret), certificateData: data)
                self.setupThumbprint(self.mApiClient.thumbprint(for: data))
            default:
                break
            }
        }
    }
    
    public func encryptCardData(cardNumber: String) -> String? {
        if let certificate = config.publicKey {
            let encryptedBase64 = encryptionUtils?.encryptBase64(text: cardNumber.withReplacedCharacters(" ", by: ""), with: certificate)
            if let thumbprint = config.thumbprint, let encryptedBase64, !StringUtils.isNilOrEmpty(encryptedBase64) {
                return "\(encryptedBase64)|\(thumbprint)"
            } else {
                return ""
            }
        }
        return nil
    }
    
    private func setupThumbprint(_ thumbprint: String) {
        config.setupThumbprint(thumbprint)
    }
}
