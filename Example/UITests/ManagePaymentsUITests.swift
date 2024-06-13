
import XCTest

final class ManagePaymentsUITests: XCTestCase {

    var app: XCUIApplication!

    // MARK: - Overridden

    override func setUpWithError() throws {
        try super.setUpWithError()

        continueAfterFailure = false

        app = XCUIApplication()
    }

    // MARK: - Payment flow tests

    func testSuccessDeleteCard_PaymentFlow() throws {
        openPaymentFlow()
        selectFirstCard()

        app.buttons["Delete this card"].tap()
        app.buttons["Delete"].tap()

        let successText = app.staticTexts["The selected credit card has been deleted."]

        // Displays success toast once Success is returned
        XCTAssertTrue(successText.waitForExistence(timeout: 3))
    }

    func testSuccessPaymentWithSelectedCard_PaymentFlow() throws {
        openPaymentFlow()
        selectFirstCard()

        let payButton = app.buttons["PayButton"]
        payButton.tap()

        // Disappears once Success is returned
        waitToDisappear(payButton)
    }

    // MARK: - Management flow tests

    func testSuccessDeleteCard_ManagementFlow() throws {
        openManagementFlow()
        selectFirstCard()

        app.buttons["Delete this card"].tap()
        app.buttons["Delete"].tap()

        let successText = app.staticTexts["The selected credit card has been deleted."]

        // Displays success toast once Success is returned
        XCTAssertTrue(successText.waitForExistence(timeout: 3))
    }

    // MARK: - Helpers

    private func selectFirstCard() {
        let firstCard = app.collectionViews.children(matching: .any).element(boundBy: 1)
        if firstCard.exists {
            firstCard.tap()
        }
    }

    private func openPaymentFlow() {
        openFlow(with: "Manage Payments Widget Demo (Payment)")
    }

    private func openManagementFlow() {
        openFlow(with: "Manage Payments Widget Demo (Selection)")
    }

    private func openFlow(with title: String) {
        app.launch()
        sleep(1)    // wait for certificate to be downloaded
        app.buttons[title].tap()
        sleep(1)    // wait for cards to be loaded
    }

    private func waitToDisappear(_ target: Any?, timeout: TimeInterval = 5.0) {
        let doesNotExist = NSPredicate(format: "exists == FALSE")
        expectation(for: doesNotExist, evaluatedWith: target, handler: nil)
        waitForExpectations(timeout: timeout, handler: nil)
    }
}

