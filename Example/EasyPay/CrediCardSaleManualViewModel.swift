
import Foundation
import EasyPay

class CrediCardSaleManualViewModel {
    public init(merchantId: String? = nil,
                expirationMonth: String? = nil,
                expirationYear: String? = nil,
                cvv: String? = nil,
                accountHolderFirstName: String? = nil,
                accountHolderLastName: String? = nil,
                accountHolderCompany: String? = nil,
                accountHolderPhone: String? = nil,
                accountHolderEmail: String? = nil,
                accountHolderAddress1: String? = nil,
                accountHolderAddress2: String? = nil,
                accountHolderCity: String? = nil,
                accountHolderState: String? = nil,
                accountHolderZip: String? = nil,
                accountHolderCountry: String? = nil,
                endCustomerFirstName: String? = nil,
                endCustomerLastName: String? = nil,
                endCustomerCompany: String? = nil,
                endCustomerPhone: String? = nil,
                endCustomerEmail: String? = nil,
                endCustomerAddress1: String? = nil,
                endCustomerAddress2: String? = nil,
                endCustomerCity: String? = nil,
                endCustomerState: String? = nil,
                endCustomerZip: String? = nil,
                endCustomerCountry: String? = nil,
                totalAmount: String? = nil,
                salesAmount: String? = nil,
                surcharge: String? = nil,
                serviceDescription: String? = nil,
                clientRefId: String? = nil,
                rpguid: String? = nil) {
        self.merchantId = merchantId
        self.expirationMonth = expirationMonth
        self.expirationYear = expirationYear
        self.cvv = cvv
        self.accountHolderFirstName = accountHolderFirstName
        self.accountHolderLastName = accountHolderLastName
        self.accountHolderCompany = accountHolderCompany
        self.accountHolderPhone = accountHolderPhone
        self.accountHolderEmail = accountHolderEmail
        self.accountHolderAddress1 = accountHolderAddress1
        self.accountHolderAddress2 = accountHolderAddress2
        self.accountHolderCity = accountHolderCity
        self.accountHolderState = accountHolderState
        self.accountHolderZip = accountHolderZip
        self.accountHolderCountry = accountHolderCountry
        self.endCustomerFirstName = endCustomerFirstName
        self.endCustomerLastName = endCustomerLastName
        self.endCustomerCompany = endCustomerCompany
        self.endCustomerPhone = endCustomerPhone
        self.endCustomerEmail = endCustomerEmail
        self.endCustomerAddress1 = endCustomerAddress1
        self.endCustomerAddress2 = endCustomerAddress2
        self.endCustomerCity = endCustomerCity
        self.endCustomerState = endCustomerState
        self.endCustomerZip = endCustomerZip
        self.endCustomerCountry = endCustomerCountry
        self.totalAmount = totalAmount
        self.salesAmount = salesAmount
        self.surcharge = surcharge
        self.serviceDescription = serviceDescription
        self.clientRefId = clientRefId
        self.rpguid = rpguid
    }
    
    var merchantId: String?
    var accountNumber: String? //credit card number
    var expirationMonth: String?
    var expirationYear: String?
    var cvv: String?
    
    var accountHolderFirstName: String?
    var accountHolderLastName: String?
    var accountHolderCompany: String?
    var accountHolderPhone: String?
    var accountHolderEmail: String?
    
    var accountHolderAddress1: String?
    var accountHolderAddress2: String?
    var accountHolderCity: String?
    var accountHolderState: String?
    var accountHolderZip: String?
    var accountHolderCountry: String?
        
    var endCustomerFirstName: String?
    var endCustomerLastName: String?
    var endCustomerCompany: String?
    var endCustomerPhone: String?
    var endCustomerEmail: String?
    
    var endCustomerAddress1: String?
    var endCustomerAddress2: String?
    var endCustomerCity: String?
    var endCustomerState: String?
    var endCustomerZip: String?
    var endCustomerCountry: String?
        
    var totalAmount: String?
    var salesAmount: String?
    var surcharge: String?
    
    var serviceDescription: String?
    var clientRefId: String?
    var rpguid: String?
        
    private func convertDecimalFormatting(_ string: String?) -> String {
        guard let string = string else { return "" }
        return string.replacingOccurrences(of: ",", with: ".")
    }
    
    private func convertNonRequiredFieldDecimalFormatting(_ string: String?) -> String {
        guard let string = string else { return "0.0" }
        let replaced = string.replacingOccurrences(of: ",", with: ".")
        return StringUtils.trimmingEmptyOrWhitespace(replaced) ?? "0.0"
    }
    
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
    
    public func prepareData() -> TransactionRequest {
        var endCustomerConverted: EndCustomer?
        if areEndCustomerEmptyFields() {
            endCustomerConverted = nil
        } else {
            endCustomerConverted = EndCustomer(firstName: StringUtils.trimmingEmptyOrWhitespace(endCustomerFirstName),
                                               lastName: StringUtils.trimmingEmptyOrWhitespace(endCustomerLastName),
                                               company: StringUtils.trimmingEmptyOrWhitespace(endCustomerCompany),
                                               billingAddress: EndCustomerBillingAddress(
                                                address1: StringUtils.trimmingEmptyOrWhitespace(endCustomerAddress1),
                                                address2: StringUtils.trimmingEmptyOrWhitespace(endCustomerAddress2),
                                                city: StringUtils.trimmingEmptyOrWhitespace(endCustomerCity),
                                                state: StringUtils.trimmingEmptyOrWhitespace(endCustomerState),
                                                zip: StringUtils.trimmingEmptyOrWhitespace(endCustomerZip),
                                                country: StringUtils.trimmingEmptyOrWhitespace(endCustomerCountry)),
                                               email: StringUtils.trimmingEmptyOrWhitespace(endCustomerEmail),
                                               phone: StringUtils.trimmingEmptyOrWhitespace(endCustomerPhone))
        }
        
        let data = TransactionRequest(
            creditCardInfo: CreditCardInfo(
                accountNumber: StringUtils.trimmingEmptyOrWhitespace(accountNumber) ?? "",
                expirationMonth: Int(expirationMonth ?? ""),
                expirationYear: Int(expirationYear ?? ""),
                cvv: StringUtils.trimmingEmptyOrWhitespace(cvv) ?? ""),
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
            endCustomer: endCustomerConverted,
            amounts: Amounts(totalAmount: convertDecimalFormatting(totalAmount),
                             salesAmount: convertNonRequiredFieldDecimalFormatting(salesAmount),
                             surcharge: convertNonRequiredFieldDecimalFormatting(surcharge)),
            purchItems: PurchItems(
                serviceDescription: StringUtils.trimmingEmptyOrWhitespace(serviceDescription),
                clientRefId: StringUtils.trimmingEmptyOrWhitespace(clientRefId),
                rpguid: StringUtils.trimmingEmptyOrWhitespace(rpguid)),
            merchantId: Int(merchantId ?? ""))
        return data
    }
    
    func chargeCard(_ completion: @escaping (Result<CreditCardSaleResponse, Error>) -> Void) {
        let request = CardSaleManualRequest(transactionRequest: prepareData())
        EasyPay.shared.apiClient.chargeCreditCard(request: request) { result in
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
    
    func downloadCertificate(_ completion: @escaping (Result<Data, Error>) -> Void) {
        EasyPay.shared.apiClient.downloadManuallyCertificate { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
