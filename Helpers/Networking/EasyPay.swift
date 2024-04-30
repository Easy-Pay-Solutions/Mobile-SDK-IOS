
import Foundation

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
        self.config = Config(apiKey: "", hmacToken: "")
        self.mApiClient = ApiClient(configuration: config)
    }
    
    public func configureSecrets(apiKey: String, hmacSecret: String) {
        self.config = Config(apiKey: apiKey, hmacToken: hmacSecret)
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
