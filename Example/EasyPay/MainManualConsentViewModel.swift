
import Foundation
import EasyPay

class MainManualConsentViewModel {
    
    var isPrefilled: Bool
    var annualConData: ConsentAnnualListingResponseModel? = nil
    
    init(isPrefilled: Bool) {
        self.isPrefilled = isPrefilled
    }
    
    func downloadAnnualConsents(_ completion: @escaping (Result<ListingConsentAnnualResponse, Error>) -> Void) {
        let queryHelper = AnnualQueryHelper(merchantId: "1",
                                      customerReferenceId: nil,
                                      endDate: nil)
        let request = ConsentAnnualListingRequest(consentAnnualListingRequest: ConsentAnnualListingRequestModel(query: queryHelper))
        EasyPay.shared.apiClient.listAnnualConsents(request: request) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.annualConData = response.data
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
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
                             processAmount: String,
                             _ completion: @escaping (Result<ProcessPaymentAnnualResponse, Error>) -> Void) {
        let convertedProcessAmount = convertDecimalFormatting(processAmount)
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
}
