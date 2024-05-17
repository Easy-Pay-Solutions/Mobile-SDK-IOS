
import Foundation
import Sentry

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
    private init() {
        self.config = Config(apiKey: "", hmacToken: "", sentryKey: "")
        self.mApiClient = ApiClient(configuration: config)
    }
    
    public func configureSecrets(apiKey: String, hmacSecret: String, sentryKey: String?) {
        self.config = Config(apiKey: apiKey, hmacToken: hmacSecret, sentryKey: sentryKey)
        self.mApiClient = ApiClient(configuration: config)
        mApiClient.downloadManuallyCertificate { result in
            switch result {
            case .success(let data):
                self.config.configureCertificate(encryptionUtils: EncryptionUtils(apiKey: apiKey, hmacSecret: hmacSecret), certificateData: data)
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
    
    private func setupThumbprint(_ thumbprint: String) {
        config.setupThumbprint(thumbprint)
    }
}
