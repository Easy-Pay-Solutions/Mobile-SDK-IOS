
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
                                             customerReferenceId: "12456",
                                             endDate: nil)
    lazy var queryHelperWithEndDate = AnnualQueryHelper(merchantId: "1",
                                                        customerReferenceId: "12456",
                                                        endDate: createDateInFuture())
    lazy var request = ConsentAnnualListingRequest(consentAnnualListingRequest: ConsentAnnualListingRequestModel(query: queryHelper))
    lazy var requestWithEndDate = ConsentAnnualListingRequest(consentAnnualListingRequest: ConsentAnnualListingRequestModel(query: queryHelperWithEndDate))

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

    func testWrongMerchantIdListAnnualConsent() {
        let wrongMerchantId = "JKHDKJDHJKD"
        let wrongQueryHelper = AnnualQueryHelper(merchantId: wrongMerchantId, endDate: nil)
        let wrongRequestModel = ConsentAnnualListingRequestModel(query: wrongQueryHelper)
        let faultyRequest = ConsentAnnualListingRequest(consentAnnualListingRequest: wrongRequestModel)
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

    func testMissingRpguidAndCustomerRefIdListAnnualConsent() {
        let queryHelperWithoutRequiredParameters = AnnualQueryHelper(merchantId: "1", endDate: nil)
        let wrongRequestModel = ConsentAnnualListingRequestModel(query: queryHelperWithoutRequiredParameters)
        let faultyRequest = ConsentAnnualListingRequest(consentAnnualListingRequest: wrongRequestModel)
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
