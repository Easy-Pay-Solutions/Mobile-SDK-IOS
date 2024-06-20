import XCTest

final class ManagePaymentsUITests: XCTestCase {

    var app: XCUIApplication!

    // MARK: - Overridden

    override func setUpWithError() throws {
        try super.setUpWithError()

        continueAfterFailure = false

        app = XCUIApplication()
    }

    // MARK: - Tests

    func testSuccessDeleteCard() throws {
        app.openPaymentFlow(with: "100")
        app.selectFirstSavedCard()

        app.buttons["deleteCardButton"].tap()
        app.buttons["deleteAction"].tap()

        let successText = app.staticTexts["successToastMessage"]

        // Displays success toast once Success is returned
        XCTAssertTrue(successText.waitForExistence(timeout: 3))
    }

    func testSuccessPaymentWithSelectedCard() throws {
        app.openPaymentFlow(with: "100")
        app.selectFirstSavedCard()

        let actionButton = app.tapCardSelectionActionButton()

        // Disappears once Success is returned
        waitToDisappear(actionButton)

        // Shows success alert
        let successDialog = app.alerts["paymentSuccessfulAlert"]
        XCTAssertTrue(successDialog.waitForExistence(timeout: 1))
    }

    func testSuccessSaveNewCardAfterPayment() throws {
        let amount = "100"
        app.openPaymentFlow(with: amount)
        app.openAndWaitForAddNewCardSheet()

        let cardHolderName = randomLowercaseString(length: 5)
        app.fillCardData(cardHolderName: cardHolderName)
        app.selectSaveCardCheckbox()

        let actionButton = app.tapNewCardActionButton()

        // Disappears once Success is returned
        waitToDisappear(actionButton)

        app.clickOnPayButton()
        app.selectFirstSavedCard()

        let nameLabel = app.staticTexts[cardHolderName]
        XCTAssertTrue(nameLabel.waitForExistence(timeout: 1))
    }

    func testSuccessPaymentWithNewCard() throws {
        app.openPaymentFlow(with: "100")
        app.openAndWaitForAddNewCardSheet()

        app.fillCardData()

        let actionButton = app.tapNewCardActionButton()

        // Disappears once Success is returned
        waitToDisappear(actionButton)
    }

    func testFailurePaymentWithNewCard() throws {
        app.openPaymentFlow(with: "100")
        app.openAndWaitForAddNewCardSheet()

        // Payment should fail with fake card number
        let wrongCardNumber = "0000000000000000"
        app.fillCardData(cardNumber: wrongCardNumber)

        _ = app.tapNewCardActionButton()

        // Error label appears once Failed is returned
        app.waitForErrorLabel(errorLabelAccessibilityId: "addNewCardErrorLabel")
    }

    // MARK: - Helpers

    private func randomLowercaseString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyz"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

