

import Foundation
import EasyPay

public class CardSelectionViewModel {
    
    let state: ManageCardState
    let merchantId: String
    let amount: String
    var selectedIndex = -1
    var annualConsents: ConsentAnnualListingResponseModel? = nil

    public init(state: ManageCardState, merchantId: String, amount: String) {
        self.state = state
        self.merchantId = merchantId
        self.amount = amount
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
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
