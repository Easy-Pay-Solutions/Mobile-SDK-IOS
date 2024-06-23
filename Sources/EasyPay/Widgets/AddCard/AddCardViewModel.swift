
import Foundation
import EasyPay

public class AddCardViewModel {
    public init(state: AddCardState, amount: String, paymentDetails: AddAnnualConsentWidgetModel) {
        self.state = state
        self.amount = amount
        self.paymentDetails = paymentDetails
    }
    
    let state: AddCardState
    let amount: String
    private let paymentDetails: AddAnnualConsentWidgetModel
    
    var cardholerName: String?
    var cardNumber: String?
    var monthYear: String?
    var cvc: String?
    var address: String?
    var zip: String?
    var shouldSaveCard = false
    
    var saveCardErrorShown = false
    var payCardErrorShown = false

    let cardHolderMaxChar = 75
    lazy var cardHolderMaxCharMessage = replaceMaxChar(withLimit: cardHolderMaxChar)
    var cardholerHintShown = false
    var cardholerErrorShown = false
    
    let cardNumberMaxChar = 19
    var cardNumberErrorShown = false
    let cardRangeLength = 15...16
    
    var monthYearErrorShown = false
    var cvcErrorShown = false
    
    let cvcMaxChar = 4
    let monthYeatMaxChar = 5

    let zipMaxChar = 20
    lazy var zipMaxCharMessage = replaceMaxChar(withLimit: zipMaxChar)
    var zipHintShown = false
    var zipErrorShown = false
    
    let addressMaxChar = 100
    lazy var addressMaxCharMessage = replaceMaxChar(withLimit: addressMaxChar)
    var addressHintShown = false
    var addressErrorShown = false
    
    func canEnableButton() -> Bool {
        return isCardNumberCorrect() &&
        !isCardNumberEmptyNilWhitespace() &&
        !isCardholerNameEmptyNilWhitespace() &&
        isCardholerNameCorrect() &&
        !isCardNumberEmptyNilWhitespace() &&
        !isMonthYearEmptyNilWhitespace() &&
        isValidMonthYearFormat() &&
        isCvcCorrect() &&
        !isCvcEmptyNilWhitespace() &&
        isAddressCorrect() &&
        !isAddressEmptyNilWhitespace() &&
        isZipCorrect() &&
        !isZipEmptyNilWhitespace()
    }
    
    func shouldShowCardholderHint() -> Bool {
        cardholerName?.count == cardHolderMaxChar
    }
    
    func shouldShowAddressHint() -> Bool {
        address?.count == addressMaxChar
    }
    
    func shouldShowZipHint() -> Bool {
        zip?.count == zipMaxChar
    }
    
    func isCardholerNameCorrect() -> Bool {
        UIValidation.isValidFirstName(cardholerName ?? "")
    }
    
    func isCardNumberCorrect() -> Bool {
        18...19 ~= cardNumber?.trimmingCharacters(in: .whitespaces).count ?? 0
    }
    
    func applyMaskOnCard(cardNumber: String?) -> String {
        guard let text = cardNumber else { return "" }
        return text.applyPatternOnNumbers(pattern: "#### #### #### ####", replacementCharacter: "#")
    }
    
    func isCardholerNameEmptyNilWhitespace() -> Bool {
        isTextEmptyNilWhitespace(cardholerName)
    }
    
    func isCardNumberEmptyNilWhitespace() -> Bool {
        isTextEmptyNilWhitespace(cardNumber)
    }
    
    func isAddressEmptyNilWhitespace() -> Bool {
        isTextEmptyNilWhitespace(address)
    }
    
    func isAddressCorrect() -> Bool {
        UIValidation.isValidAdress(address ?? "")
    }
    
    func isZipEmptyNilWhitespace() -> Bool {
        isTextEmptyNilWhitespace(zip)
    }
    
    func isZipCorrect() -> Bool {
        ValidatorUtils.isValidZipCode(zip ?? "")
    }
    
    func isCvcCorrect() -> Bool {
        3...4 ~= cvc?.trimmingCharacters(in: .whitespaces).count ?? 0
    }
    
    func isCvcEmptyNilWhitespace() -> Bool {
        isTextEmptyNilWhitespace(cvc)
    }
    
    func isMonthYearEmptyNilWhitespace() -> Bool {
        isTextEmptyNilWhitespace(monthYear)
    }
    
    func isValidMonthYearFormat() -> Bool {
        let input = monthYear ?? ""
        let pattern = "^[0-9]{2}/[0-9]{2}$"
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: input.utf16.count)
        if let match = regex.firstMatch(in: input, options: [], range: range) {
            let monthString = input.prefix(2)
            if let month = Int(monthString), month >= 1 && month <= 12 && input.count == 5 {
                return true
            }
        }
        return false
    }

    func isMonthYearNotExpired() -> Bool {
        let monthYear = monthYear ?? ""
        let dateComponents = monthYear.split(separator: "/")
        guard dateComponents.count == 2,
              let month = Int(dateComponents[0]),
              let year = Int(dateComponents[1]) else {
            return false
        }

        let date = Date()
        let currentYear = Calendar.current.component(.year, from: date) % 100
        let currentMonth = Calendar.current.component(.month, from: date)

        if year < currentYear {
            return false
        } else if year == currentYear && month < currentMonth {
            return false
        }
        return month >= 1 && month <= 12
    }
    
    private func firstTwoCharacters(of string: String) -> String? {
        guard string.count >= 2 else { return nil }
        let startIndex = string.startIndex
        let endIndex = string.index(startIndex, offsetBy: 2)
        return String(string[startIndex..<endIndex])
    }
    
    private func lastTwoCharacters(of string: String) -> String? {
        guard string.count >= 2 else { return nil }
        let endIndex = string.endIndex
        let startIndex = string.index(endIndex, offsetBy: -2)
        return String(string[startIndex..<endIndex])
    }
    
    private func convertDate(_ date: Date) -> String {
        let epochTime = Int(date.timeIntervalSince1970) * 1000
        return #"/Date(\#(epochTime))/"#
    }
    
    private func convertDecimalFormatting(_ string: String?) -> String {
        guard let string = string else { return "0.0" }
        return string.replacingOccurrences(of: ",", with: ".")
    }
    
    private func replaceMaxChar(withLimit charLimit: Int) -> String {
        return Localization.templateMaxCharMessage.replacingOccurrences(of: "{charLimit}", with: "\(charLimit)")
    }
    
    private func isTextEmptyNilWhitespace(_ text: String?) -> Bool {
        guard let text = text else { return true }
        if text.isEmpty {
            return true
        } else if isStringOnlyWhitespaces(text) {
            return true
        } else {
            return false
        }
    }
    
    func isStringOnlyWhitespaces(_ text: String) -> Bool {
        text.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    func chargeAnnualConsent(consentId: Int,
                             _ completion: @escaping (Result<ProcessPaymentAnnualResponse, Error>) -> Void) {
        let convertedProcessAmount = convertDecimalFormatting(amount)
        let request = ProcessPaymentAnnualRequest(processPaymentAnnualRequest: ProcessPaymentAnnualRequestModel(consentId: consentId, processAmount: convertedProcessAmount))
        EasyPay.shared.apiClient.processPaymentAnnualConsent(request: request) { result in
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
    
    func createAnnualConsent(_ completion: @escaping (Result<CreateConsentAnnualResponse, Error>) -> Void) {
        let request = CreateConsentAnnualRequest(createConsentAnnualRequest: prepareData(model: paymentDetails))
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
    
    public func areEndCustomerEmptyFields(model: AddAnnualConsentWidgetModel) -> Bool {
        return StringUtils.isNilOrEmpty(model.endCustomerFirstName) &&
        StringUtils.isNilOrEmpty(model.endCustomerLastName) &&
        StringUtils.isNilOrEmpty(model.endCustomerCompany) &&
        StringUtils.isNilOrEmpty(model.endCustomerPhone) &&
        StringUtils.isNilOrEmpty(model.endCustomerEmail) &&
        StringUtils.isNilOrEmpty(model.endCustomerAddress1) &&
        StringUtils.isNilOrEmpty(model.endCustomerAddress2) &&
        StringUtils.isNilOrEmpty(model.endCustomerCity) &&
        StringUtils.isNilOrEmpty(model.endCustomerState) &&
        StringUtils.isNilOrEmpty(model.endCustomerZip) &&
        StringUtils.isNilOrEmpty(model.endCustomerCountry)
    }
    
    public func prepareData(model: AddAnnualConsentWidgetModel) -> CreateConsentAnnualManualRequestModel {
        var endCustomerConverted: CreateConsentAnnualManualRequestModel.AnnualEndCustomer?
        if areEndCustomerEmptyFields(model: paymentDetails) {
            endCustomerConverted = nil
        } else {
            endCustomerConverted = CreateConsentAnnualManualRequestModel.AnnualEndCustomer(
                firstName: StringUtils.trimmingEmptyOrWhitespace(model.endCustomerFirstName),
                lastName: StringUtils.trimmingEmptyOrWhitespace(model.endCustomerLastName),
                company: StringUtils.trimmingEmptyOrWhitespace(model.endCustomerCompany),
                billingAddress: CreateConsentAnnualManualRequestModel.AnnualEndCustomerBillingAddress(
                    address1: StringUtils.trimmingEmptyOrWhitespace(model.endCustomerAddress1),
                    address2: StringUtils.trimmingEmptyOrWhitespace(model.endCustomerAddress2),
                    city: StringUtils.trimmingEmptyOrWhitespace(model.endCustomerCity),
                    state: StringUtils.trimmingEmptyOrWhitespace(model.endCustomerState),
                    zip: StringUtils.trimmingEmptyOrWhitespace(model.endCustomerZip),
                    country: StringUtils.trimmingEmptyOrWhitespace(model.endCustomerCountry)),
                email: StringUtils.trimmingEmptyOrWhitespace(model.endCustomerEmail),
                phone: StringUtils.trimmingEmptyOrWhitespace(model.endCustomerPhone))
        }
        
        let data = CreateConsentAnnualManualRequestModel(
            creditCardInfo: CreditCardInfo(
                accountNumber: EasyPay.shared.encryptCardData(cardNumber: cardNumber ?? "") ?? "",
                expirationMonth: Int(firstTwoCharacters(of: monthYear ?? "") ?? "") ?? 0,
                expirationYear: Int(lastTwoCharacters(of: monthYear ?? "") ?? "") ?? 0,
                cvv: StringUtils.trimmingEmptyOrWhitespace(cvc) ?? ""),
            consentAnnualCreate: CreateConsentAnnual(
                merchID: Int(model.merchantId),
                customerRefID: StringUtils.trimmingEmptyOrWhitespace(model.customerReferenceId),
                serviceDescrip: StringUtils.trimmingEmptyOrWhitespace(model.serviceDescription),
                rpguid: StringUtils.trimmingEmptyOrWhitespace(model.rpguid),
                startDate: convertDate(model.startDate ?? Date()),
                limitPerCharge: convertDecimalFormatting(model.limitPerCharge),
                limitLifeTime: convertDecimalFormatting(model.limitLifetime)),
            accountHolder: AccountHolder(
                firstName: StringUtils.trimmingEmptyOrWhitespace(cardholerName) ?? "",
                lastName: "",
                company: StringUtils.trimmingEmptyOrWhitespace(model.accountHolderCompany),
                billingAddress: BillingAddress(
                    address1: StringUtils.trimmingEmptyOrWhitespace(address) ?? "",
                    address2: StringUtils.trimmingEmptyOrWhitespace(model.accountHolderAddress2),
                    city: StringUtils.trimmingEmptyOrWhitespace(model.accountHolderCity),
                    state: StringUtils.trimmingEmptyOrWhitespace(model.accountHolderState),
                    zip: StringUtils.trimmingEmptyOrWhitespace(zip) ?? "",
                    country: StringUtils.trimmingEmptyOrWhitespace(model.accountHolderCountry)),
                email: StringUtils.trimmingEmptyOrWhitespace(model.accountHolderEmail),
                phone: StringUtils.trimmingEmptyOrWhitespace(model.accountHolderPhone)),
            endCustomer: endCustomerConverted)
        return data
    }
    
    public func prepareData(model: AddAnnualConsentWidgetModel) -> TransactionRequest {
        var endCustomerConverted: EndCustomer?
        if areEndCustomerEmptyFields(model: paymentDetails){
            endCustomerConverted = nil
        } else {
            endCustomerConverted = EndCustomer(firstName: StringUtils.trimmingEmptyOrWhitespace(model.endCustomerFirstName),
                                               lastName: StringUtils.trimmingEmptyOrWhitespace(model.endCustomerLastName),
                                               company: StringUtils.trimmingEmptyOrWhitespace(model.endCustomerCompany),
                                               billingAddress: EndCustomerBillingAddress(
                                                address1: StringUtils.trimmingEmptyOrWhitespace(model.endCustomerAddress1),
                                                address2: StringUtils.trimmingEmptyOrWhitespace(model.endCustomerAddress2),
                                                city: StringUtils.trimmingEmptyOrWhitespace(model.endCustomerCity),
                                                state: StringUtils.trimmingEmptyOrWhitespace(model.endCustomerState),
                                                zip: StringUtils.trimmingEmptyOrWhitespace(model.endCustomerZip),
                                                country: StringUtils.trimmingEmptyOrWhitespace(model.endCustomerCountry)),
                                               email: StringUtils.trimmingEmptyOrWhitespace(model.endCustomerEmail),
                                               phone: StringUtils.trimmingEmptyOrWhitespace(model.endCustomerPhone))
        }
        
        let data = TransactionRequest(
            creditCardInfo: CreditCardInfo(
                accountNumber: EasyPay.shared.encryptCardData(cardNumber: cardNumber ?? "") ?? "",
                expirationMonth: Int(firstTwoCharacters(of: monthYear ?? "") ?? "") ?? 0,
                expirationYear: Int(lastTwoCharacters(of: monthYear ?? "") ?? "") ?? 0,
                cvv: StringUtils.trimmingEmptyOrWhitespace(cvc) ?? ""),
            accountHolder: AccountHolder(
                firstName: StringUtils.trimmingEmptyOrWhitespace(cardholerName) ?? "",
                lastName: "",
                company: StringUtils.trimmingEmptyOrWhitespace(model.accountHolderCompany),
                billingAddress: BillingAddress(
                    address1: StringUtils.trimmingEmptyOrWhitespace(address) ?? "",
                    address2: StringUtils.trimmingEmptyOrWhitespace(model.accountHolderAddress2),
                    city: StringUtils.trimmingEmptyOrWhitespace(model.accountHolderCity),
                    state: StringUtils.trimmingEmptyOrWhitespace(model.accountHolderState),
                    zip: StringUtils.trimmingEmptyOrWhitespace(zip) ?? "",
                    country: StringUtils.trimmingEmptyOrWhitespace(model.accountHolderCountry)),
                email: StringUtils.trimmingEmptyOrWhitespace(model.accountHolderEmail),
                phone: StringUtils.trimmingEmptyOrWhitespace(model.accountHolderPhone)),
            endCustomer: endCustomerConverted,
            amounts: Amounts(totalAmount: convertDecimalFormatting(amount),
                             salesAmount: "0",
                             surcharge: "0"),
            purchItems: PurchItems(
                serviceDescription: StringUtils.trimmingEmptyOrWhitespace(model.serviceDescription),
                clientRefId: StringUtils.trimmingEmptyOrWhitespace(model.customerReferenceId),
                rpguid: StringUtils.trimmingEmptyOrWhitespace(model.rpguid)),
                             merchantId: Int(model.merchantId))
        return data
    }
    
    func chargeCard(_ completion: @escaping (Result<CreditCardSaleResponse, Error>) -> Void) {
        let request = CardSaleManualRequest(transactionRequest: prepareData(model: paymentDetails))
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
}
