
import Foundation
import EasyPay

class AddAnnualConsentViewModel {
    public init(expirationMonth: String? = nil,
                expirationYear: String? = nil,
                cvv: String? = nil,
                accountHolderFirstName: String? = nil,
                accountHolderLastName: String? = nil,
                accountHolderCompany: String? = nil,
                accountHolderPhone: String? = nil,
                accountHolderEmail: String? = nil,
                endCustomerFirstName: String? = nil,
                endCustomerLastName: String? = nil,
                endCustomerCompany: String? = nil,
                endCustomerPhone: String? = nil,
                endCustomerEmail: String? = nil,
                accountHolderAddress1: String? = nil,
                accountHolderAddress2: String? = nil,
                accountHolderCity: String? = nil,
                accountHolderState: String? = nil,
                accountHolderZip: String? = nil,
                accountHolderCountry: String? = nil,
                endCustomerAddress1: String? = nil,
                endCustomerAddress2: String? = nil,
                endCustomerCity: String? = nil,
                endCustomerState: String? = nil,
                endCustomerZip: String? = nil,
                endCustomerCountry: String? = nil,
                merchantId: String? = nil,
                customerReferenceId: String? = nil,
                serviceDescription: String? = nil,
                rpguid: String? = nil,
                numberOfDays: String? = nil,
                limitPerCharge: String? = nil,
                limitLifetime: String? = nil) {
        self.expirationMonth = expirationMonth
        self.expirationYear = expirationYear
        self.cvv = cvv
        self.accountHolderFirstName = accountHolderFirstName
        self.accountHolderLastName = accountHolderLastName
        self.accountHolderCompany = accountHolderCompany
        self.accountHolderPhone = accountHolderPhone
        self.accountHolderEmail = accountHolderEmail
        self.endCustomerFirstName = endCustomerFirstName
        self.endCustomerLastName = endCustomerLastName
        self.endCustomerCompany = endCustomerCompany
        self.endCustomerPhone = endCustomerPhone
        self.endCustomerEmail = endCustomerEmail
        self.accountHolderAddress1 = accountHolderAddress1
        self.accountHolderAddress2 = accountHolderAddress2
        self.accountHolderCity = accountHolderCity
        self.accountHolderState = accountHolderState
        self.accountHolderZip = accountHolderZip
        self.accountHolderCountry = accountHolderCountry
        self.endCustomerAddress1 = endCustomerAddress1
        self.endCustomerAddress2 = endCustomerAddress2
        self.endCustomerCity = endCustomerCity
        self.endCustomerState = endCustomerState
        self.endCustomerZip = endCustomerZip
        self.endCustomerCountry = endCustomerCountry
        self.merchantId = merchantId
        self.customerReferenceId = customerReferenceId
        self.serviceDescription = serviceDescription
        self.rpguid = rpguid
        self.limitPerCharge = limitPerCharge
        self.limitLifetime = limitLifetime
    }
    
    var accountNumber: String?
    var expirationMonth: String?
    var expirationYear: String?
    var cvv: String?
    
    var accountHolderFirstName: String?
    var accountHolderLastName: String?
    var accountHolderCompany: String?
    var accountHolderPhone: String?
    var accountHolderEmail: String?
    
    var endCustomerFirstName: String?
    var endCustomerLastName: String?
    var endCustomerCompany: String?
    var endCustomerPhone: String?
    var endCustomerEmail: String?
    
    var accountHolderAddress1: String?
    var accountHolderAddress2: String?
    var accountHolderCity: String?
    var accountHolderState: String?
    var accountHolderZip: String?
    var accountHolderCountry: String?
    
    var endCustomerAddress1: String?
    var endCustomerAddress2: String?
    var endCustomerCity: String?
    var endCustomerState: String?
    var endCustomerZip: String?
    var endCustomerCountry: String?
    
    var merchantId: String?
    var customerReferenceId: String?
    var serviceDescription: String?
    var rpguid: String?
    var startDate: Date = Date()
    var limitPerCharge: String?
    var limitLifetime: String?
    
    public func areEndCustomerEmptyFields() -> Bool {
        return StringUtils.isNilOrEmpty(endCustomerFirstName) &&
        StringUtils.isNilOrEmpty(endCustomerLastName) &&
        StringUtils.isNilOrEmpty(endCustomerCompany) &&
        StringUtils.isNilOrEmpty(endCustomerPhone) &&
        StringUtils.isNilOrEmpty(endCustomerEmail) &&
        StringUtils.isNilOrEmpty(endCustomerAddress1) &&
        StringUtils.isNilOrEmpty(endCustomerAddress2) &&
        StringUtils.isNilOrEmpty(endCustomerCity) &&
        StringUtils.isNilOrEmpty(endCustomerState) &&
        StringUtils.isNilOrEmpty(endCustomerZip) &&
        StringUtils.isNilOrEmpty(endCustomerCountry)
    }
    
    func createAnnualConsent(_ completion: @escaping (Result<CreateConsentAnnualResponse, Error>) -> Void) {
        let request = CreateConsentAnnualRequest(createConsentAnnualRequest: prepareData())
        EasyPay.shared.apiClient.createAnnualConsent(request: request) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    public func prepareData() -> CreateConsentAnnualManualRequestModel {
        var endCustomerConverted: CreateConsentAnnualManualRequestModel.AnnualEndCustomer?
        if areEndCustomerEmptyFields() {
            endCustomerConverted = nil
        } else {
            endCustomerConverted = CreateConsentAnnualManualRequestModel.AnnualEndCustomer(
                firstName: StringUtils.trimmingEmptyOrWhitespace(endCustomerFirstName),
                lastName: StringUtils.trimmingEmptyOrWhitespace(endCustomerLastName),
                company: StringUtils.trimmingEmptyOrWhitespace(endCustomerCompany),
                billingAddress: CreateConsentAnnualManualRequestModel.AnnualEndCustomerBillingAddress(
                    address1: StringUtils.trimmingEmptyOrWhitespace(endCustomerAddress1),
                    address2: StringUtils.trimmingEmptyOrWhitespace(endCustomerAddress2),
                    city: StringUtils.trimmingEmptyOrWhitespace(endCustomerCity),
                    state: StringUtils.trimmingEmptyOrWhitespace(endCustomerState),
                    zip: StringUtils.trimmingEmptyOrWhitespace(endCustomerZip),
                    country: StringUtils.trimmingEmptyOrWhitespace(endCustomerCountry)),
                email: StringUtils.trimmingEmptyOrWhitespace(endCustomerEmail),
                phone: StringUtils.trimmingEmptyOrWhitespace(endCustomerPhone))
        }
        
        let data = CreateConsentAnnualManualRequestModel(
            creditCardInfo: CreditCardInfo(
                accountNumber: StringUtils.trimmingEmptyOrWhitespace(accountNumber) ?? "",
                expirationMonth: Int(expirationMonth ?? ""),
                expirationYear: Int(expirationYear ?? ""),
                cvv: StringUtils.trimmingEmptyOrWhitespace(cvv) ?? ""),
            consentAnnualCreate: CreateConsentAnnual(
                merchID: Int(merchantId ?? ""),
                customerRefID: StringUtils.trimmingEmptyOrWhitespace(customerReferenceId) ?? "",
                serviceDescrip: StringUtils.trimmingEmptyOrWhitespace(serviceDescription),
                rpguid: StringUtils.trimmingEmptyOrWhitespace(rpguid),
                startDate: convertDate(startDate),
                limitPerCharge: convertDecimalFormatting(limitPerCharge),
                limitLifeTime: convertDecimalFormatting(limitLifetime)),
            accountHolder: AccountHolder(
                firstName: StringUtils.trimmingEmptyOrWhitespace(accountHolderFirstName) ?? "",
                lastName: StringUtils.trimmingEmptyOrWhitespace(accountHolderLastName) ?? "",
                company: StringUtils.trimmingEmptyOrWhitespace(accountHolderCompany),
                billingAddress: BillingAddress(
                    address1: StringUtils.trimmingEmptyOrWhitespace(accountHolderAddress1) ?? "",
                    address2: StringUtils.trimmingEmptyOrWhitespace(accountHolderAddress2),
                    city: StringUtils.trimmingEmptyOrWhitespace(accountHolderCity),
                    state: StringUtils.trimmingEmptyOrWhitespace(accountHolderState),
                    zip: StringUtils.trimmingEmptyOrWhitespace(accountHolderZip) ?? "",
                    country: StringUtils.trimmingEmptyOrWhitespace(accountHolderCountry)),
                email: StringUtils.trimmingEmptyOrWhitespace(accountHolderEmail),
                phone: StringUtils.trimmingEmptyOrWhitespace(accountHolderPhone)),
            endCustomer: endCustomerConverted)
        return data
    }
    
    private func convertDecimalFormatting(_ string: String?) -> String {
        guard let string = string else { return "" }
        return string.replacingOccurrences(of: ",", with: ".")
    }
    
    private func convertDate(_ date: Date) -> String {
        let epochTime = Int(date.timeIntervalSince1970) * 1000
        return #"/Date(\#(epochTime))/"#
    }
}
