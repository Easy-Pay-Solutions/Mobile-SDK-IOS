
import XCTest
@testable import EasyPay

class AddAnnualConsentEndpointTests: XCTestCase {
    
    override class func setUp() {
        EasyPay.shared.configureSecrets(apiKey: "",
                                        hmacSecret: "")
        sleep(3) // Additional time for certificate downloading
    }
    
    lazy var request = CreateConsentAnnualRequest(createConsentAnnualRequest: prepareData())
    lazy var faultyRequest = CreateConsentAnnualRequest(createConsentAnnualRequest: prepareFaultyData())

    let successExpectation = XCTestExpectation(description: "Request was successful")
    let failExpectation = XCTestExpectation(description: "Request was not successful")

    func testSuccessAddAnnualConsent() {
        //apiKey and hmacToken are required for this test
        EasyPay.shared.apiClient.createAnnualConsent(request: request) { result in
            switch result {
            case .success(_):
                self.successExpectation.fulfill()
            case .failure(_):
                break
            }
        }
        wait(for: [successExpectation], timeout: 15.0)
    }
    
    func testFailAddAnnualConsent() {
        EasyPay.shared.apiClient.createAnnualConsent(request: request) { result in
            switch result {
            case .success(_):
                break
            case .failure(_):
                self.failExpectation.fulfill()
            }
        }
        wait(for: [failExpectation], timeout: 5.0)
    }
    
    func testMissingParametersAddAnnualConsent() {
        //apiKey and hmacToken are required for this test
        EasyPay.shared.apiClient.createAnnualConsent(request: faultyRequest) { result in
            switch result {
            case .success(_):
                break
            case .failure(_):
                self.failExpectation.fulfill()
            }
        }
        wait(for: [failExpectation], timeout: 5.0)
    }
    
    
    public func prepareData() -> CreateConsentAnnualManualRequestModel {
        let data = CreateConsentAnnualManualRequestModel(
            creditCardInfo: CreditCardInfo(
                accountNumber: "QWOY6TAb5qjPFQdGrxTFThJ7EPbc295nw4JN2L/GLGjqMV1dFJQGBNL9SblCuJId15CjCjrFAVilc1zNM6l5jNnDRR9s2/+co0QLvQLTapTTgveP/5dn6PMfhxwKnSb/a0Qd9+qLb5FeHMgmMbhBMJo3PHlf/JNwDX/PWZ9I2LAEHPPf+5cgteLgoOVNw5U/mf1i5mtovNYI6Nsfsp3JGe2HOQTFCjcBx2OlzRQooYawZVByE1BV+FDvkWirU3v4DO1BxrhDODgK/TMrneg8ne75ig8LlCJhpcuO5oXp9ES6JsdQ/Q9mIqqJBA2Zo86qFLr1yCGh7taQIJ9V6j91VPybJJ9MLv5xJlUv5puxrvSfnECaR0nwLBBHrF/sHq+SmAiGGwC1qQB7dLO5PJWWd7Qy0uhxWarQSVaPKJRW7uNFKXxFdGWNBcINVR/mkNECJ4E+AdbhbbGj3Vx4ExGB2aIFpfp9izXx75T4JGvK/uBv1XABLgqzXInA1WLU50arOLnQH58FBaZiZRATukP60KPLqWSC2NPuHDQw/3eFQ/KvViLR3BSh2WLTvS7qVcZ7f43iNiHt8CMLuaaEWL8GfvU1FU2rB/DsOp9ab+N5DmTs9voRLEfKARCgUggAaC57eDzT8rY/vA7/+2iTGZqv9OuMSlopoGmZF5eiH0ysXUI=",
                expirationMonth: Int("10") ?? 0,
                expirationYear: Int("2026") ?? 0,
                cvv: "989"),
            consentAnnualCreate: CreateConsentAnnual(
                merchID: Int("1") ?? 0,
                customerRefID: "12456",
                serviceDescrip: "FROM API TESTER",
                rpguid: "3d3424a6-c5f3-4c28",
                startDate: convertDate(Date()),
                limitPerCharge: convertDecimalFormatting("1000.0"),
                limitLifeTime: convertDecimalFormatting("100000.0")),
            accountHolder: AccountHolder(
                firstName: "Sean",
                lastName: "Wood",
                company: "",
                billingAddress:
                    BillingAddress(
                        address1: "123 Fake St.",
                        address2: "",
                        city: "PORTLAND",
                        state: "ME",
                        zip: "04005",
                        country: "USA"),
                email: "testing@easypaysolutions.com",
                phone: "8775558472"),
            endCustomer: nil)
        return data
    }
    
    public func prepareFaultyData() -> CreateConsentAnnualManualRequestModel {
        let data = CreateConsentAnnualManualRequestModel(
            creditCardInfo: CreditCardInfo(
                accountNumber: "",
                expirationMonth: Int("10") ?? 0,
                expirationYear: Int("2026") ?? 0,
                cvv: "989"),
            consentAnnualCreate: CreateConsentAnnual(
                merchID: Int("1") ?? 0,
                customerRefID: "12456",
                serviceDescrip: "FROM API TESTER",
                rpguid: "3d3424a6-c5f3-4c28",
                startDate: convertDate(Date()),
                limitPerCharge: convertDecimalFormatting("1000.0"),
                limitLifeTime: convertDecimalFormatting("100000.0")),
            accountHolder: AccountHolder(
                firstName: "Sean",
                lastName: "Wood",
                company: "",
                billingAddress:
                    BillingAddress(
                        address1: "123 Fake St.",
                        address2: "",
                        city: "PORTLAND",
                        state: "ME",
                        zip: "04005",
                        country: "USA"),
                email: "testing@easypaysolutions.com",
                phone: "8775558472"),
            endCustomer: nil)
        return data
    }
    
    private func convertDecimalFormatting(_ string: String?) -> String {
        guard let string = string else { return "0.0" }
        return string.replacingOccurrences(of: ",", with: ".")
    }
    
    private func convertDate(_ date: Date) -> String {
        let epochTime = Int(date.timeIntervalSince1970) * 1000
        return #"/Date(\#(epochTime))/"#
    }
}
