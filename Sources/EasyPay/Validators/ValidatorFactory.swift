
import Foundation

class ValidatorFactory {
    static func produce(request: BaseRequest) -> Validator {
        if let cardSaleManualRequest = request as? CardSaleManualRequest {
            return CardSaleManualValidator(dataToValidate: cardSaleManualRequest.transactionRequest)
        }
        if let createAnnualRequestManualRequest = request as? CreateConsentAnnualRequest {
            return CreateConsentAnnualValidator(dataToValidate: createAnnualRequestManualRequest.createConsentAnnualRequest)
        }
        if let consentAnnualListingRequest = request as? ConsentAnnualListingRequest {
            return ConsentAnnualListingValidator(dataToValidate: consentAnnualListingRequest.consentAnnualListingRequest)
        }
        return Validator()
    }
}
