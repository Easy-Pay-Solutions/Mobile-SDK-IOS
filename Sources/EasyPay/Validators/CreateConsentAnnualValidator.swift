
import Foundation

public class CreateConsentAnnualValidator: Validator {
    var consentAnnual: CreateConsentAnnualManualRequestModel
    
    init(dataToValidate: CreateConsentAnnualManualRequestModel) {
        self.consentAnnual = dataToValidate
    }
    
    override func validate(_ request: BaseRequest) -> (Error?, Bool) {
        return checkFieldsCharactersAndLength()
    }
    
    private let expirationMonthMaxLength = 2
    private let expirationYearMaxLength = 4
    private let cvvMaxLength = 4
    
    private let accountHolderFirstNameMaxLength = 75
    private let accountHolderLastNameMaxLength = 75
    private let accountHolderCompanyMaxLength = 100
    private let accountHolderPhoneMaxLength = 16
    private let accountHolderEmailMaxLength = 150
    
    private let accountHolderBillingAddress1MaxLength = 100
    private let accountHolderBillingAddress2MaxLength = 100
    private let accountHolderBillingCityMaxLength = 75
    private let accountHolderBillingStateMaxLength = 75
    private let accountHolderBillingZipMaxLength  = 20
    private let accountHolderBillingCountryMaxLength = 75
    
    private let endCustomerFirstNameMaxLength = 75
    private let endCustomerLastNameMaxLength = 75
    private let endCustomerCompanyMaxLength = 100
    private let endCustomerPhoneMaxLength = 16
    private let endCustomerEmailMaxLength = 150
    
    private let endCustomerBillingAddress1MaxLength = 100
    private let endCustomerBillingAddress2MaxLength = 100
    private let endCustomerBillingCityMaxLength = 75
    private let endCustomerBillingStateMaxLength = 75
    private let endCustomerBillingZipMaxLength = 20
    private let endCustomerBillingCountryMaxLength = 75
    
    private let clientRefIdMaxLength = 75
    private let serviceDescriptionMaxLength = 200
    private let rpguidMaxLength = 75
    
    var isEndCustomerEmpty: Bool {
        return consentAnnual.endCustomer == nil
    }
    
    var checkExpMonthLength: Bool {
        return ValidatorUtils.checkMaxLimit(String(consentAnnual.creditCardInfo.expirationMonth ?? 0), maxLimit: expirationMonthMaxLength)
    }
    
    var checkExpYearLength: Bool {
        return ValidatorUtils.checkMaxLimit(String(consentAnnual.creditCardInfo.expirationYear ?? 0), maxLimit: expirationYearMaxLength)
    }
    
    var checkCvvLength: Bool {
        return ValidatorUtils.checkMaxLimit(consentAnnual.creditCardInfo.cvv, maxLimit: cvvMaxLength)
    }
    
    var accountHolderFirstNameLength: Bool {
        return ValidatorUtils.checkMaxLimit(consentAnnual.accountHolder.firstName, maxLimit: accountHolderFirstNameMaxLength)
    }
    
    var accountHolderLastNameLength: Bool {
        return ValidatorUtils.checkMaxLimit(consentAnnual.accountHolder.lastName, maxLimit: accountHolderLastNameMaxLength)
    }
    
    var accountHolderCompanyLength: Bool {
        return ValidatorUtils.checkMaxLimit(consentAnnual.accountHolder.company ?? "", maxLimit: accountHolderCompanyMaxLength)
    }
    
    var accountHolderPhoneLength: Bool {
        return ValidatorUtils.checkMaxLimit(consentAnnual.accountHolder.phone ?? "", maxLimit: accountHolderPhoneMaxLength)
    }
    
    var accountHolderEmailLength: Bool {
        return ValidatorUtils.checkMaxLimit(consentAnnual.accountHolder.email ?? "", maxLimit: accountHolderEmailMaxLength)
    }
    
    var accountHolderBillingAddress1Length: Bool {
        return ValidatorUtils.checkMaxLimit(consentAnnual.accountHolder.billingAddress.address1, maxLimit: accountHolderBillingAddress1MaxLength)
    }
    
    var accountHolderBillingAddress2Length: Bool {
        return ValidatorUtils.checkMaxLimit(consentAnnual.accountHolder.billingAddress.address2 ?? "", maxLimit: accountHolderBillingAddress2MaxLength)
    }
    
    var accountHolderBillingCityLength: Bool {
        return ValidatorUtils.checkMaxLimit(consentAnnual.accountHolder.billingAddress.city ?? "", maxLimit: accountHolderBillingCityMaxLength)
    }
    
    var accountHolderBillingStateLength: Bool {
        return ValidatorUtils.checkMaxLimit(consentAnnual.accountHolder.billingAddress.state ?? "", maxLimit: accountHolderBillingStateMaxLength)
    }
    
    var accountHolderBillingZipLength: Bool {
        return ValidatorUtils.checkMaxLimit(consentAnnual.accountHolder.billingAddress.zip, maxLimit: accountHolderBillingZipMaxLength)
    }
    
    var accountHolderBillingCountryLength: Bool {
        return ValidatorUtils.checkMaxLimit(consentAnnual.accountHolder.billingAddress.country ?? "", maxLimit: accountHolderBillingCountryMaxLength)
    }
    
    var endCustomerFirstNameLength: Bool {
        return ValidatorUtils.checkMaxLimit(consentAnnual.endCustomer?.firstName ?? "", maxLimit: endCustomerFirstNameMaxLength)
    }

    var endCustomerLastNameLength: Bool {
        return ValidatorUtils.checkMaxLimit(consentAnnual.endCustomer?.lastName ?? "", maxLimit: endCustomerLastNameMaxLength)
    }

    var endCustomerCompanyLength: Bool {
        return ValidatorUtils.checkMaxLimit(consentAnnual.endCustomer?.company ?? "", maxLimit: endCustomerCompanyMaxLength)
    }

    var endCustomerPhoneLength: Bool {
        return ValidatorUtils.checkMaxLimit(consentAnnual.endCustomer?.phone ?? "", maxLimit: endCustomerPhoneMaxLength)
    }

    var endCustomerEmailLength: Bool {
        return ValidatorUtils.checkMaxLimit(consentAnnual.endCustomer?.email ?? "", maxLimit: endCustomerEmailMaxLength)
    }

    var endCustomerBillingAddress1Length: Bool {
        return ValidatorUtils.checkMaxLimit(consentAnnual.endCustomer?.billingAddress?.address1 ?? "", maxLimit: endCustomerBillingAddress1MaxLength)
    }

    var endCustomerBillingAddress2Length: Bool {
        return ValidatorUtils.checkMaxLimit(consentAnnual.endCustomer?.billingAddress?.address2 ?? "", maxLimit: endCustomerBillingAddress2MaxLength)
    }

    var endCustomerBillingCityLength: Bool {
        return ValidatorUtils.checkMaxLimit(consentAnnual.endCustomer?.billingAddress?.city ?? "", maxLimit: endCustomerBillingCityMaxLength)
    }

    var endCustomerBillingStateLength: Bool {
        return ValidatorUtils.checkMaxLimit(consentAnnual.endCustomer?.billingAddress?.state ?? "", maxLimit: endCustomerBillingStateMaxLength)
    }

    var endCustomerBillingZipLength: Bool {
        return ValidatorUtils.checkMaxLimit(consentAnnual.endCustomer?.billingAddress?.zip ?? "", maxLimit: endCustomerBillingZipMaxLength)
    }

    var endCustomerBillingCountryLength: Bool {
        return ValidatorUtils.checkMaxLimit(consentAnnual.endCustomer?.billingAddress?.country ?? "", maxLimit: endCustomerBillingCountryMaxLength)
    }
    
    var purchaseItemsServiceDescriptionLength: Bool {
        return ValidatorUtils.checkMaxLimit(consentAnnual.consentAnnualCreate.serviceDescrip ?? "", maxLimit: serviceDescriptionMaxLength)
    }
    
    var purchaseItemsCustomerRefIdLength: Bool {
        return ValidatorUtils.checkMaxLimit(consentAnnual.consentAnnualCreate.customerRefID, maxLimit: clientRefIdMaxLength)
    }
    
    var purchaseItemsRpguidLength: Bool {
        return ValidatorUtils.checkMaxLimit(consentAnnual.consentAnnualCreate.rpguid ?? "", maxLimit: rpguidMaxLength)
    }
    
    public func checkFieldsCharactersAndLength () -> (Error?, Bool) {
        let checkRequiredFieldsValidation = checkRequiredFieldsValidation()
        let checkFieldsValidationResult = checkFieldsValidation()
        
        if checkRequiredFieldsValidation.0 != nil {
            return checkRequiredFieldsValidation
        }
        
        if checkFieldsValidationResult.0 != nil {
            return checkFieldsValidationResult
        }
        
        if checkFieldsValidationResult.0 == nil {
            return checkMaxLength()
        }
        return (nil, true)
    }
    
    private func checkRequiredFieldsValidation() -> (Error?, Bool) {
        if consentAnnual.consentAnnualCreate.merchID == nil {
            return (CreateConsentAnnualValidationError.merchantIdIsRequired, false)
        }
        if StringUtils.isNilOrEmpty(consentAnnual.creditCardInfo.accountNumber) {
            return (CreateConsentAnnualValidationError.creditCardNumberIsRequired, false)
        }
        if StringUtils.isNilOrEmpty(consentAnnual.creditCardInfo.cvv) {
            return (CreateConsentAnnualValidationError.cvvIsRequired, false)
        }
        if consentAnnual.creditCardInfo.expirationMonth == nil {
            return (CreateConsentAnnualValidationError.expMonthIsRequired, false)
        }
        if consentAnnual.creditCardInfo.expirationYear == nil {
            return (CreateConsentAnnualValidationError.expYearIsRequired, false)
        }
        if StringUtils.isNilOrEmpty(consentAnnual.accountHolder.billingAddress.address1) {
            return (CreateConsentAnnualValidationError.address1IsRequired, false)
        }
        if StringUtils.isNilOrEmpty(consentAnnual.accountHolder.billingAddress.zip) {
            return (CreateConsentAnnualValidationError.zipCodeIsRequired, false)
        }
        if StringUtils.isNilOrEmpty(consentAnnual.consentAnnualCreate.limitLifeTime) {
            return (CreateConsentAnnualValidationError.limitLifeTimeIsRequired, false)
        }
        if StringUtils.isNilOrEmpty(consentAnnual.consentAnnualCreate.startDate) {
            return (CreateConsentAnnualValidationError.startDateIsRequired, false)
        }
        if StringUtils.isNilOrEmpty(consentAnnual.consentAnnualCreate.limitPerCharge) {
            return (CreateConsentAnnualValidationError.limitPerChargeIsRequired, false)
        }
        if StringUtils.isNilOrEmpty(consentAnnual.consentAnnualCreate.customerRefID) {
            return (CreateConsentAnnualValidationError.customerReferenceIdIsRequired, false)
        }
        return (nil, true)
    }
    
    private func checkFieldsValidation() -> (Error?, Bool) {
        if !ValidatorUtils.isValidFirstAndLastName(consentAnnual.accountHolder.firstName) {
            return (CreateConsentAnnualValidationError.invalidCharactersAccountHolderFirstName, false)
        }
        if !ValidatorUtils.isValidFirstAndLastName(consentAnnual.accountHolder.lastName) {
            return (CreateConsentAnnualValidationError.invalidCharactersAccountHolderLastName, false)
        }
        if let companyAccountHolder = consentAnnual.accountHolder.company, !StringUtils.isNilOrEmpty(companyAccountHolder) {
            if !ValidatorUtils.isValidCompany(companyAccountHolder) {
                return (CreateConsentAnnualValidationError.invalidCharactersAccountHolderCompany, false)
            }
        }
        if let phoneAccountHolder = consentAnnual.accountHolder.phone, !StringUtils.isNilOrEmpty(phoneAccountHolder) {
            if !ValidatorUtils.containsOnlyNumbers(phoneAccountHolder) {
                return (CreateConsentAnnualValidationError.invalidCharactersAccountHolderPhone, false)
            }
        }
        if let emailAccountHolder = consentAnnual.accountHolder.email, !StringUtils.isNilOrEmpty(emailAccountHolder) {
            if !ValidatorUtils.isValidEmail(emailAccountHolder) {
                return (CreateConsentAnnualValidationError.invalidCharactersAccountHolderEmail, false)
            }
        }
        if !ValidatorUtils.isValidAddress(consentAnnual.accountHolder.billingAddress.address1) {
            return (CreateConsentAnnualValidationError.invalidCharactersAccountHolderAddress1, false)
        }
        if let address2AccountHolder = consentAnnual.accountHolder.billingAddress.address2, !StringUtils.isNilOrEmpty(address2AccountHolder) {
            if !ValidatorUtils.isValidAddress(address2AccountHolder) {
                return (CreateConsentAnnualValidationError.invalidCharactersAccountHolderAddress2, false)
            }
        }
        if let cityAccountHolder = consentAnnual.accountHolder.billingAddress.city, !StringUtils.isNilOrEmpty(cityAccountHolder) {
            if !ValidatorUtils.isValidCity(cityAccountHolder) {
                return (CreateConsentAnnualValidationError.invalidCharactersAccountHolderCity, false)
            }
        }
        if let stateAccountHolder = consentAnnual.accountHolder.billingAddress.state, !StringUtils.isNilOrEmpty(stateAccountHolder) {
            if !ValidatorUtils.isValidStateOrCountry(stateAccountHolder) {
                return (CreateConsentAnnualValidationError.invalidCharactersAccountHolderState, false)
            }
        }
        if let countryAccountHolder = consentAnnual.accountHolder.billingAddress.country, !StringUtils.isNilOrEmpty(countryAccountHolder) {
            if !ValidatorUtils.isValidStateOrCountry(countryAccountHolder) {
                return (CreateConsentAnnualValidationError.invalidCharactersAccountHolderCountry, false)
            }
        }
        if !ValidatorUtils.isValidZipCode(consentAnnual.accountHolder.billingAddress.zip) {
            return (CreateConsentAnnualValidationError.invalidCharactersAccountHolderZip, false)
        }
        
        if let endCustomer = consentAnnual.endCustomer {
            if let endCustomerFirstName = endCustomer.firstName, !StringUtils.isNilOrEmpty(endCustomerFirstName) {
                if !ValidatorUtils.isValidFirstAndLastName(endCustomerFirstName) {
                    return (CreateConsentAnnualValidationError.invalidCharactersEndCustomerFirstName, false)
                }
            }
            if let endCustomerLastName = endCustomer.lastName, !StringUtils.isNilOrEmpty(endCustomerLastName) {
                if !ValidatorUtils.isValidFirstAndLastName(endCustomerLastName) {
                    return (CreateConsentAnnualValidationError.invalidCharactersEndCustomerLastName, false)
                }
            }
            if let endCustomerCompany = endCustomer.company, !StringUtils.isNilOrEmpty(endCustomerCompany) {
                if !ValidatorUtils.isValidCompany(endCustomerCompany) {
                    return (CreateConsentAnnualValidationError.invalidCharactersEndCustomerCompany, false)
                }
            }
            if let phoneEndCustomer = endCustomer.phone, !StringUtils.isNilOrEmpty(phoneEndCustomer) {
                if !ValidatorUtils.containsOnlyNumbers(phoneEndCustomer) {
                    return (CreateConsentAnnualValidationError.invalidCharactersEndCustomerPhone, false)
                }
            }
            if let emailEndCustomer = endCustomer.email, !StringUtils.isNilOrEmpty(emailEndCustomer) {
                if !ValidatorUtils.isValidEmail(emailEndCustomer) {
                    return (CreateConsentAnnualValidationError.invalidCharactersEndCustomerEmail, false)
                }
            }
            if let address1EndCustomer = endCustomer.billingAddress?.address1, !StringUtils.isNilOrEmpty(address1EndCustomer) {
                if !ValidatorUtils.isValidAddress(address1EndCustomer) {
                    return (CreateConsentAnnualValidationError.invalidCharactersEndCustomerAddress1, false)
                }
            }
            if let address2EndCustomer = endCustomer.billingAddress?.address2, !StringUtils.isNilOrEmpty(address2EndCustomer) {
                if !ValidatorUtils.isValidAddress(address2EndCustomer) {
                    return (CreateConsentAnnualValidationError.invalidCharactersEndCustomerAddress2, false)
                }
            }
            if let cityEndCustomer = endCustomer.billingAddress?.city, !StringUtils.isNilOrEmpty(cityEndCustomer) {
                if !ValidatorUtils.isValidCity(cityEndCustomer) {
                    return (CreateConsentAnnualValidationError.invalidCharactersEndCustomerCity, false)
                }
            }
            if let stateEndCustomer = endCustomer.billingAddress?.state, !StringUtils.isNilOrEmpty(stateEndCustomer) {
                if !ValidatorUtils.isValidStateOrCountry(stateEndCustomer) {
                    return (CreateConsentAnnualValidationError.invalidCharactersEndCustomerState, false)
                }
            }
            if let countryEndCustomer = endCustomer.billingAddress?.country, !StringUtils.isNilOrEmpty(countryEndCustomer) {
                if !ValidatorUtils.isValidStateOrCountry(countryEndCustomer) {
                    return (CreateConsentAnnualValidationError.invalidCharactersEndCustomerCountry, false)
                }
            }
            if let zipEndCustomer = endCustomer.billingAddress?.zip, !StringUtils.isNilOrEmpty(zipEndCustomer) {
                if !ValidatorUtils.isValidZipCode(zipEndCustomer) {
                    return (CreateConsentAnnualValidationError.invalidCharactersEndCustomerZip, false)
                }
            }
        }
        if let serviceDescription = consentAnnual.consentAnnualCreate.serviceDescrip, !StringUtils.isNilOrEmpty(serviceDescription) {
            if !ValidatorUtils.isValidServiceDescription(serviceDescription) {
                return (CreateConsentAnnualValidationError.invalidCharactersServiceDescription, false)
            }
        }
        if !ValidatorUtils.isValidClientRefIdOrRpguid(consentAnnual.consentAnnualCreate.customerRefID) {
            return (CreateConsentAnnualValidationError.invalidCharactersCustomerRefId, false)
        }
        if let rpguid = consentAnnual.consentAnnualCreate.rpguid, !StringUtils.isNilOrEmpty(rpguid) {
            if !ValidatorUtils.isValidClientRefIdOrRpguid(rpguid) {
                return (CreateConsentAnnualValidationError.invalidCharactersRpguid, false)
            }
        }
        
        let limitPerCharge = Double(consentAnnual.consentAnnualCreate.limitPerCharge) ?? 0
        if limitPerCharge <= 0 {
            return (CreateConsentAnnualValidationError.limitPerChargeShouldBeGreaterThanZero, false)
        }
        
        let limitPerLifetime = Double(consentAnnual.consentAnnualCreate.limitLifeTime) ?? 0
        if limitPerLifetime <= 0 {
            return (CreateConsentAnnualValidationError.limitPerLifetimeShouldBeGreaterThanZero, false)
        }
        return (nil, true)
    }
    
    private func checkMaxLength() -> (Error?, Bool) {
        if !checkExpMonthLength {
            return (CreateConsentAnnualValidationError.invalidExpirationMonthLength, false)
        }
        if !checkExpYearLength {
            return (CreateConsentAnnualValidationError.invalidExpirationYearLength, false)
        }
        if !checkCvvLength {
            return (CreateConsentAnnualValidationError.invalidCvvLength, false)
        }
        if !accountHolderFirstNameLength {
            return (CreateConsentAnnualValidationError.invalidAccountHolderFirstNameLength, false)
        }
        if !accountHolderLastNameLength {
            return (CreateConsentAnnualValidationError.invalidAccountHolderLastNameLength, false)
        }
        if !accountHolderCompanyLength {
            return (CreateConsentAnnualValidationError.invalidAccountHolderCompanyLength, false)
        }
        if !accountHolderPhoneLength {
            return (CreateConsentAnnualValidationError.invalidAccountHolderPhoneLength, false)
        }
        if !accountHolderEmailLength {
            return (CreateConsentAnnualValidationError.invalidAccountHolderEmailLength, false)
        }
        if !accountHolderBillingAddress1Length {
            return (CreateConsentAnnualValidationError.invalidAccountHolderBillingAddress1Length, false)
        }
        if !accountHolderBillingAddress2Length {
            return (CreateConsentAnnualValidationError.invalidAccountHolderBillingAddress2Length, false)
        }
        if !accountHolderBillingCityLength {
            return (CreateConsentAnnualValidationError.invalidAccountHolderBillingCityLength, false)
        }
        if !accountHolderBillingStateLength {
            return (CreateConsentAnnualValidationError.invalidAccountHolderBillingStateLength, false)
        }
        if !accountHolderBillingZipLength {
            return (CreateConsentAnnualValidationError.invalidAccountHolderBillingZipLength, false)
        }
        if !accountHolderBillingCountryLength {
            return (CreateConsentAnnualValidationError.invalidAccountHolderBillingCountryLength, false)
        }
        
        if !isEndCustomerEmpty {
            if !endCustomerFirstNameLength {
                return (CreateConsentAnnualValidationError.invalidEndCustomerFirstNameLength, false)
            }
            if !endCustomerLastNameLength {
                return (CreateConsentAnnualValidationError.invalidEndCustomerLastNameLength, false)
            }
            if !endCustomerCompanyLength {
                return (CreateConsentAnnualValidationError.invalidEndCustomerCompanyLength, false)
            }
            if !endCustomerPhoneLength {
                return (CreateConsentAnnualValidationError.invalidEndCustomerPhoneLength, false)
            }
            if !endCustomerEmailLength {
                return (CreateConsentAnnualValidationError.invalidEndCustomerEmailLength, false)
            }
            if !endCustomerBillingAddress1Length {
                return (CreateConsentAnnualValidationError.invalidEndCustomerBillingAddress1Length, false)
            }
            if !endCustomerBillingAddress2Length {
                return (CreateConsentAnnualValidationError.invalidEndCustomerBillingAddress2Length, false)
            }
            if !endCustomerBillingCityLength {
                return (CreateConsentAnnualValidationError.invalidEndCustomerBillingCityLength, false)
            }
            if !endCustomerBillingStateLength {
                return (CreateConsentAnnualValidationError.invalidEndCustomerBillingStateLength, false)
            }
            if !endCustomerBillingZipLength {
                return (CreateConsentAnnualValidationError.invalidEndCustomerBillingZipLength, false)
            }
            if !endCustomerBillingCountryLength {
                return (CreateConsentAnnualValidationError.invalidEndCustomerBillingCountryLength, false)
            }
        }
        
        if !purchaseItemsServiceDescriptionLength {
            return (CreateConsentAnnualValidationError.invalidServiceDescriptionLength, false)
        }
        if !purchaseItemsCustomerRefIdLength {
            return (CreateConsentAnnualValidationError.invalidCustomerRefIdLength, false)
        }
        if !purchaseItemsRpguidLength {
            return (CreateConsentAnnualValidationError.invalidRpguidLength, false)
        }
        return (nil, true)
    }
}
