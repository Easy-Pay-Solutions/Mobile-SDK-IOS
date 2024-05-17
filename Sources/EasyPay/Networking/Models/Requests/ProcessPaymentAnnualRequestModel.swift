
import Foundation

public struct ProcessPaymentAnnualRequestModel: Codable {
    private let consentId: Int
    private let processAmount: String

    public init(consentId: Int, processAmount: String) {
        self.consentId = consentId
        self.processAmount = processAmount
    }

    public func convertToDictionary() -> [String: Any] {
        return [
            "ConsentID": consentId,
            "ProcessAmount": ValidatorUtils.stripCurrencyFormatting(from: processAmount) as Any
        ]
    }
}
