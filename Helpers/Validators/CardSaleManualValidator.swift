
import Foundation

public class CardSaleManualValidator: Validator {
    var transaction: TransactionRequest
    
    init(dataToValidate: TransactionRequest) {
        self.transaction = dataToValidate
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
    
    private let serviceDescriptionMaxLength = 200
    private let clientRefIdMaxLength = 75
    private let rpguidMaxLength = 75
    
    var isEndCustomerEmpty: Bool {
        return transaction.endCustomer == nil
    }
    
    var checkExpMonthLength: Bool {
        return ValidatorUtils.checkMaxLimit(String(transaction.creditCardInfo.expirationMonth ?? 0), maxLimit: expirationMonthMaxLength)
    }
    
    var checkExpYearLength: Bool {
        return ValidatorUtils.checkMaxLimit(String(transaction.creditCardInfo.expirationYear ?? 0), maxLimit: expirationYearMaxLength)
    }
    
    var checkCvvLength: Bool {
        return ValidatorUtils.checkMaxLimit(transaction.creditCardInfo.cvv, maxLimit: cvvMaxLength)
    }
    
    var accountHolderFirstNameLength: Bool {
        return ValidatorUtils.checkMaxLimit(transaction.accountHolder.firstName, maxLimit: accountHolderFirstNameMaxLength)
    }
    
    var accountHolderLastNameLength: Bool {
        return ValidatorUtils.checkMaxLimit(transaction.accountHolder.lastName, maxLimit: accountHolderLastNameMaxLength)
    }
    
    var accountHolderCompanyLength: Bool {
        return ValidatorUtils.checkMaxLimit(transaction.accountHolder.company ?? "", maxLimit: accountHolderCompanyMaxLength)
    }
    
    var accountHolderPhoneLength: Bool {
        return ValidatorUtils.checkMaxLimit(transaction.accountHolder.phone ?? "", maxLimit: accountHolderPhoneMaxLength)
    }
    
    var accountHolderEmailLength: Bool {
        return ValidatorUtils.checkMaxLimit(transaction.accountHolder.email ?? "", maxLimit: accountHolderEmailMaxLength)
    }
    
    var accountHolderBillingAddress1Length: Bool {
        return ValidatorUtils.checkMaxLimit(transaction.accountHolder.billingAddress.address1, maxLimit: accountHolderBillingAddress1MaxLength)
    }
    
    var accountHolderBillingAddress2Length: Bool {
        return ValidatorUtils.checkMaxLimit(transaction.accountHolder.billingAddress.address2 ?? "", maxLimit: accountHolderBillingAddress2MaxLength)
    }
    
    var accountHolderBillingCityLength: Bool {
        return ValidatorUtils.checkMaxLimit(transaction.accountHolder.billingAddress.city ?? "", maxLimit: accountHolderBillingCityMaxLength)
    }
    
    var accountHolderBillingStateLength: Bool {
        return ValidatorUtils.checkMaxLimit(transaction.accountHolder.billingAddress.state ?? "", maxLimit: accountHolderBillingStateMaxLength)
    }
    
    var accountHolderBillingZipLength: Bool {
        return ValidatorUtils.checkMaxLimit(transaction.accountHolder.billingAddress.zip, maxLimit: accountHolderBillingZipMaxLength)
    }
    
    var accountHolderBillingCountryLength: Bool {
        return ValidatorUtils.checkMaxLimit(transaction.accountHolder.billingAddress.country ?? "", maxLimit: accountHolderBillingCountryMaxLength)
    }
    
    var endCustomerFirstNameLength: Bool {
        return ValidatorUtils.checkMaxLimit(transaction.endCustomer?.firstName ?? "", maxLimit: endCustomerFirstNameMaxLength)
    }

    var endCustomerLastNameLength: Bool {
        return ValidatorUtils.checkMaxLimit(transaction.endCustomer?.lastName ?? "", maxLimit: endCustomerLastNameMaxLength)
    }

    var endCustomerCompanyLength: Bool {
        return ValidatorUtils.checkMaxLimit(transaction.endCustomer?.company ?? "", maxLimit: endCustomerCompanyMaxLength)
    }

    var endCustomerPhoneLength: Bool {
        return ValidatorUtils.checkMaxLimit(transaction.endCustomer?.phone ?? "", maxLimit: endCustomerPhoneMaxLength)
    }

    var endCustomerEmailLength: Bool {
        return ValidatorUtils.checkMaxLimit(transaction.endCustomer?.email ?? "", maxLimit: endCustomerEmailMaxLength)
    }

    var endCustomerBillingAddress1Length: Bool {
        return ValidatorUtils.checkMaxLimit(transaction.endCustomer?.billingAddress?.address1 ?? "", maxLimit: endCustomerBillingAddress1MaxLength)
    }

    var endCustomerBillingAddress2Length: Bool {
        return ValidatorUtils.checkMaxLimit(transaction.endCustomer?.billingAddress?.address2 ?? "", maxLimit: endCustomerBillingAddress2MaxLength)
    }

    var endCustomerBillingCityLength: Bool {
        return ValidatorUtils.checkMaxLimit(transaction.endCustomer?.billingAddress?.city ?? "", maxLimit: endCustomerBillingCityMaxLength)
    }

    var endCustomerBillingStateLength: Bool {
        return ValidatorUtils.checkMaxLimit(transaction.endCustomer?.billingAddress?.state ?? "", maxLimit: endCustomerBillingStateMaxLength)
    }

    var endCustomerBillingZipLength: Bool {
        return ValidatorUtils.checkMaxLimit(transaction.endCustomer?.billingAddress?.zip ?? "", maxLimit: endCustomerBillingZipMaxLength)
    }

    var endCustomerBillingCountryLength: Bool {
        return ValidatorUtils.checkMaxLimit(transaction.endCustomer?.billingAddress?.country ?? "", maxLimit: endCustomerBillingCountryMaxLength)
    }
    
    var purchaseItemsServiceDescriptionLength: Bool {
        return ValidatorUtils.checkMaxLimit(transaction.purchItems.serviceDescription ?? "", maxLimit: serviceDescriptionMaxLength)
    }
    
    var purchaseItemsClientRefIdLength: Bool {
        return ValidatorUtils.checkMaxLimit(transaction.purchItems.clientRefId ?? "", maxLimit: clientRefIdMaxLength)
    }
    
    var purchaseItemsRpguidLength: Bool {
        return ValidatorUtils.checkMaxLimit(transaction.purchItems.rpguid ?? "", maxLimit: rpguidMaxLength)
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
        if transaction.merchantId == nil {
            return (CreditCardInfoValidationError.merchantIdIsRequired, false)
        }
        if StringUtils.isNilOrEmpty(transaction.creditCardInfo.accountNumber) {
            return (CreditCardInfoValidationError.creditCardNumberIsRequired, false)
        }
        if StringUtils.isNilOrEmpty(transaction.creditCardInfo.cvv) {
            return (CreditCardInfoValidationError.cvvIsRequired, false)
        }
        if transaction.creditCardInfo.expirationMonth == nil {
            return (CreditCardInfoValidationError.expMonthIsRequired, false)
        }
        if transaction.creditCardInfo.expirationYear == nil {
            return (CreditCardInfoValidationError.expYearIsRequired, false)
        }
        if StringUtils.isNilOrEmpty(transaction.accountHolder.billingAddress.address1) {
            return (CreditCardInfoValidationError.address1IsRequired, false)
        }
        if StringUtils.isNilOrEmpty(transaction.amounts.totalAmount) {
            return (CreditCardInfoValidationError.totalAmountIsRequired, false)
        }
        if StringUtils.isNilOrEmpty(transaction.accountHolder.billingAddress.zip) {
            return (CreditCardInfoValidationError.zipCodeIsRequired, false)
        }
        return (nil, true)
    }
    
    private func checkFieldsValidation() -> (Error?, Bool) {
        if !ValidatorUtils.isValidFirstAndLastName(transaction.accountHolder.firstName) {
            return (CreditCardInfoValidationError.invalidCharactersAccountHolderFirstName, false)
        }
        if !ValidatorUtils.isValidFirstAndLastName(transaction.accountHolder.lastName) {
            return (CreditCardInfoValidationError.invalidCharactersAccountHolderLastName, false)
        }
        if let companyAccountHolder = transaction.accountHolder.company, !StringUtils.isNilOrEmpty(companyAccountHolder) {
            if !ValidatorUtils.isValidCompany(companyAccountHolder) {
                return (CreditCardInfoValidationError.invalidCharactersAccountHolderCompany, false)
            }
        }
        if let phoneAccountHolder = transaction.accountHolder.phone, !StringUtils.isNilOrEmpty(phoneAccountHolder) {
            if !ValidatorUtils.containsOnlyNumbers(phoneAccountHolder) {
                return (CreditCardInfoValidationError.invalidCharactersAccountHolderPhone, false)
            }
        }
        if let emailAccountHolder = transaction.accountHolder.email, !StringUtils.isNilOrEmpty(emailAccountHolder) {
            if !ValidatorUtils.isValidEmail(emailAccountHolder) {
                return (CreditCardInfoValidationError.invalidCharactersAccountHolderEmail, false)
            }
        }
        if !ValidatorUtils.isValidAddress(transaction.accountHolder.billingAddress.address1) {
            return (CreditCardInfoValidationError.invalidCharactersAccountHolderAddress1, false)
        }
        if let address2AccountHolder = transaction.accountHolder.billingAddress.address2, !StringUtils.isNilOrEmpty(address2AccountHolder) {
            if !ValidatorUtils.isValidAddress(address2AccountHolder) {
                return (CreditCardInfoValidationError.invalidCharactersAccountHolderAddress2, false)
            }
        }
        if let cityAccountHolder = transaction.accountHolder.billingAddress.city, !StringUtils.isNilOrEmpty(cityAccountHolder) {
            if !ValidatorUtils.isValidCity(cityAccountHolder) {
                return (CreditCardInfoValidationError.invalidCharactersAccountHolderCity, false)
            }
        }
        if let stateAccountHolder = transaction.accountHolder.billingAddress.state, !StringUtils.isNilOrEmpty(stateAccountHolder) {
            if !ValidatorUtils.isValidStateOrCountry(stateAccountHolder) {
                return (CreditCardInfoValidationError.invalidCharactersAccountHolderState, false)
            }
        }
        if let countryAccountHolder = transaction.accountHolder.billingAddress.country, !StringUtils.isNilOrEmpty(countryAccountHolder) {
            if !ValidatorUtils.isValidStateOrCountry(countryAccountHolder) {
                return (CreditCardInfoValidationError.invalidCharactersAccountHolderCountry, false)
            }
        }
        if !ValidatorUtils.isValidZipCode(transaction.accountHolder.billingAddress.zip) {
            return (CreditCardInfoValidationError.invalidCharactersAccountHolderZip, false)
        }
        
        if let endCustomer = transaction.endCustomer {
            if let endCustomerFirstName = endCustomer.firstName, !StringUtils.isNilOrEmpty(endCustomerFirstName) {
                if !ValidatorUtils.isValidFirstAndLastName(endCustomerFirstName) {
                    return (CreditCardInfoValidationError.invalidCharactersEndCustomerFirstName, false)
                }
            }
            if let endCustomerLastName = endCustomer.lastName, !StringUtils.isNilOrEmpty(endCustomerLastName) {
                if !ValidatorUtils.isValidFirstAndLastName(endCustomerLastName) {
                    return (CreditCardInfoValidationError.invalidCharactersEndCustomerLastName, false)
                }
            }
            if let endCustomerCompany = endCustomer.company, !StringUtils.isNilOrEmpty(endCustomerCompany) {
                if !ValidatorUtils.isValidCompany(endCustomerCompany) {
                    return (CreditCardInfoValidationError.invalidCharactersEndCustomerCompany, false)
                }
            }
            if let phoneEndCustomer = endCustomer.phone, !StringUtils.isNilOrEmpty(phoneEndCustomer) {
                if !ValidatorUtils.containsOnlyNumbers(phoneEndCustomer) {
                    return (CreditCardInfoValidationError.invalidCharactersEndCustomerPhone, false)
                }
            }
            if let emailEndCustomer = endCustomer.email, !StringUtils.isNilOrEmpty(emailEndCustomer) {
                if !ValidatorUtils.isValidEmail(emailEndCustomer) {
                    return (CreditCardInfoValidationError.invalidCharactersEndCustomerEmail, false)
                }
            }
            if let address1EndCustomer = endCustomer.billingAddress?.address1, !StringUtils.isNilOrEmpty(address1EndCustomer) {
                if !ValidatorUtils.isValidAddress(address1EndCustomer) {
                    return (CreditCardInfoValidationError.invalidCharactersEndCustomerAddress1, false)
                }
            }
            if let address2EndCustomer = endCustomer.billingAddress?.address2, !StringUtils.isNilOrEmpty(address2EndCustomer) {
                if !ValidatorUtils.isValidAddress(address2EndCustomer) {
                    return (CreditCardInfoValidationError.invalidCharactersEndCustomerAddress2, false)
                }
            }
            if let cityEndCustomer = endCustomer.billingAddress?.city, !StringUtils.isNilOrEmpty(cityEndCustomer) {
                if !ValidatorUtils.isValidCity(cityEndCustomer) {
                    return (CreditCardInfoValidationError.invalidCharactersEndCustomerCity, false)
                }
            }
            if let stateEndCustomer = endCustomer.billingAddress?.state, !StringUtils.isNilOrEmpty(stateEndCustomer) {
                if !ValidatorUtils.isValidStateOrCountry(stateEndCustomer) {
                    return (CreditCardInfoValidationError.invalidCharactersEndCustomerState, false)
                }
            }
            if let countryEndCustomer = endCustomer.billingAddress?.country, !StringUtils.isNilOrEmpty(countryEndCustomer) {
                if !ValidatorUtils.isValidStateOrCountry(countryEndCustomer) {
                    return (CreditCardInfoValidationError.invalidCharactersEndCustomerCountry, false)
                }
            }
            if let zipEndCustomer = endCustomer.billingAddress?.zip, !StringUtils.isNilOrEmpty(zipEndCustomer) {
                if !ValidatorUtils.isValidZipCode(zipEndCustomer) {
                    return (CreditCardInfoValidationError.invalidCharactersEndCustomerZip, false)
                }
            }
        }
        let totalAmount = isValidCurrencyAmount(transaction.amounts.totalAmount).double
        if totalAmount < 0 {
            return (CreditCardInfoValidationError.totalAmountShouldBeGreaterThanZero, false)
        }
        if let salesAmountString = transaction.amounts.salesAmount {
            let salesAmount = isValidCurrencyAmount(salesAmountString).double
            if salesAmount < 0 {
                return (CreditCardInfoValidationError.salesAmountShouldBeGreaterThanZero, false)
            }
        }
        
        if let surchargeAmountString = transaction.amounts.surcharge {
            let surchargeAmount = isValidCurrencyAmount(surchargeAmountString).double
            if surchargeAmount < 0 {
                return (CreditCardInfoValidationError.surchargeAmountShouldBeGreaterThanZero, false)
            }
        }
    
        if let serviceDescription = transaction.purchItems.serviceDescription, !StringUtils.isNilOrEmpty(serviceDescription) {
            if !ValidatorUtils.isValidServiceDescription(serviceDescription) {
                return (CreditCardInfoValidationError.invalidCharactersServiceDescription, false)
            }
        }
        if let clientReferenceId = transaction.purchItems.clientRefId, !StringUtils.isNilOrEmpty(clientReferenceId) {
            if !ValidatorUtils.isValidClientRefIdOrRpguid(clientReferenceId) {
                return (CreditCardInfoValidationError.invalidCharactersClientRefId, false)
            }
        }
        if let rpguid = transaction.purchItems.rpguid, !StringUtils.isNilOrEmpty(rpguid) {
            if !ValidatorUtils.isValidClientRefIdOrRpguid(rpguid) {
                return (CreditCardInfoValidationError.invalidCharactersRpguid, false)
            }
        }
        return (nil, true)
    }
    
    private func checkMaxLength() -> (Error?, Bool) {
        if !checkExpMonthLength {
            return (CreditCardInfoValidationError.invalidExpirationMonthLength, false)
        }
        if !checkExpYearLength {
            return (CreditCardInfoValidationError.invalidExpirationYearLength, false)
        }
        if !checkCvvLength {
            return (CreditCardInfoValidationError.invalidCvvLength, false)
        }
        if !accountHolderFirstNameLength {
            return (CreditCardInfoValidationError.invalidAccountHolderFirstNameLength, false)
        }
        if !accountHolderLastNameLength {
            return (CreditCardInfoValidationError.invalidAccountHolderLastNameLength, false)
        }
        if !accountHolderCompanyLength {
            return (CreditCardInfoValidationError.invalidAccountHolderCompanyLength, false)
        }
        if !accountHolderPhoneLength {
            return (CreditCardInfoValidationError.invalidAccountHolderPhoneLength, false)
        }
        if !accountHolderEmailLength {
            return (CreditCardInfoValidationError.invalidAccountHolderEmailLength, false)
        }
        if !accountHolderBillingAddress1Length {
            return (CreditCardInfoValidationError.invalidAccountHolderBillingAddress1Length, false)
        }
        if !accountHolderBillingAddress2Length {
            return (CreditCardInfoValidationError.invalidAccountHolderBillingAddress2Length, false)
        }
        if !accountHolderBillingCityLength {
            return (CreditCardInfoValidationError.invalidAccountHolderBillingCityLength, false)
        }
        if !accountHolderBillingStateLength {
            return (CreditCardInfoValidationError.invalidAccountHolderBillingStateLength, false)
        }
        if !accountHolderBillingZipLength {
            return (CreditCardInfoValidationError.invalidAccountHolderBillingZipLength, false)
        }
        if !accountHolderBillingCountryLength {
            return (CreditCardInfoValidationError.invalidAccountHolderBillingCountryLength, false)
        }
        
        if !isEndCustomerEmpty {
            if !endCustomerFirstNameLength {
                return (CreditCardInfoValidationError.invalidEndCustomerFirstNameLength, false)
            }
            if !endCustomerLastNameLength {
                return (CreditCardInfoValidationError.invalidEndCustomerLastNameLength, false)
            }
            if !endCustomerCompanyLength {
                return (CreditCardInfoValidationError.invalidEndCustomerCompanyLength, false)
            }
            if !endCustomerPhoneLength {
                return (CreditCardInfoValidationError.invalidEndCustomerPhoneLength, false)
            }
            if !endCustomerEmailLength {
                return (CreditCardInfoValidationError.invalidEndCustomerEmailLength, false)
            }
            if !endCustomerBillingAddress1Length {
                return (CreditCardInfoValidationError.invalidEndCustomerBillingAddress1Length, false)
            }
            if !endCustomerBillingAddress2Length {
                return (CreditCardInfoValidationError.invalidEndCustomerBillingAddress2Length, false)
            }
            if !endCustomerBillingCityLength {
                return (CreditCardInfoValidationError.invalidEndCustomerBillingCityLength, false)
            }
            if !endCustomerBillingStateLength {
                return (CreditCardInfoValidationError.invalidEndCustomerBillingStateLength, false)
            }
            if !endCustomerBillingZipLength {
                return (CreditCardInfoValidationError.invalidEndCustomerBillingZipLength, false)
            }
            if !endCustomerBillingCountryLength {
                return (CreditCardInfoValidationError.invalidEndCustomerBillingCountryLength, false)
            }
        }
        
        if !purchaseItemsServiceDescriptionLength {
            return (CreditCardInfoValidationError.invalidServiceDescriptionLength, false)
        }
        if !purchaseItemsClientRefIdLength {
            return (CreditCardInfoValidationError.invalidClientRefIdLength, false)
        }
        if !purchaseItemsRpguidLength {
            return (CreditCardInfoValidationError.invalidRpguidLength, false)
        }
        return (nil, true)
    }
    
    private func isValidCurrencyAmount(_ currencyStr: String) -> (Bool, double: Double) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        if let number = formatter.number(from: currencyStr), number.doubleValue > 0 {
            return (true, number.doubleValue)
        } else {
            return (false, 0.0)
        }
    }
}
