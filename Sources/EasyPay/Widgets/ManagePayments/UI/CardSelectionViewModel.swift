
import Foundation
import EasyPay

public class CardSelectionViewModel {
    
    let state: ManageCardState
    let merchantId: String
    let amount: String
    let preselectedCardId: Int?
    var selectedIndex = -1
    var annualConsents: ConsentAnnualListingResponseModel? = nil
    let paymentDetails: AddAnnualConsentWidgetModel
    
    var isPreselected: Bool {
        return preselectedCardId != nil && findPreselectedCardIndex() != nil
    }

    public init(state: ManageCardState, amount: String, preselectedCardId: Int?, paymentDetails: AddAnnualConsentWidgetModel) {
        self.state = state
        self.merchantId = paymentDetails.merchantId
        self.amount = amount
        self.preselectedCardId = preselectedCardId
        self.paymentDetails = paymentDetails
    }
    
    func downloadAnnualConsents(completion: @escaping (Result<ListingConsentAnnualResponse, Error>) -> Void) {
        let queryHelper = AnnualQueryHelper(merchantId: merchantId,
                                            customerReferenceId: nil,
                                            endDate: nil)
        let request = ConsentAnnualListingRequest(consentAnnualListingRequest: ConsentAnnualListingRequestModel(query: queryHelper))
        EasyPay.shared.apiClient.listAnnualConsents(request: request) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.annualConsents = response.data
                    if let preSelectedIndex = self.findPreselectedCardIndex() {
                        self.selectedIndex = preSelectedIndex + 1
                    }
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func findPreselectedCardIndex() -> Int? {
        if let annualConsents = annualConsents?.consents {
            return annualConsents.firstIndex(where: { $0.id == preselectedCardId })
        }
        return nil
    }
    
    func selectedCardConsentId() -> Int? {
        if let annualConsents = annualConsents?.consents {
            return safeIndexAccess(array: annualConsents, index: selectedIndex - 1)?.id
        }
        return nil
    }
    
    func findCollectionViewIndex() -> Int {
        if let preselectedIndex = findPreselectedCardIndex() {
            return preselectedIndex + 1
        }
        return -1
    }
    
    func deleteAnnualConsent(consentId: Int, _ completion: @escaping (Result<CancelConsentAnnualResponse, Error>) -> Void) {
        let request = CancelConsentAnnualRequest(cancelConsentAnnualRequest: CancelConsentAnnualManualRequestModel(consentId: consentId))
        EasyPay.shared.apiClient.cancelAnnualConsent(request: request) { result in
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
    
    private func convertDecimalFormatting(_ string: String?) -> String {
        guard let string = string else { return "0.0" }
        return string.replacingOccurrences(of: ",", with: ".")
    }
    
    func isValidCurrency(_ currency: String) -> Bool {
        if let value = Double(currency) {
            return value > 0
        } else {
            return false
        }
    }
}
