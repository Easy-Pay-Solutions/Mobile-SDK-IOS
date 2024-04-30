
import XCTest
@testable import EasyPay

class ChargeAnnualConsentEndpointTests: XCTestCase {
    
    override class func setUp() {
        EasyPay.shared.configureSecrets(apiKey: "",
                                        hmacSecret: "")
        sleep(3) // Additional time for certificate downloading
    }
    
    lazy var consentId = 19
    lazy var processAmount = "10.0"
    lazy var faultyConsentId = -200
    lazy var faultyProcessAmount = "0.0"

    lazy var faultyRequest = ProcessPaymentAnnualRequest(processPaymentAnnualRequest: ProcessPaymentAnnualRequestModel(
        consentId: faultyConsentId,
        processAmount: faultyProcessAmount))
    lazy var request = ProcessPaymentAnnualRequest(processPaymentAnnualRequest: ProcessPaymentAnnualRequestModel(
        consentId: consentId,
        processAmount: processAmount))
    let successExpectation = XCTestExpectation(description: "Request was successful")
    let failExpectation = XCTestExpectation(description: "Request was not successful")

    func testSuccessChargeAnnualConsent() {
        //apiKey and hmacToken are required for this test
        EasyPay.shared.apiClient.processPaymentAnnualConsent(request: request) { result in
            switch result {
            case .success(_):
                self.successExpectation.fulfill()
            case .failure(_):
                break
            }
        }
        wait(for: [successExpectation], timeout: 20.0)
    }
    
    func testFailChargeAnnualConsent() {
        EasyPay.shared.apiClient.processPaymentAnnualConsent(request: request) { result in
            switch result {
            case .success(_):
                break
            case .failure(_):
                self.failExpectation.fulfill()
            }
        }
        wait(for: [failExpectation], timeout: 5.0)
    }
    
    func testFaultyDataChargeAnnualConsent() {
        //apiKey and hmacToken are required for this test
        EasyPay.shared.apiClient.processPaymentAnnualConsent(request: faultyRequest) { result in
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
