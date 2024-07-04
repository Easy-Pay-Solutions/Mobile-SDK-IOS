
import Foundation

public enum CreateConsentAnnualValidationError: Error {
    case invalidExpirationMonthLength
    case invalidExpirationYearLength
    case invalidCvvLength
    
    case invalidAccountHolderFirstNameLength
    case invalidAccountHolderLastNameLength
    case invalidAccountHolderCompanyLength
    case invalidAccountHolderPhoneLength
    case invalidAccountHolderEmailLength
    
    case invalidAccountHolderBillingAddress1Length
    case invalidAccountHolderBillingAddress2Length
    case invalidAccountHolderBillingCityLength
    case invalidAccountHolderBillingStateLength
    case invalidAccountHolderBillingZipLength
    case invalidAccountHolderBillingCountryLength
    
    case invalidEndCustomerFirstNameLength
    case invalidEndCustomerLastNameLength
    case invalidEndCustomerCompanyLength
    case invalidEndCustomerPhoneLength
    case invalidEndCustomerEmailLength
    
    case invalidEndCustomerBillingAddress1Length
    case invalidEndCustomerBillingAddress2Length
    case invalidEndCustomerBillingCityLength
    case invalidEndCustomerBillingStateLength
    case invalidEndCustomerBillingZipLength
    case invalidEndCustomerBillingCountryLength
    
    case invalidServiceDescriptionLength
    case invalidCustomerRefIdLength
    case invalidRpguidLength
    
    case invalidCharactersCreditCardNumber
    case invalidCharactersAccountHolderFirstName
    case invalidCharactersAccountHolderLastName
    case invalidCharactersAccountHolderCompany
    case invalidCharactersAccountHolderTitle
    case invalidCharactersAccountHolderUrl
    case invalidCharactersAccountHolderPhone
    case invalidCharactersAccountHolderEmail

    case invalidCharactersAccountHolderAddress1
    case invalidCharactersAccountHolderAddress2
    case invalidCharactersAccountHolderCity
    case invalidCharactersAccountHolderState
    case invalidCharactersAccountHolderZip
    case invalidCharactersAccountHolderCountry

    case invalidCharactersEndCustomerFirstName
    case invalidCharactersEndCustomerLastName
    case invalidCharactersEndCustomerCompany
    case invalidCharactersEndCustomerTitle
    case invalidCharactersEndCustomerUrl
    case invalidCharactersEndCustomerPhone
    case invalidCharactersEndCustomerEmail
    
    case invalidCharactersEndCustomerAddress1
    case invalidCharactersEndCustomerAddress2
    case invalidCharactersEndCustomerCity
    case invalidCharactersEndCustomerState
    case invalidCharactersEndCustomerZip
    case invalidCharactersEndCustomerCountry
    
    case limitPerChargeShouldBeGreaterThanZero
    case limitPerLifetimeShouldBeGreaterThanZero
    
    case invalidCharactersServiceDescription
    case invalidCharactersCustomerRefId
    case invalidCharactersRpguid
    
    case merchantIdIsRequired
    case customerReferenceIdIsRequired
    case creditCardNumberIsRequired
    case cvvIsRequired
    case expMonthIsRequired
    case expYearIsRequired
    case address1IsRequired
    case zipCodeIsRequired
    case limitLifeTimeIsRequired
    case startDateIsRequired
    case limitPerChargeIsRequired
}

extension CreateConsentAnnualValidationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidExpirationMonthLength:
            return NSLocalizedString("invalidExpirationMonthLength", comment: "")
        case .invalidExpirationYearLength:
            return NSLocalizedString("invalidExpirationYearLength", comment: "")
        case .invalidCvvLength:
            return NSLocalizedString("invalidCvvLength", comment: "")
        case .invalidAccountHolderFirstNameLength:
            return NSLocalizedString("invalidAccountHolderFirstNameLength", comment: "")
        case .invalidAccountHolderLastNameLength:
            return NSLocalizedString("invalidAccountHolderLastNameLength", comment: "")
        case .invalidAccountHolderCompanyLength:
            return NSLocalizedString("invalidAccountHolderCompanyLength", comment: "")
        case .invalidAccountHolderPhoneLength:
            return NSLocalizedString("invalidAccountHolderPhoneLength", comment: "")
        case .invalidAccountHolderEmailLength:
            return NSLocalizedString("invalidAccountHolderEmailLength", comment: "")
        case .invalidAccountHolderBillingAddress1Length:
            return NSLocalizedString("invalidAccountHolderBillingAddress1Length", comment: "")
        case .invalidAccountHolderBillingAddress2Length:
            return NSLocalizedString("invalidAccountHolderBillingAddress2Length", comment: "")
        case .invalidAccountHolderBillingCityLength:
            return NSLocalizedString("invalidAccountHolderBillingCityLength", comment: "")
        case .invalidAccountHolderBillingStateLength:
            return NSLocalizedString("invalidAccountHolderBillingStateLength", comment: "")
        case .invalidAccountHolderBillingZipLength:
            return NSLocalizedString("invalidAccountHolderBillingZipLength", comment: "")
        case .invalidAccountHolderBillingCountryLength:
            return NSLocalizedString("invalidAccountHolderBillingCountryLength", comment: "")
        case .invalidEndCustomerFirstNameLength:
            return NSLocalizedString("invalidEndCustomerFirstNameLength", comment: "")
        case .invalidEndCustomerLastNameLength:
            return NSLocalizedString("invalidEndCustomerLastNameLength", comment: "")
        case .invalidEndCustomerCompanyLength:
            return NSLocalizedString("invalidEndCustomerCompanyLength", comment: "")
        case .invalidEndCustomerPhoneLength:
            return NSLocalizedString("invalidEndCustomerPhoneLength", comment: "")
        case .invalidEndCustomerEmailLength:
            return NSLocalizedString("invalidEndCustomerEmailLength", comment: "")
        case .invalidEndCustomerBillingAddress1Length:
            return NSLocalizedString("invalidEndCustomerBillingAddress1Length", comment: "")
        case .invalidEndCustomerBillingAddress2Length:
            return NSLocalizedString("invalidEndCustomerBillingAddress2Length", comment: "")
        case .invalidEndCustomerBillingCityLength:
            return NSLocalizedString("invalidEndCustomerBillingCityLength", comment: "")
        case .invalidEndCustomerBillingStateLength:
            return NSLocalizedString("invalidEndCustomerBillingStateLength", comment: "")
        case .invalidEndCustomerBillingZipLength:
            return NSLocalizedString("invalidEndCustomerBillingZipLength", comment: "")
        case .invalidEndCustomerBillingCountryLength:
            return NSLocalizedString("invalidEndCustomerBillingCountryLength", comment: "")
        case .invalidServiceDescriptionLength:
            return NSLocalizedString("invalidServiceDescriptionLength", comment: "")
        case .invalidCustomerRefIdLength:
            return NSLocalizedString("invalidCustomerRefIdLength", comment: "")
        case .invalidRpguidLength:
            return NSLocalizedString("invalidRpguidLength", comment: "")
        case .invalidCharactersCreditCardNumber:
            return NSLocalizedString("invalidCharactersCreditCardNumber", comment: "")
        case .invalidCharactersAccountHolderFirstName:
            return NSLocalizedString("invalidCharactersAccountHolderFirstName", comment: "")
        case .invalidCharactersAccountHolderLastName:
            return NSLocalizedString("invalidCharactersAccountHolderLastName", comment: "")
        case .invalidCharactersAccountHolderCompany:
            return NSLocalizedString("invalidCharactersAccountHolderCompany", comment: "")
        case .invalidCharactersAccountHolderTitle:
            return NSLocalizedString("invalidCharactersAccountHolderTitle", comment: "")
        case .invalidCharactersAccountHolderUrl:
            return NSLocalizedString("invalidCharactersAccountHolderUrl", comment: "")
        case .invalidCharactersAccountHolderPhone:
            return NSLocalizedString("invalidCharactersAccountHolderPhone", comment: "")
        case .invalidCharactersAccountHolderEmail:
            return NSLocalizedString("invalidCharactersAccountHolderEmail", comment: "")
        case .invalidCharactersAccountHolderAddress1:
            return NSLocalizedString("invalidCharactersAccountHolderAddress1", comment: "")
        case .invalidCharactersAccountHolderAddress2:
            return NSLocalizedString("invalidCharactersAccountHolderAddress2", comment: "")
        case .invalidCharactersAccountHolderCity:
            return NSLocalizedString("invalidCharactersAccountHolderCity", comment: "")
        case .invalidCharactersAccountHolderState:
            return NSLocalizedString("invalidCharactersAccountHolderState", comment: "")
        case .invalidCharactersAccountHolderZip:
            return NSLocalizedString("invalidCharactersAccountHolderZip", comment: "")
        case .invalidCharactersEndCustomerFirstName:
            return NSLocalizedString("invalidCharactersEndCustomerFirstName", comment: "")
        case .invalidCharactersEndCustomerLastName:
            return NSLocalizedString("invalidCharactersEndCustomerLastName", comment: "")
        case .invalidCharactersEndCustomerCompany:
            return NSLocalizedString("invalidCharactersEndCustomerCompany", comment: "")
        case .invalidCharactersEndCustomerTitle:
            return NSLocalizedString("invalidCharactersEndCustomerTitle", comment: "")
        case .invalidCharactersEndCustomerUrl:
            return NSLocalizedString("invalidCharactersEndCustomerUrl", comment: "")
        case .invalidCharactersEndCustomerPhone:
            return NSLocalizedString("invalidCharactersEndCustomerPhone", comment: "")
        case .invalidCharactersEndCustomerEmail:
            return NSLocalizedString("invalidCharactersEndCustomerEmail", comment: "")
        case .invalidCharactersEndCustomerAddress1:
            return NSLocalizedString("invalidCharactersEndCustomerAddress1", comment: "")
        case .invalidCharactersEndCustomerAddress2:
            return NSLocalizedString("invalidCharactersEndCustomerAddress2", comment: "")
        case .invalidCharactersEndCustomerCity:
            return NSLocalizedString("invalidCharactersEndCustomerCity", comment: "")
        case .invalidCharactersEndCustomerState:
            return NSLocalizedString("invalidCharactersEndCustomerState", comment: "")
        case .invalidCharactersEndCustomerZip:
            return NSLocalizedString("invalidCharactersEndCustomerZip", comment: "")
        case .invalidCharactersServiceDescription:
            return NSLocalizedString("invalidCharactersServiceDescription", comment: "")
        case .invalidCharactersCustomerRefId:
            return NSLocalizedString("invalidCharactersCustomerRefId", comment: "")
        case .invalidCharactersRpguid:
            return NSLocalizedString("invalidCharactersRpguid", comment: "")
        case .invalidCharactersAccountHolderCountry:
            return NSLocalizedString("invalidCharactersAccountHolderCountry", comment: "")
        case .invalidCharactersEndCustomerCountry:
            return NSLocalizedString("invalidCharactersEndCustomerCountry", comment: "")
        case .limitPerChargeShouldBeGreaterThanZero:
            return NSLocalizedString("limitPerChargeShouldBeGreaterThanZero", comment: "")
        case .limitPerLifetimeShouldBeGreaterThanZero:
            return NSLocalizedString("limitPerLifetimeShouldBeGreaterThanZero", comment: "")
        case .merchantIdIsRequired:
            return NSLocalizedString("merchantIdIsRequired", comment: "")
        case .customerReferenceIdIsRequired:
            return NSLocalizedString("customerReferenceIdIsRequired", comment: "")
        case .creditCardNumberIsRequired:
            return NSLocalizedString("creditCardNumberIsRequired", comment: "")
        case .cvvIsRequired:
            return NSLocalizedString("cvvIsRequired", comment: "")
        case .expMonthIsRequired:
            return NSLocalizedString("expMonthIsRequired", comment: "")
        case .expYearIsRequired:
            return NSLocalizedString("expYearIsRequired", comment: "")
        case .address1IsRequired:
            return NSLocalizedString("address1IsRequired", comment: "")
        case .zipCodeIsRequired:
            return NSLocalizedString("zipCodeIsRequired", comment: "")
        case .limitLifeTimeIsRequired:
            return NSLocalizedString("limitLifeTimeIsRequired", comment: "")
        case .startDateIsRequired:
            return NSLocalizedString("startDateIsRequired", comment: "")
        case .limitPerChargeIsRequired:
            return NSLocalizedString("limitPerChargeIsRequired", comment: "")
        }
    }
}
