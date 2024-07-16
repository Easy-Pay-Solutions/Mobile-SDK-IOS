import Foundation

class ConsentAnnualListingValidator: Validator {
    private let request: ConsentAnnualListingRequestModel

    init(dataToValidate: ConsentAnnualListingRequestModel) {
        self.request = dataToValidate
    }

    override func validate(_ request: BaseRequest) -> (Error?, Bool) {
        return validateRequiredFields()
    }

    private func validateRequiredFields() -> (Error?, Bool) {
        // RPGUID or CustomerRefId is required
        if StringUtils.isNilOrEmpty(request.queryHelper.rpguid) && StringUtils.isNilOrEmpty(request.queryHelper.customerReferenceId) {
            return (ConsentAnnualListingValidationError.eitherCustomerRefIdOrRpguidIsRequired, false)
        }

        return (nil, true)
    }
}
