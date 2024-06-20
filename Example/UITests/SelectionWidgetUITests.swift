import XCTest

final class SelectionWidgetUITests: XCTestCase {

    var app: XCUIApplication!

    // MARK: - Overridden

    override func setUpWithError() throws {
        try super.setUpWithError()

        continueAfterFailure = false

        app = XCUIApplication()
    }

    // MARK: - Tests

    func testSuccessDeleteCard() throws {
        app.openManagementFlow()
        app.selectFirstSavedCard()

        app.buttons["deleteCardButton"].tap()
        app.buttons["deleteAction"].tap()

        let successText = app.staticTexts["successToastMessage"]

        // Displays success toast once Success is returned
        XCTAssertTrue(successText.waitForExistence(timeout: 3))
    }

    func testSuccessAddNewCard() throws {
        app.openManagementFlow()
        app.openAndWaitForAddNewCardSheet()

        app.fillCardData()

        let saveButton = app.tapNewCardActionButton()

        // Disappears once Success is returned
        waitToDisappear(saveButton)
    }

    func testFailureAddNewCard() throws {
        app.openManagementFlow()
        app.openAndWaitForAddNewCardSheet()

        // Card saving should fail with "dangerous" data passed
        let wrongCardHolderName = "save"
        app.fillCardData(cardHolderName: wrongCardHolderName)

        _ = app.tapNewCardActionButton()

        // Error label appears once Failed is returned
        app.waitForErrorLabel(errorLabelAccessibilityId: "addNewCardErrorLabel")
    }

}
