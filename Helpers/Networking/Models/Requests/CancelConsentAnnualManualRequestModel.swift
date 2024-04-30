
import Foundation

public struct CancelConsentAnnualManualRequestModel: Codable {
    private let consentId: Int

    public init(consentId: Int) {
        self.consentId = consentId
    }

    public func convertToDictionary() -> [String: Any] {
        return [
            "ConsentID": consentId,
        ]
    }
}
