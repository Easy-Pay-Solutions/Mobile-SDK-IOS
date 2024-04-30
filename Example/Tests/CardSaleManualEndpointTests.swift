import XCTest
import Security
@testable import EasyPay

class CardSaleManualEndpointTests: XCTestCase {
    let api = ApiClient(configuration: Config(
        apiKey: "",
        hmacToken: ""))
    
    lazy var request = CardSaleManualRequest(transactionRequest: prepareTestDataForCreditCardManual())
    let successExpectation = XCTestExpectation(description: "Request was successfull")
    let failExpectation = XCTestExpectation(description: "Request was not successfull")

    func testSuccessCardChargeWithTestData() {
        //apiKey and hmacToken are required for this test
        api.chargeCreditCard(request: request) { result in
            switch result {
            case .success(_):
                self.successExpectation.fulfill()
            case .failure(_):
                break
            }
        }
        wait(for: [successExpectation], timeout: 15.0)
    }
    
    func testFailCardChargeWithTestData() {
        api.chargeCreditCard(request: request) { result in
            switch result {
            case .success(_):
                break
            case .failure(_):
                self.failExpectation.fulfill()
            }
        }
        wait(for: [failExpectation], timeout: 5.0)
    }
    
    public func prepareTestDataForCreditCardManual() -> TransactionRequest {
        return TransactionRequest(
            creditCardInfo:
                CreditCardInfo(
                    accountNumber: "QWOY6TAb5qjPFQdGrxTFThJ7EPbc295nw4JN2L/GLGjqMV1dFJQGBNL9SblCuJId15CjCjrFAVilc1zNM6l5jNnDRR9s2/+co0QLvQLTapTTgveP/5dn6PMfhxwKnSb/a0Qd9+qLb5FeHMgmMbhBMJo3PHlf/JNwDX/PWZ9I2LAEHPPf+5cgteLgoOVNw5U/mf1i5mtovNYI6Nsfsp3JGe2HOQTFCjcBx2OlzRQooYawZVByE1BV+FDvkWirU3v4DO1BxrhDODgK/TMrneg8ne75ig8LlCJhpcuO5oXp9ES6JsdQ/Q9mIqqJBA2Zo86qFLr1yCGh7taQIJ9V6j91VPybJJ9MLv5xJlUv5puxrvSfnECaR0nwLBBHrF/sHq+SmAiGGwC1qQB7dLO5PJWWd7Qy0uhxWarQSVaPKJRW7uNFKXxFdGWNBcINVR/mkNECJ4E+AdbhbbGj3Vx4ExGB2aIFpfp9izXx75T4JGvK/uBv1XABLgqzXInA1WLU50arOLnQH58FBaZiZRATukP60KPLqWSC2NPuHDQw/3eFQ/KvViLR3BSh2WLTvS7qVcZ7f43iNiHt8CMLuaaEWL8GfvU1FU2rB/DsOp9ab+N5DmTs9voRLEfKARCgUggAaC57eDzT8rY/vA7/+2iTGZqv9OuMSlopoGmZF5eiH0ysXUI=",
                    expirationMonth: 10,
                    expirationYear: 2026,
                    cvv: "999"),
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
            endCustomer: EndCustomer(
                firstName: "Sean",
                lastName: "Wood",
                company: "",
                billingAddress:
                    EndCustomerBillingAddress(
                        address1: "123 Fake St.",
                        address2: "",
                        city: "PORTLAND",
                        state: "ME",
                        zip: "04005",
                        country: "USA"),
                email: "robert@easypaysolutions.com",
                phone: "8775558472"),
            amounts: Amounts(
                totalAmount: "10.0",
                salesAmount: "0.0",
                surcharge: "0.0"),
            purchItems: PurchItems(
                serviceDescription: "FROM API TESTER",
                clientRefId: "12456",
                rpguid: "3d3424a6-c5f3-4c28"),
            merchantId: 1)
    }
}
