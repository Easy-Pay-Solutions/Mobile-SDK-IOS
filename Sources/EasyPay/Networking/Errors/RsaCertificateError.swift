
import Foundation

enum RsaCertificateError: Error {
    case failedToLoadCertificateData
    case failedToCreateCertificate
    case failedToExtractPublicKey
}

extension RsaCertificateError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failedToLoadCertificateData:
            return "Failed to load certificate data"
        case .failedToCreateCertificate:
            return "Failed to create certificate"
        case .failedToExtractPublicKey:
            return "Failed to extract public key"
        }
    }
}
