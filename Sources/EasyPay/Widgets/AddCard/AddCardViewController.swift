
import UIKit
import EasyPay

public enum AddCardState {
    case saveOnly
    case payAndSave
}

public protocol SavingCardDelegate: AnyObject {
    func didOnlySaveCard(consentId: Int?, success: Bool)
}

public protocol PayingSavingCardDelegate: AnyObject {
    func didSaveCard(consentId: Int?, success: Bool)
    func didPayWithCard(consentId: Int?, success: Bool)
}

public class AddCardViewController: BaseViewController {
    
    enum AddCardTableRow: Int, CaseIterable {
        case header = 0
        case creditCardHeader = 1
        case cardHolder = 2
        case cardHolderErrorHint = 3
        case cardNumber = 4
        case cardNumberError = 5
        case yearCvc = 6
        case yearCvcError = 7
        case addressHeader = 8
        case address = 9
        case addressErrorHint = 10
        case zip = 11
        case zipErrorHint = 12
        case payButton = 13
    }
    
    enum AddCardCellTags: Int, CaseIterable {
        case cardHolder = 2
        case cardNumber = 4
        case yearCvc = 6
        case address = 9
        case zip = 11
    }
    
    @IBOutlet private weak var tableView: UITableView!

    private let vcName = "AddCardViewController"
    private let viewModel: AddCardViewModel

    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    public weak var savingDelegate: SavingCardDelegate?
    public weak var payingSavingDelegate: PayingSavingCardDelegate?
    weak var closePaymentSheetDelegate: InternalClosingDelegate?

    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        addGestureForController()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    public init(state: AddCardState, amount: String, delegate: AnyObject, paymentDetails: AddAnnualConsentWidgetModel) {
        self.viewModel = AddCardViewModel(state: state,
                                          amount: amount,
                                          paymentDetails: paymentDetails)
        if state == .saveOnly {
            self.savingDelegate = delegate as? any SavingCardDelegate
        } else {
            self.payingSavingDelegate = delegate as? any PayingSavingCardDelegate
        }
        super.init(nibName: vcName, bundle: Bundle(identifier: Theme.bundleId))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTableView() {
        let cellReuseIds = [
            AddCardHeaderTableViewCell.reuseId,
            AddCardSectionHeaderTableViewCell.reuseId,
            SinglePaymentTableViewCell.reuseId,
            SingleHintErrorTableViewCell.reuseId,
            DoublePaymentTableViewCell.reuseId,
            DoubleHintErrorTableViewCell.reuseId,
            PayActionsTableViewCell.reuseId
        ]
        
        cellReuseIds.forEach { reuseId in
            let bundleId = Bundle(identifier: Theme.bundleId)
            let nib = UINib(nibName: reuseId, bundle: bundleId)
            tableView.register(nib, forCellReuseIdentifier: reuseId)
        }
    }
    
    private func addGestureForController() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        tableView.endEditing(true)
    }
}

extension AddCardViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let index = AddCardTableRow.init(rawValue: indexPath.row) else {
            return UITableView.automaticDimension
        }
        let isIpad = UIDevice.current.isIpad
        let shorterMessage = 25.0
        let longerMessage = 40.0
        
        if index == .cardHolderErrorHint && viewModel.cardholerErrorShown {
            return isIpad ? shorterMessage : longerMessage
        } else if index == .cardHolderErrorHint && viewModel.shouldShowCardholderHint() && viewModel.cardholerHintShown {
            return shorterMessage
        } else if index == .cardHolderErrorHint {
            return 0
        }
        
        if index == .cardNumberError && viewModel.cardNumberErrorShown {
            return shorterMessage
        } else if index == .cardNumberError {
            return 0
        }
        
        if index == .yearCvcError && (viewModel.monthYearErrorShown || viewModel.cvcErrorShown) {
            return shorterMessage
        } else if index == .yearCvcError {
            return 0
        }
        
        if index == .addressErrorHint && viewModel.addressErrorShown {
            return isIpad ? shorterMessage : longerMessage
        } else if index == .addressErrorHint && viewModel.shouldShowAddressHint() && viewModel.addressHintShown {
            return shorterMessage
        } else if index == .addressErrorHint {
            return 0
        }
        
        if index == .zipErrorHint && viewModel.zipErrorShown {
            return isIpad ? shorterMessage : longerMessage
        } else if index == .zipErrorHint && viewModel.shouldShowZipHint() && viewModel.zipHintShown {
            return shorterMessage
        } else if index == .zipErrorHint {
            return 0
        }
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AddCardTableRow.allCases.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch AddCardTableRow(rawValue: indexPath.row) {
        case .header:
            return self.tableView(tableView, headerForRowAt: indexPath)
        case .creditCardHeader:
            return self.tableView(tableView, creditInfoHeaderForRowAt: indexPath)
        case .cardHolder:
            return self.tableView(tableView, cardholderForRowAt: indexPath)
        case .cardHolderErrorHint:
            return self.tableView(tableView, cardHolderErrorHintForRowAt: indexPath)
        case .cardNumber:
            return self.tableView(tableView, cardNumberForRowAt: indexPath)
        case .cardNumberError:
            return self.tableView(tableView, cardNumberErrorForRowAt: indexPath)
        case .yearCvc:
            return self.tableView(tableView, yearForRowAt: indexPath)
        case .yearCvcError:
            return self.tableView(tableView, yearCvcErrorForRowAt: indexPath)
        case .addressHeader:
            return self.tableView(tableView, addressHeaderForRowAt: indexPath)
        case .address:
            return self.tableView(tableView, addressForRowAt: indexPath)
        case .addressErrorHint:
            return self.tableView(tableView, addressErrorHintForRowAt: indexPath)
        case .zip:
            return self.tableView(tableView, zipForRowAt: indexPath)
        case .zipErrorHint:
            return self.tableView(tableView, zipErrorHintForRowAt: indexPath)
        case .payButton:
            return self.tableView(tableView, payButtonForRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    private func tableView(_ tableView: UITableView, headerForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddCardHeaderTableViewCell.reuseId) as? AddCardHeaderTableViewCell else { return UITableViewCell(frame: .zero) }
        cell.delegate = self
        return cell
    }
    
    private func tableView(_ tableView: UITableView, creditInfoHeaderForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddCardSectionHeaderTableViewCell.reuseId) as? AddCardSectionHeaderTableViewCell else { return UITableViewCell(frame: .zero) }
        cell.applyData(title: Localization.cardInformation)
        return cell
    }
    
    private func tableView(_ tableView: UITableView, cardholderForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SinglePaymentTableViewCell.reuseId) as? SinglePaymentTableViewCell else { return UITableViewCell(frame: .zero) }
        cell.tag = indexPath.row
        cell.applyData(title: Localization.cardHolderName, 
                       maxCharLimit: viewModel.cardHolderMaxChar)
        cell.delegate = self
        cell.textField.text = viewModel.cardholerName
        return cell
    }
    
    private func tableView(_ tableView: UITableView, cardHolderErrorHintForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SingleHintErrorTableViewCell.reuseId) as? SingleHintErrorTableViewCell else { return UITableViewCell(frame: .zero) }
        cell.tag = indexPath.row
        cell.hintLabel.text = viewModel.cardHolderMaxCharMessage
        return cell
    }
    
    private func tableView(_ tableView: UITableView, cardNumberForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SinglePaymentTableViewCell.reuseId) as? SinglePaymentTableViewCell else { return UITableViewCell(frame: .zero) }
        cell.tag = indexPath.row
        cell.applyData(title: Localization.cardNumber,
                       showCardIcon: true, 
                       maxCharLimit: viewModel.cardNumberMaxChar, 
                       keyboardType: .numberPad,
                       isNumbersOnlyAllowed: true,
                       isSecureTextEntryEnabled: true)
        cell.textField.text = viewModel.cardNumber
        cell.delegate = self
        return cell
    }
    
    private func tableView(_ tableView: UITableView, cardNumberErrorForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SingleHintErrorTableViewCell.reuseId) as? SingleHintErrorTableViewCell else { return UITableViewCell(frame: .zero) }
        cell.tag = indexPath.row
        return cell
    }
    
    private func tableView(_ tableView: UITableView, yearForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DoublePaymentTableViewCell.reuseId) as? DoublePaymentTableViewCell else { return UITableViewCell(frame: .zero) }
        cell.tag = indexPath.row
        cell.applyData(leftTitle: Localization.mmyy,
                       rightTitle: Localization.cvc,
                       leftMaxCharLimit: viewModel.monthYeatMaxChar,
                       rightMaxCharLimit: viewModel.cvcMaxChar,
                       isRightNumbersOnlyAllowed: true)
        cell.leftTextField.text = viewModel.monthYear
        cell.rightTextField.text = viewModel.cvc
        cell.delegate = self
        return cell
    }
    
    private func tableView(_ tableView: UITableView, yearCvcErrorForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DoubleHintErrorTableViewCell.reuseId) as? DoubleHintErrorTableViewCell else { return UITableViewCell(frame: .zero) }
        cell.tag = indexPath.row
        return cell
    }

    private func tableView(_ tableView: UITableView, addressHeaderForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddCardSectionHeaderTableViewCell.reuseId) as? AddCardSectionHeaderTableViewCell else { return UITableViewCell(frame: .zero) }
        cell.applyData(title: Localization.billingAddress)
        return cell
    }
    
    
    private func tableView(_ tableView: UITableView, addressForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SinglePaymentTableViewCell.reuseId) as? SinglePaymentTableViewCell else { return UITableViewCell(frame: .zero) }
        cell.tag = indexPath.row
        cell.applyData(title: Localization.address,
                       maxCharLimit: viewModel.addressMaxChar)
        cell.textField.text = viewModel.address
        cell.delegate = self
        return cell
    }
    
    private func tableView(_ tableView: UITableView, addressErrorHintForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SingleHintErrorTableViewCell.reuseId) as? SingleHintErrorTableViewCell else { return UITableViewCell(frame: .zero) }
        cell.tag = indexPath.row
        cell.hintLabel.text  = viewModel.addressMaxCharMessage
        return cell
    }
    
    private func tableView(_ tableView: UITableView, zipForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SinglePaymentTableViewCell.reuseId) as? SinglePaymentTableViewCell else { return UITableViewCell(frame: .zero) }
        cell.tag = indexPath.row
        cell.applyData(title: Localization.zip, 
                       maxCharLimit: viewModel.zipMaxChar)
        cell.textField.text = viewModel.zip
        cell.delegate = self
        return cell
    }
    
    private func tableView(_ tableView: UITableView, zipErrorHintForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SingleHintErrorTableViewCell.reuseId) as? SingleHintErrorTableViewCell else { return UITableViewCell(frame: .zero) }
        cell.tag = indexPath.row
        cell.hintLabel.text = viewModel.zipMaxCharMessage
        return cell
    }
    
    private func tableView(_ tableView: UITableView, payButtonForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PayActionsTableViewCell.reuseId) as? PayActionsTableViewCell else { return UITableViewCell(frame: .zero) }
        cell.tag = indexPath.row
        cell.applySelectedState(viewModel.shouldSaveCard)
        cell.applyState(state: viewModel.state, amount: viewModel.amount)
        cell.delegate = self
        return cell
    }
}

//MARK: Delegates implementation & actions

extension AddCardViewController: PayActionsDelegate, CloseButtonDelegate, SinglePaymentFieldDelegate {
    func didBeginEditing(cell: SinglePaymentTableViewCell, text: String?) {
   
        hideErrorAfterEditingStarted()

        guard let tag = AddCardCellTags.init(rawValue: cell.tag) else { return }
        switch tag {
        case .cardHolder:
            didBeginEditingValidationCardholder(cell: cell, text: text)
        case .address:
            didBeginEditingValidationAddress(cell: cell, text: text)
        case .zip:
            didBeginEditingValidationZip(cell: cell, text: text)
        default:
            break
        }
        updateTableView()
    }

    func didChangeText(cell: SinglePaymentTableViewCell, text: String?) {
        guard let tag = AddCardCellTags.init(rawValue: cell.tag) else { return }
        switch tag {
        case .cardHolder:
            viewModel.cardholerName = text
            didEditingChangedValidationCardholder(cell: cell)
        case .cardNumber:
            let mask = viewModel.applyMaskOnCard(cardNumber: text)
            cell.textField.text = mask
            viewModel.cardNumber = mask
        case .address:
            viewModel.address = text
            didEditingChangedValidationAddress(cell: cell)
        case .zip:
            viewModel.zip = text
            didEditingChangedValidationZip(cell: cell)
        default:
            break
        }
        updateTableView()
    }
    
    func didEndEditing(cell: SinglePaymentTableViewCell, text: String?) {
        enablePaySaveButton(viewModel.canEnableButton())
        guard let tag = AddCardCellTags.init(rawValue: cell.tag) else { return }
        switch tag {
        case .cardHolder:
            didEndEditingValidationCardholder(cell: cell, text: text)
        case .cardNumber:
            didEndEditingValidationCardNumber(cell: cell, text: text)
        case .address:
            didEndEditingValidationAddress(cell: cell, text: text)
        case .zip:
            didEndEditingValidationZip(cell: cell, text: text)
        default:
            break
        }
        updateTableView()
    }
    
    private func updateTableView() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func didTapClose(_ sender: UIButton) {
        close()
    }
    
    private func close() {
        self.dismiss(animated: true, completion: nil)
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func didTapCheckbox(_ sender: UIButton) {
        sender.isSelected.toggle()
        viewModel.shouldSaveCard = sender.isSelected
    }
    
    func didTapPay(_ sender: UIButton) {
        if viewModel.state == .saveOnly {
            saveCard()
        } else {
            if viewModel.shouldSaveCard {
                saveCardAndPay()
            } else {
                payWithoutSaving()
            }
        }
    }
    
    private func saveCardAndPay() {
        showLoading(true)
        viewModel.createAnnualConsent { [self] result in
            showLoading(false)
            switch result {
            case .success(let success):
                let consentId = success.data.consentId
                self.payingSavingDelegate?.didSaveCard(consentId: success.data.consentId, success: true)
                self.payAfterSaving(consentId: consentId)
                self.updateTableView()
            case .failure(_):
                self.showErrorPaySaveButton(true, text: Localization.technicalDifficultiesError)
                self.viewModel.saveCardErrorShown = true
                self.payingSavingDelegate?.didSaveCard(consentId: nil, success: false)
                self.updateTableView()
            }
        }
    }
    
    private func payAfterSaving(consentId: Int) {
        showLoading(true)
        viewModel.chargeAnnualConsent(consentId: consentId) { result in
            self.showLoading(false)
            switch result {
            case .success(let success):
                self.paymentSuccesRespondeHandler(response: success, selectedCard: consentId)
                self.updateTableView()
            case .failure(_):
                self.payingSavingDelegate?.didPayWithCard(consentId: consentId, success: false)
                self.showErrorPaySaveButton(true, text: Localization.technicalDifficultiesError)
                self.updateTableView()
            }
        }
    }
    
    private func payWithoutSaving() {
        showLoading(true)
        viewModel.chargeCard { result in
            self.showLoading(false)
            switch result {
            case .success(let success):
                self.paymentOnlyRespondeHandler(response: success)
                self.updateTableView()
            case .failure(_):
                self.payingSavingDelegate?.didPayWithCard(consentId: nil, success: false)
                self.showErrorPaySaveButton(true, text: Localization.technicalDifficultiesError)
                self.updateTableView()
            }
        }
    }
    
    private func saveCard() {
        showLoading(true)
        viewModel.createAnnualConsent { result in
            self.showLoading(false)
            switch result {
            case .success(let success):
                self.dismiss(animated: true, completion: nil)
                self.savingDelegate?.didOnlySaveCard(consentId: success.data.consentId, success: true)
            case .failure(_):
                self.showErrorPaySaveButton(true, text: Localization.technicalDifficultiesError)
                self.viewModel.saveCardErrorShown = true
                self.updateTableView()
                self.savingDelegate?.didOnlySaveCard(consentId: nil, success: false)
            }
        }
    }
    
    private func paymentSuccesRespondeHandler(response: ProcessPaymentAnnualResponse, selectedCard: Int) {
        if response.data.errorMessage != "" && response.data.errorCode != 0 {
            showErrorPaySaveButton(true, text: Localization.technicalDifficultiesError)
            payingSavingDelegate?.didPayWithCard(consentId: selectedCard, success: false)
        } else if response.data.functionOk == true && response.data.txApproved == false {
            showErrorPaySaveButton(true, text: Localization.unableToProcessPaymentError)
            payingSavingDelegate?.didPayWithCard(consentId: selectedCard, success: false)
        } else {
            payingSavingDelegate?.didPayWithCard(consentId: selectedCard, success: true)
            close()
            closePaymentSheetDelegate?.shouldCloseScreen()
        }
    }
    
    private func paymentOnlyRespondeHandler(response: CreditCardSaleResponse) {
        if response.data.errorMessage != "" && response.data.errorCode != 0 {
            showErrorPaySaveButton(true, text: Localization.technicalDifficultiesError)
            payingSavingDelegate?.didPayWithCard(consentId: nil, success: false)
        } else if response.data.functionOk == true && response.data.txApproved == false {
            showErrorPaySaveButton(true, text: Localization.unableToProcessPaymentError)
            payingSavingDelegate?.didPayWithCard(consentId: nil, success: false)
        } else {
            payingSavingDelegate?.didPayWithCard(consentId: nil, success: true)
            close()
            closePaymentSheetDelegate?.shouldCloseScreen()
        }
    }
}

//MARK: Error handling
extension AddCardViewController {
    private func hideErrorAfterEditingStarted() {
        if viewModel.saveCardErrorShown {
            self.showErrorPaySaveButton(false)
            viewModel.saveCardErrorShown = false
        } else if viewModel.payCardErrorShown {
            self.showErrorPaySaveButton(false)
            viewModel.payCardErrorShown = false
        }
    }
    private func enablePaySaveButton(_ yes: Bool) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: AddCardTableRow.payButton.rawValue, section: 0)) as? PayActionsTableViewCell else { return }
        cell.enablePayButton(yes)
        cell.showCompleteHint(!yes)
    }
    
    private func showErrorPaySaveButton(_ yes: Bool, text: String? = nil) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: AddCardTableRow.payButton.rawValue, section: 0)) as? PayActionsTableViewCell else { return }
        cell.applyError(yes, text: text)
    }
    
    private func showHint(field: AddCardTableRow) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: field.rawValue, section: 0)) as? SingleHintErrorTableViewCell else { return }
        cell.hintLabel.isHidden = false
    }
    
    private func hideHint(field: AddCardTableRow) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: field.rawValue, section: 0)) as? SingleHintErrorTableViewCell else { return }
        cell.hintLabel.isHidden = true
    }
    
    private func showError(field: AddCardTableRow, text: String) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: field.rawValue, section: 0)) as? SingleHintErrorTableViewCell else { return }
        cell.errorLabel.text = text
        cell.hintLabel.isHidden = true
        cell.errorLabel.isHidden = false
    }
    
    private func hideError(field: AddCardTableRow) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: field.rawValue, section: 0)) as? SingleHintErrorTableViewCell else { return }
        cell.hintLabel.isHidden = true
        cell.errorLabel.isHidden = true
    }
    
    private func showErrorTextField(field: AddCardTableRow) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: field.rawValue, section: 0)) as? SinglePaymentTableViewCell else { return }
        cell.setErrorState()
    }
    
    private func hideErrorTextField(field: AddCardTableRow) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: field.rawValue, section: 0)) as? SinglePaymentTableViewCell else { return }
        cell.setNormalState()
    }
    
    private func showDoubleErrorTextField(field: AddCardTableRow, left: Bool) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: field.rawValue, section: 0)) as? DoublePaymentTableViewCell else { return }
        cell.setErrorState(left: left)
    }
    
    private func hideDoubleErrorTextField(field: AddCardTableRow, left: Bool) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: field.rawValue, section: 0)) as? DoublePaymentTableViewCell else { return }
        cell.setNormalState(left: left)
    }
    
    private func showDoubleError(field: AddCardTableRow, text: String, left: Bool) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: field.rawValue, section: 0)) as? DoubleHintErrorTableViewCell else { return }
        let label = left ? cell.leftError : cell.rightError
        label?.text = text
        label?.isHidden = false
    }
    
    private func hideDoubleError(field: AddCardTableRow, left: Bool) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: field.rawValue, section: 0)) as? DoubleHintErrorTableViewCell else { return }
        let label = left ? cell.leftError : cell.rightError
        label?.isHidden = true
    }
    
    private func showLoading(_ yes: Bool) {
        self.isLoading = yes
        yes
        ? loadingIndicator.startAnimating()
        : loadingIndicator.stopAnimating()
    }
}

//MARK: Validation
extension AddCardViewController {
    //MARK: Cardholder

    private func didBeginEditingValidationCardholder(cell: SinglePaymentTableViewCell, text: String?) {
        if viewModel.shouldShowCardholderHint() && !viewModel.cardholerErrorShown {
            viewModel.cardholerHintShown = true
            showHint(field: .cardHolderErrorHint)
        }
    }
    
    private func didEditingChangedValidationCardholder(cell: SinglePaymentTableViewCell) {
        if viewModel.cardholerErrorShown {
            hideHint(field: .cardHolderErrorHint)
            viewModel.cardholerHintShown = false
        } else if viewModel.shouldShowCardholderHint()  {
            showHint(field: .cardHolderErrorHint)
            viewModel.cardholerHintShown = true
        } else {
            viewModel.cardholerHintShown = false
        }
    }
    
    private func didEndEditingValidationCardholder(cell: SinglePaymentTableViewCell, text: String?) {
        viewModel.cardholerName = text
        viewModel.cardholerHintShown = false
        
        if !viewModel.isCardholerNameCorrect() {
            showError(field: .cardHolderErrorHint, text: Localization.cardHolderErrorMessage)
            showErrorTextField(field: .cardHolder)
            viewModel.cardholerErrorShown = true
        } else {
            hideError(field: .cardHolderErrorHint)
            hideErrorTextField(field: .cardHolder)
            viewModel.cardholerErrorShown = false
        }
    }
    
    //MARK: Card number

    private func didEndEditingValidationCardNumber(cell: SinglePaymentTableViewCell, text: String?) {
        if !viewModel.isCardNumberCorrect() && !viewModel.isCardNumberEmptyNilWhitespace() {
            showError(field: .cardNumberError, text: Localization.invalidCardNumber)
            showErrorTextField(field: .cardNumber)
            viewModel.cardNumberErrorShown = true
        } else {
            hideError(field: .cardNumberError)
            hideErrorTextField(field: .cardNumber)
            viewModel.cardNumberErrorShown = false
        }
    }
    
    //MARK: Address
    
    private func didBeginEditingValidationAddress(cell: SinglePaymentTableViewCell, text: String?) {
        if viewModel.shouldShowAddressHint() && !viewModel.addressErrorShown {
            viewModel.addressHintShown = true
            showHint(field: .addressErrorHint)
        }
    }
    
    private func didEditingChangedValidationAddress(cell: SinglePaymentTableViewCell) {
        if viewModel.addressErrorShown {
            hideHint(field: .addressErrorHint)
            viewModel.addressHintShown = false
        } else if viewModel.shouldShowAddressHint()  {
            showHint(field: .addressErrorHint)
            viewModel.addressHintShown = true
        } else {
            viewModel.addressHintShown = false
        }
    }
    
    private func didEndEditingValidationAddress(cell: SinglePaymentTableViewCell, text: String?) {
        viewModel.address = text
        viewModel.addressHintShown = false
        
        if !viewModel.isAddressCorrect() {
            showError(field: .addressErrorHint, text: Localization.invalidAddressErrorMessage)
            showErrorTextField(field: .address)
            viewModel.addressErrorShown = true
        } else {
            hideError(field: .addressErrorHint)
            hideErrorTextField(field: .address)
            viewModel.addressErrorShown = false
        }
    }
    
    //MARK: Zip
    
    private func didBeginEditingValidationZip(cell: SinglePaymentTableViewCell, text: String?) {
        if viewModel.shouldShowZipHint() && !viewModel.zipErrorShown {
            viewModel.zipHintShown = true
            showHint(field: .zipErrorHint)
        }
    }
    
    private func didEditingChangedValidationZip(cell: SinglePaymentTableViewCell) {
        if viewModel.zipErrorShown {
            hideHint(field: .zipErrorHint)
            viewModel.zipHintShown = false
        } else if viewModel.shouldShowZipHint()  {
            showHint(field: .zipErrorHint)
            viewModel.zipHintShown = true
        } else {
            viewModel.zipHintShown = false
        }
    }
    
    private func didEndEditingValidationZip(cell: SinglePaymentTableViewCell, text: String?) {
        viewModel.zip = text
        viewModel.zipHintShown = false
        validateZip()
    }
    
    private func validateZip() {
        if !viewModel.isZipCorrect() {
            showError(field: .zipErrorHint, text: Localization.invalidZipErrorMessage)
            showErrorTextField(field: .zip)
            viewModel.zipErrorShown = true
        } else {
            hideError(field: .zipErrorHint)
            hideErrorTextField(field: .zip)
            viewModel.zipErrorShown = false
        }
    }
}

extension AddCardViewController: DoublePaymentFieldDelegate {
    func didBeginEditingMonthYear(cell: DoublePaymentTableViewCell, text: String?) {
        hideErrorAfterEditingStarted()
    }
    
    func didBeginEditingCvc(cell: DoublePaymentTableViewCell, text: String?) {
        hideErrorAfterEditingStarted()
    }
    
    func didChangeMonthYearText(cell: DoublePaymentTableViewCell, text: String?) {
        viewModel.monthYear = text
    }
    
    func didEndEditingMonthYear(cell: DoublePaymentTableViewCell, text: String?) {
        viewModel.monthYear = text
        
        if viewModel.isMonthYearEmptyNilWhitespace() {
            hideDoubleError(field: .yearCvcError, left: true)
            hideDoubleErrorTextField(field: .yearCvc, left: true)
            viewModel.monthYearErrorShown = false
            cell.setLeftError(false)
        } else if !viewModel.isValidMonthYearFormat() {
            showDoubleError(field: .yearCvcError, text: Localization.invalidFormat, left: true)
            showDoubleErrorTextField(field: .yearCvc, left: true)
            viewModel.monthYearErrorShown = true
            cell.setLeftError(true)
        } else if !viewModel.isMonthYearNotExpired() {
            showDoubleError(field: .yearCvcError, text: Localization.cardExpired, left: true)
            showDoubleErrorTextField(field: .yearCvc, left: true)
            viewModel.monthYearErrorShown = true
            cell.setLeftError(true)
        } else {
            hideDoubleError(field: .yearCvcError, left: true)
            hideDoubleErrorTextField(field: .yearCvc, left: true)
            viewModel.monthYearErrorShown = false
            cell.setLeftError(false)
        }
        updateTableView()
    }
    
    func didChangeTextCvc(cell: DoublePaymentTableViewCell, text: String?) {
        viewModel.cvc = text
    }
    
    func didEndEditingCvc(cell: DoublePaymentTableViewCell, text: String?) {
        viewModel.cvc = text
        
        if !viewModel.isCvcCorrect() && !viewModel.isCvcEmptyNilWhitespace() {
            showDoubleError(field: .yearCvcError, text: Localization.invalidCvc, left: false)
            showDoubleErrorTextField(field: .yearCvc, left: false)
            viewModel.cvcErrorShown = true
            cell.setRightError(true)
        } else {
            hideDoubleError(field: .yearCvcError, left: false)
            hideDoubleErrorTextField(field: .yearCvc, left: false)
            viewModel.cvcErrorShown = false
            cell.setRightError(false)
        }
        updateTableView()
    }
}
