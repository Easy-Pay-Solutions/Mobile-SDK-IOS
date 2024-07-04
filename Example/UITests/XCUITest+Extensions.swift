import XCTest

extension XCTestCase {
    func waitToDisappear(_ target: Any?, timeout: TimeInterval = 5.0) {
        let doesNotExist = NSPredicate(format: "exists == FALSE")
        expectation(for: doesNotExist, evaluatedWith: target, handler: nil)
        waitForExpectations(timeout: timeout, handler: nil)
    }
}

extension XCUIApplication {

    // MARK: - Add New Card Sheet operations

    func fillCardData(cardNumber: String = "4111111111111111",
                      cardHolderName: String = "test") {
        typeTextInTable(textFieldAccessibilityId: "Card holder name", text: cardHolderName)
        typeTextInTable(textFieldAccessibilityId: "Card number", text: cardNumber)
        typeTextInTable(textFieldAccessibilityId: "MM/YY", text: "1234")
        typeTextInTable(textFieldAccessibilityId: "CVC", text: "123")
        typeTextInTable(textFieldAccessibilityId: "Address", text: "test")
        typeTextInTable(textFieldAccessibilityId: "ZIP", text: "test")

        // Tap outside to hide keyboard
        staticTexts["newCardHeaderLabel"].tap()
    }

    func selectSaveCardCheckbox() {
        tables.cells.descendants(matching: .button).element(boundBy: 8).tap()
    }

    func typeTextInTable(textFieldAccessibilityId: String, text: String) {
        tapOnTextFieldInTable(textFieldAccessibilityId)
        typeTextWithKeyboard(text)
    }

    func waitForErrorLabel(errorLabelAccessibilityId: String) {
        let errorLabel = staticTexts[errorLabelAccessibilityId]
        XCTAssertTrue(errorLabel.waitForExistence(timeout: 5))
    }

    func tapNewCardActionButton() -> XCUIElement {
        let actionButton = buttons["addNewCardActionButton"]
        actionButton.tap()
        return actionButton
    }

    // MARK: - Manage Cards Widget operations

    func selectFirstSavedCard() {
        let firstCard = collectionViews.children(matching: .any).element(boundBy: 1)
        XCTAssertTrue(firstCard.exists)
        firstCard.tap()
    }

    func openAndWaitForAddNewCardSheet() {
        let firstCard = collectionViews.children(matching: .any).element(boundBy: 0)
        firstCard.tap()

        XCTAssertTrue(staticTexts["newCardHeaderLabel"].waitForExistence(timeout: 1))
    }

    func tapCardSelectionActionButton() -> XCUIElement {
        let actionButton = buttons["cardSelectionPayButton"]
        actionButton.tap()
        return actionButton
    }

    // MARK: - Example App operations

    func openPaymentFlow(with amount: String, customerRefId: String = "iOS_E2E_TESTS_CUSTOMER_REF_ID") {
        openFlow(with: "paymentFlowButton")
        typeText(into: "amountToChargeTextField", text: amount)
        typeText(into: "customerRefIdTextField", text: customerRefId)
        clickOnWidgetParametersActionButton()
    }

    func openManagementFlow(with customerRefId: String = "iOS_E2E_TESTS_CUSTOMER_REF_ID") {
        openFlow(with: "selectionFlowButton")
        typeText(into: "customerRefIdTextField", text: customerRefId)
        clickOnWidgetParametersActionButton()
    }

    func typeText(into textFieldAccessibilityId: String, text: String) {
        let textField = textFields[textFieldAccessibilityId]
        textField.tap()
        textField.typeText(text)
    }

    func clickOnWidgetParametersActionButton() {
        let actionsButton = buttons["widgetParametersActionButton"]
        actionsButton.tap()
        sleep(2)    // wait for cards to be loaded
    }

    // MARK: - Helpers

    private func tapOnTextFieldInTable(_ textFieldAccessibilityId: String) {
        let cell = tables.cells
        cell.descendants(matching: .staticText)[textFieldAccessibilityId].tap()
    }

    private func typeTextWithKeyboard(_ text: String) {
        for key in text {
            self.keys[String(key)].tap()
        }
    }

    private func openFlow(with accessibilityId: String) {
        launch()
        sleep(1)    // wait for certificate to be downloaded
        buttons[accessibilityId].tap()
    }
}
