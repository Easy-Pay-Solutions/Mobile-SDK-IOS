
import Foundation

enum NetworkingError: Error {
    case unsuccesfulRequest(statusCode: String)
    case noDataReceived
    case dataDecodingFailure
    case invalidCertificatePathURL
}

extension NetworkingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unsuccesfulRequest(let statusCode):
            return "Unsuccesful HTTP request: \(String(describing: statusCode))"
        case .noDataReceived:
            return "No data received from the server"
        case .dataDecodingFailure:
            return "Data decoding failure"
        case .invalidCertificatePathURL:
            return "Invalid certificate path URL"
        }
    }
}

