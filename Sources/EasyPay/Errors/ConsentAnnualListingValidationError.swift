import Foundation

public enum ConsentAnnualListingValidationError: Error {
    case eitherCustomerRefIdOrRpguidIsRequired
}

extension ConsentAnnualListingValidationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .eitherCustomerRefIdOrRpguidIsRequired:
            return NSLocalizedString("eitherCustomerRefIdOrRpguidIsRequired", comment: "")
        }
    }
}
