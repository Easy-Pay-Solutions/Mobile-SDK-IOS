
import XCTest
@testable import EasyPay

class ListAnnualConsentEndpointTests: XCTestCase {
    
    override class func setUp() {
        EasyPay.shared.configureSecrets(apiKey: "",
                                        hmacSecret: "", 
                                        sentryKey: "")
        sleep(3) // Additional time for certificate downloading
    }
    
    let dateFormatter = DateFormatter()
    
    lazy var queryHelper = AnnualQueryHelper(merchantId: "1",
                                             customerReferenceId: nil,
                                             endDate: nil)
    lazy var queryHelperWithEndDate = AnnualQueryHelper(merchantId: "1",
                                                        customerReferenceId: nil,
                                                        endDate: createDateInFuture())
    lazy var queryHelperWithEndDateAndCustomerReferenceId = AnnualQueryHelper(merchantId: "1",
                                                                              customerReferenceId: "12456",
                                                                              endDate: createDateInFuture())
    lazy var queryHelperWithCustomerReferenceId = AnnualQueryHelper(merchantId: "1",
                                                                              customerReferenceId: "12456",
                                                                              endDate: nil)
    lazy var faultyQueryHelper = AnnualQueryHelper(merchantId: "JKHDKJDHJKD",
                                                   customerReferenceId: nil,
                                                   endDate: nil)
    lazy var request = ConsentAnnualListingRequest(consentAnnualListingRequest:
                                                    ConsentAnnualListingRequestModel(query: queryHelper))
    lazy var requestWithEndDate = ConsentAnnualListingRequest(consentAnnualListingRequest:
                                                                ConsentAnnualListingRequestModel(query: queryHelperWithEndDate))
    lazy var requestWithEndDateAndCustomerReferenceId = ConsentAnnualListingRequest(consentAnnualListingRequest:
                                                                                        ConsentAnnualListingRequestModel(query: queryHelperWithEndDateAndCustomerReferenceId))
    lazy var requestWithCustomerReferenceId = ConsentAnnualListingRequest(consentAnnualListingRequest:
                                                                            ConsentAnnualListingRequestModel(query: queryHelperWithCustomerReferenceId))
    
    lazy var faultyRequest = ConsentAnnualListingRequest(consentAnnualListingRequest:
                                                            ConsentAnnualListingRequestModel(query: faultyQueryHelper))
    
    let successExpectation = XCTestExpectation(description: "Request was successful")
    let failExpectation = XCTestExpectation(description: "Request was not successful")
    
    func testSuccessListAnnualConsent() {
        //apiKey and hmacToken are required for this test
        EasyPay.shared.apiClient.listAnnualConsents(request: request) { result in
            switch result {
            case .success(_):
                self.successExpectation.fulfill()
            case .failure(_):
                break
            }
        }
        wait(for: [successExpectation], timeout: 15.0)
    }
    
    func testSuccessWithEndDateListAnnualConsent() {
        //apiKey and hmacToken are required for this test
        EasyPay.shared.apiClient.listAnnualConsents(request: requestWithEndDate) { result in
            switch result {
            case .success(_):
                self.successExpectation.fulfill()
            case .failure(_):
                break
            }
        }
        wait(for: [successExpectation], timeout: 15.0)
    }
    
    func testSuccessWithCustomerReferenceIdListAnnualConsent() {
        //apiKey and hmacToken are required for this test
        EasyPay.shared.apiClient.listAnnualConsents(request: requestWithCustomerReferenceId) { result in
            switch result {
            case .success(_):
                self.successExpectation.fulfill()
            case .failure(_):
                break
            }
        }
        wait(for: [successExpectation], timeout: 15.0)
    }
    
    func testSuccessWithEndDateAndCustomerReferenceIdListAnnualConsent() {
        //apiKey and hmacToken are required for this test
        EasyPay.shared.apiClient.listAnnualConsents(request: requestWithEndDateAndCustomerReferenceId) { result in
            switch result {
            case .success(_):
                self.successExpectation.fulfill()
            case .failure(_):
                break
            }
        }
        wait(for: [successExpectation], timeout: 15.0)
    }
    
    func testFailListAnnualConsent() {
        EasyPay.shared.apiClient.listAnnualConsents(request: request) { result in
            switch result {
            case .success(_):
                break
            case .failure(_):
                self.failExpectation.fulfill()
            }
        }
        wait(for: [failExpectation], timeout: 5.0)
    }
    
    func testMissingParametersListAnnualConsent() {
        //apiKey and hmacToken are required for this test
        EasyPay.shared.apiClient.listAnnualConsents(request: faultyRequest) { result in
            switch result {
            case .success(_):
                break
            case .failure(_):
                self.failExpectation.fulfill()
            }
        }
        wait(for: [failExpectation], timeout: 10.0)
    }
    
    private func createDateInFuture() -> Date {
        let currentDate = Date()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let calendar = Calendar.current
        
        if let nextYear = calendar.date(byAdding: .year, value: 1, to: currentDate) {
            return nextYear
        } else {
            return Date()
        }
    }
}
