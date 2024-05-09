
import XCTest
@testable import EasyPay

class CancelAnnualConsentEndpointTests: XCTestCase {
    
    override class func setUp() {
        EasyPay.shared.configureSecrets(apiKey: "",
                                        hmacSecret: "", 
                                        sentryKey: "")
        sleep(3) // Additional time for certificate downloading
    }
    
    lazy var consentId = 16
    lazy var faultyConsentId = -200

    lazy var faultyRequest = CancelConsentAnnualRequest(cancelConsentAnnualRequest: CancelConsentAnnualManualRequestModel(consentId: faultyConsentId))
    lazy var request = CancelConsentAnnualRequest(cancelConsentAnnualRequest: CancelConsentAnnualManualRequestModel(consentId: consentId))
    let successExpectation = XCTestExpectation(description: "Request was successful")
    let failExpectation = XCTestExpectation(description: "Request was not successful")

    func testSuccessCancelAnnualConsent() {
        //apiKey and hmacToken are required for this test
        EasyPay.shared.apiClient.cancelAnnualConsent(request: request) { result in
            switch result {
            case .success(_):
                self.successExpectation.fulfill()
            case .failure(_):
                break
            }
        }
        wait(for: [successExpectation], timeout: 15.0)
    }
    
    func testFailCancelAnnualConsent() {
        EasyPay.shared.apiClient.cancelAnnualConsent(request: request) { result in
            switch result {
            case .success(_):
                break
            case .failure(_):
                self.failExpectation.fulfill()
            }
        }
        wait(for: [failExpectation], timeout: 5.0)
    }
    
    func testFaultyDataCancelAnnualConsent() {
        //apiKey and hmacToken are required for this test
        EasyPay.shared.apiClient.cancelAnnualConsent(request: faultyRequest) { result in
            switch result {
            case .success(_):
                break
            case .failure(_):
                self.failExpectation.fulfill()
            }
        }
        wait(for: [failExpectation], timeout: 5.0)
    }
}
