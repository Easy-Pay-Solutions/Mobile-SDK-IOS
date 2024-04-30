
import UIKit
import EasyPay

class CreditCardSaleManualViewController: BaseViewController, CreditCardDetailsTableViewDelegate, CardBillingAddressViewDelegate, AmountsTableViewCellViewDelegate, PurchItemsTableViewCellDelegate {
    
    private enum TableViewSections: Int, CaseIterable {
        case creditCardDetails = 0
        case accountHolder = 1
        case accountHolderBillingAddress = 2
        case endCustomer = 3
        case endCustomerBillingAddress = 4
        case amounts = 5
        case purchItems = 6
        case submitButton = 7
    }
    
    private let viewModel: CrediCardSaleManualViewModel
    
    @IBOutlet private weak var tableView: UITableView!
    
    init?(viewModel: CrediCardSaleManualViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "CreditCardSaleManualViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        addGestureForController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if EasyPay.shared.apiClient.certificateStatus != .success {
            LoadingIndicator.showLoadingIndicator()
            viewModel.downloadCertificate { [weak self] result in
                LoadingIndicator.hideLoadingIndicator()
                switch result {
                case .success(_):
                    self?.tableView.reloadData()
                case .failure(let error):
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
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
    
    private func configureTableView() {
        tableView.register(UINib(nibName: AccountHolderTableViewCell.reuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: AccountHolderTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: CreditCardManualTableViewCell.reuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: CreditCardManualTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: AmountsTableViewCell.reuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: AmountsTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: CardBillingAddressTableViewCell.reuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: CardBillingAddressTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: PurchItemsTableViewCell.reuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: PurchItemsTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: SubmitButtonTableViewCell.reuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: SubmitButtonTableViewCell.reuseIdentifier)
    }
}

extension CreditCardSaleManualViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableViewSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.tableView(tableView, changePaymentForRowAt: indexPath)
    }
    
    private func tableView(_ tableView: UITableView, changePaymentForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch TableViewSections(rawValue: indexPath.row) {
        case .creditCardDetails:
            return self.tableView(tableView, creditCardDetailsForRowAt: indexPath)
        case .accountHolder:
            return self.tableView(tableView, accountHolderForRowAt: indexPath)
        case .accountHolderBillingAddress:
            return self.tableView(tableView, accountHolderBillingAddressForRowAt: indexPath)
        case .endCustomer:
            return self.tableView(tableView, endCustomerForRowAt: indexPath)
        case .endCustomerBillingAddress:
            return self.tableView(tableView, endCustomerBillingAddressForRowAt: indexPath)
        case .amounts:
            return self.tableView(tableView, amountsForRowAt: indexPath)
        case .purchItems:
            return self.tableView(tableView, purchItemsForRowAt: indexPath)
        case .submitButton:
            return self.tableView(tableView, submitButtonForRowAt: indexPath)
        default:
            return UITableViewCell(frame: .zero)
        }
    }
    
    private func tableView(_ tableView: UITableView, creditCardDetailsForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CreditCardManualTableViewCell") as? CreditCardManualTableViewCell else { return UITableViewCell(frame: .zero) }
        cell.configureCertificate()
        cell.configureTags()
        cell.delegate = self
        cell.merchantIdTextField.text = viewModel.merchantId
        cell.creditCardNumberTextField.text = viewModel.accountNumber
        cell.expMonthTextField.text = viewModel.expirationMonth
        cell.expYearTextField.text = viewModel.expirationYear
        cell.cvvTextField.text = viewModel.cvv
        return cell
    }
    
    private func tableView(_ tableView: UITableView, accountHolderForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AccountHolderTableViewCell") as? AccountHolderTableViewCell else { return UITableViewCell(frame: .zero) }
        cell.configureTags(isAccountHolder: true)
        cell.delegate = self
        configureTextFieldsForCustomerData(isAccountHolder: true, cell: cell)
        return cell
    }
    
    private func tableView(_ tableView: UITableView, accountHolderBillingAddressForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardBillingAddressTableViewCell") as? CardBillingAddressTableViewCell else { return UITableViewCell(frame: .zero) }
        cell.configureTags(isAccountHolder: true)
        cell.delegate = self
        configureTextFieldsForBillingAddress(isAccountHolder: true, cell: cell)
        return cell
    }
    
    private func tableView(_ tableView: UITableView, endCustomerForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AccountHolderTableViewCell") as? AccountHolderTableViewCell else { return UITableViewCell(frame: .zero) }
        cell.configureTags(isAccountHolder: false)
        cell.delegate = self
        configureTextFieldsForCustomerData(isAccountHolder: false, cell: cell)
        return cell
    }
    
    private func tableView(_ tableView: UITableView, endCustomerBillingAddressForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardBillingAddressTableViewCell") as? CardBillingAddressTableViewCell else { return UITableViewCell(frame: .zero) }
        cell.configureTags(isAccountHolder: false)
        cell.delegate = self
        configureTextFieldsForBillingAddress(isAccountHolder: false, cell: cell)
        return cell
    }
    
    private func tableView(_ tableView: UITableView, amountsForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AmountsTableViewCell") as? AmountsTableViewCell else { return UITableViewCell(frame: .zero) }
        cell.configureTags()
        cell.delegate = self
        configureTextFieldsForAmounts(cell: cell)
        return cell
    }
    
    private func tableView(_ tableView: UITableView, purchItemsForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PurchItemsTableViewCell") as? PurchItemsTableViewCell else { return UITableViewCell(frame: .zero) }
        cell.configureTags()
        cell.delegate = self
        configureTextFieldsForPurchaseItems(cell: cell)
        return cell
    }
    
    private func tableView(_ tableView: UITableView, submitButtonForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitButtonTableViewCell") as? SubmitButtonTableViewCell else { return UITableViewCell(frame: .zero) }
        cell.submitButton.addTarget(self, action: #selector(submitButton), for: .touchUpInside)
        return cell
    }
    
    @objc private func submitButton() {
        tableView.endEditing(true)
        LoadingIndicator.showLoadingIndicator()

        self.viewModel.chargeCard { [weak self] result in
            switch result {
            case .success(let response):
                LoadingIndicator.hideLoadingIndicator()
                if response.data.errorMessage != "" && response.data.errorCode != 0 {
                    self?.showAlert(title: "Error", message: response.data.errorMessage)
                } else if response.data.functionOk == true && response.data.txApproved == false {
                    self?.showAlert(title: "Decline", message: "Transaction was declined")
                } else {
                    self?.showAlert(title: "Success", message: "Transaction was successful")
                }
            case .failure(let error):
                LoadingIndicator.hideLoadingIndicator()
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}

enum CreditCardSaleManualCells: Int, CaseIterable {
    case merchId = 1
    case accountNumber = 2
    case expMonth = 3
    case expYear = 4
    case cvv = 5
}

enum AccountHolderCells: Int, CaseIterable {
    case accountHolderFirstName = 6
    case accountHolderLastName = 7
    case accountHolderCompany = 8
    case accountHolderPhone = 11
    case accountHolderEmail = 12
}

enum AccountHolderBillingCells: Int, CaseIterable {
    case accountHolderAddress1 = 13
    case accountHolderAddress2 = 14
    case accountHolderCity = 15
    case accountHolderState = 16
    case accountHolderZip = 17
    case accountHolderCountry = 18
}

enum EndCustomerCells: Int, CaseIterable {
    case endCustomerFirstName = 19
    case endCustomerLastName = 20
    case endCustomerCompany = 21
    case endCustomerPhone = 24
    case endCustomerEmail = 25
}

enum EndCustomerBillingCells: Int, CaseIterable {
    case endCustomerAddress1 = 26
    case endCustomerAddress2 = 27
    case endCustomerCity = 28
    case endCustomerState = 29
    case endCustomerZip = 30
    case endCustomerCountry = 31
}

enum AmountsBillingCells: Int, CaseIterable {
    case totalAmount = 32
    case salesAmount = 33
    case surchargeAmount = 34
}

enum PurchaseItemsCells: Int, CaseIterable {
    case serviceDesription = 42
    case clientRefId = 43
    case rpguid = 44
}

extension CreditCardSaleManualViewController: ContactTableViewDelegate {
    private func configureTextFieldsForCustomerData(isAccountHolder: Bool, cell: AccountHolderTableViewCell) {
        if isAccountHolder {
            cell.firstNameTextField.text = viewModel.accountHolderFirstName
            cell.lastNameTextField.text = viewModel.accountHolderLastName
            cell.companyTextField.text = viewModel.accountHolderCompany
            cell.phoneTextField.text = viewModel.accountHolderPhone
            cell.emailTextField.text = viewModel.accountHolderEmail
        } else {
            cell.firstNameTextField.text = viewModel.endCustomerFirstName
            cell.lastNameTextField.text = viewModel.endCustomerLastName
            cell.companyTextField.text = viewModel.endCustomerCompany
            cell.phoneTextField.text = viewModel.endCustomerPhone
            cell.emailTextField.text = viewModel.endCustomerEmail
        }
    }
    
    private func configureTextFieldsForBillingAddress(isAccountHolder: Bool, cell: CardBillingAddressTableViewCell) {
        if isAccountHolder {
            cell.address1TextField.text = viewModel.accountHolderAddress1
            cell.address2TextField.text = viewModel.accountHolderAddress2
            cell.cityTextField.text = viewModel.accountHolderCity
            cell.stateTextField.text = viewModel.accountHolderState
            cell.zipTextField.text = viewModel.accountHolderZip
            cell.countryTextField.text = viewModel.accountHolderCountry
        } else {
            cell.address1TextField.text = viewModel.endCustomerAddress1
            cell.address2TextField.text = viewModel.endCustomerAddress2
            cell.cityTextField.text = viewModel.endCustomerCity
            cell.stateTextField.text = viewModel.endCustomerState
            cell.zipTextField.text = viewModel.endCustomerZip
            cell.countryTextField.text = viewModel.endCustomerCountry
        }
    }
    
    private func configureTextFieldsForAmounts(cell: AmountsTableViewCell) {
        cell.totalAmount.text = viewModel.totalAmount
        cell.salesAmount.text = viewModel.salesAmount
        cell.surchargeTextField.text = viewModel.surcharge
    }
    
    private func configureTextFieldsForPurchaseItems(cell: PurchItemsTableViewCell) {
        cell.serviceDescriptionTextField.text = viewModel.serviceDescription
        cell.clientRefIdTextField.text = viewModel.clientRefId
        cell.rpguidTextField.text = viewModel.rpguid
    }
    
    func didChangeText(cell: CreditCardManualTableViewCell, text: String?, tag: Int) {
        switch tag {
        case CreditCardSaleManualCells.merchId.rawValue:
            viewModel.merchantId = text
        case CreditCardSaleManualCells.accountNumber.rawValue:
            viewModel.accountNumber = text
        case CreditCardSaleManualCells.expMonth.rawValue:
            viewModel.expirationMonth = text
        case CreditCardSaleManualCells.expYear.rawValue:
            viewModel.expirationYear = text
        case CreditCardSaleManualCells.cvv.rawValue:
            viewModel.cvv = text
        default:
            break
        }
    }
    
    func didChangeText(cell: AccountHolderTableViewCell, text: String?, tag: Int) {
        switch tag {
        case AccountHolderCells.accountHolderFirstName.rawValue:
            viewModel.accountHolderFirstName = text
        case AccountHolderCells.accountHolderLastName.rawValue:
            viewModel.accountHolderLastName = text
        case AccountHolderCells.accountHolderCompany.rawValue:
            viewModel.accountHolderCompany = text
        case AccountHolderCells.accountHolderPhone.rawValue:
            viewModel.accountHolderPhone = text
        case AccountHolderCells.accountHolderEmail.rawValue:
            viewModel.accountHolderEmail = text
            
        case EndCustomerCells.endCustomerFirstName.rawValue:
            viewModel.endCustomerFirstName = text
        case EndCustomerCells.endCustomerLastName.rawValue:
            viewModel.endCustomerLastName = text
        case EndCustomerCells.endCustomerCompany.rawValue:
            viewModel.endCustomerCompany = text
        case EndCustomerCells.endCustomerPhone.rawValue:
            viewModel.endCustomerPhone = text
        case EndCustomerCells.endCustomerEmail.rawValue:
            viewModel.endCustomerEmail = text
        default:
            break
        }
    }
    
    func didChangeText(cell: CardBillingAddressTableViewCell, text: String?, tag: Int) {
        switch tag {
        case AccountHolderBillingCells.accountHolderAddress1.rawValue:
            viewModel.accountHolderAddress1 = text
        case AccountHolderBillingCells.accountHolderAddress2.rawValue:
            viewModel.accountHolderAddress2 = text
        case AccountHolderBillingCells.accountHolderCity.rawValue:
            viewModel.accountHolderCity = text
        case AccountHolderBillingCells.accountHolderState.rawValue:
            viewModel.accountHolderState = text
        case AccountHolderBillingCells.accountHolderZip.rawValue:
            viewModel.accountHolderZip = text
        case AccountHolderBillingCells.accountHolderCountry.rawValue:
            viewModel.accountHolderCountry = text
            
        case EndCustomerBillingCells.endCustomerAddress1.rawValue:
            viewModel.endCustomerAddress1 = text
        case EndCustomerBillingCells.endCustomerAddress2.rawValue:
            viewModel.endCustomerAddress2 = text
        case EndCustomerBillingCells.endCustomerCity.rawValue:
            viewModel.endCustomerCity = text
        case EndCustomerBillingCells.endCustomerState.rawValue:
            viewModel.endCustomerState = text
        case EndCustomerBillingCells.endCustomerZip.rawValue:
            viewModel.endCustomerZip = text
        case EndCustomerBillingCells.endCustomerCountry.rawValue:
            viewModel.endCustomerCountry = text
        default:
            break
        }
    }
    
    func didChangeText(cell: AmountsTableViewCell, text: String?, tag: Int) {
        switch tag {
        case AmountsBillingCells.totalAmount.rawValue:
            viewModel.totalAmount = text
        case AmountsBillingCells.salesAmount.rawValue:
            viewModel.salesAmount = text
        case AmountsBillingCells.surchargeAmount.rawValue:
            viewModel.surcharge = text
        default:
            break
        }
    }
    
    func didChangeText(cell: PurchItemsTableViewCell, text: String?, tag: Int) {
        switch tag {
        case PurchaseItemsCells.serviceDesription.rawValue:
            viewModel.serviceDescription = text
        case PurchaseItemsCells.clientRefId.rawValue:
            viewModel.clientRefId = text
        case PurchaseItemsCells.rpguid.rawValue:
            viewModel.rpguid = text
        default:
            break
        }
    }
}
