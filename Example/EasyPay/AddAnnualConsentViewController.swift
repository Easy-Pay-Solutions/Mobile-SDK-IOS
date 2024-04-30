
import UIKit

class AddAnnualConsentViewController: BaseViewController {
    
    private enum TableViewSections: Int, CaseIterable {
        case creditCardDetails = 0
        case accountHolder = 1
        case accountHolderBillingAddress = 2
        case endCustomer = 3
        case endCustomerBillingAddress = 4
        case consentCreator = 5
        case submitButton = 6
    }
    
    var viewModel: AddAnnualConsentViewModel
    
    @IBOutlet weak var tableView: UITableView!
    
    init?(viewModel: AddAnnualConsentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "AddAnnualConsentViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        addGestureForController()
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
        tableView.register(UINib(nibName: AnnualCardInfoTableViewCell.reuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: AnnualCardInfoTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: AmountsTableViewCell.reuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: AmountsTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: CardBillingAddressTableViewCell.reuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: CardBillingAddressTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: ConsentCreatorTableViewCell.reuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: ConsentCreatorTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: SubmitButtonTableViewCell.reuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: SubmitButtonTableViewCell.reuseIdentifier)
    }

}

extension AddAnnualConsentViewController: UITableViewDataSource, UITableViewDelegate, ContactTableViewDelegate, AnnualCardInfoTableViewCellDelegate, CardBillingAddressViewDelegate, ConsentCreatorTableViewCellDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableViewSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.tableView(tableView, addAnnnualConsentForRowAt: indexPath)
    }
    
    private func tableView(_ tableView: UITableView, addAnnnualConsentForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        case .consentCreator:
            return self.tableView(tableView, consentCreatorForRowAt: indexPath)
        case .submitButton:
            return self.tableView(tableView, submitButtonForRowAt: indexPath)
        default:
            return UITableViewCell(frame: .zero)
        }
    }
    
    private func tableView(_ tableView: UITableView, creditCardDetailsForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AnnualCardInfoTableViewCell") as? AnnualCardInfoTableViewCell else { return UITableViewCell(frame: .zero) }
        cell.configureCertificate()
        cell.configureTags()
        cell.delegate = self
        configureTextFieldsForCreditCardDetails(cell: cell)
        return cell
    }
    
    private func tableView(_ tableView: UITableView, accountHolderForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AccountHolderTableViewCell") as? AccountHolderTableViewCell else { return UITableViewCell(frame: .zero) }
        cell.configureAnnualTags(isAccountHolder: true)
        cell.delegate = self
        configureTextFieldsForCustomerData(isAccountHolder: true, cell: cell)
        return cell
    }
    
    private func tableView(_ tableView: UITableView, accountHolderBillingAddressForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardBillingAddressTableViewCell") as? CardBillingAddressTableViewCell else { return UITableViewCell(frame: .zero) }
        cell.configureAnnualTags(isAccountHolder: true)
        cell.delegate = self
        configureTextFieldsForBillingAddress(isAccountHolder: true, cell: cell)
        return cell
    }
    
    private func tableView(_ tableView: UITableView, endCustomerForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AccountHolderTableViewCell") as? AccountHolderTableViewCell else { return UITableViewCell(frame: .zero) }
        cell.configureAnnualTags(isAccountHolder: false)
        cell.delegate = self
        configureTextFieldsForCustomerData(isAccountHolder: false, cell: cell)
        return cell
    }
    
    private func tableView(_ tableView: UITableView, endCustomerBillingAddressForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardBillingAddressTableViewCell") as? CardBillingAddressTableViewCell else { return UITableViewCell(frame: .zero) }
        cell.configureAnnualTags(isAccountHolder: false)
        cell.delegate = self
        configureTextFieldsForBillingAddress(isAccountHolder: false, cell: cell)
        return cell
    }
    
    private func tableView(_ tableView: UITableView, consentCreatorForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConsentCreatorTableViewCell") as? ConsentCreatorTableViewCell else { return UITableViewCell(frame: .zero) }
        cell.configureTags()
        cell.delegate = self
        configureTextFieldsForConsentCreator(cell: cell)
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

        self.viewModel.createAnnualConsent { [weak self] result in
            switch result {
            case .success(let response):
                LoadingIndicator.hideLoadingIndicator()
                if response.data.errorMessage != "" && response.data.errorCode != 0 {
                    self?.showAlert(title: "Error", message: response.data.errorMessage)
                } else {
                    self?.showAlert(title: "Success", message: "Transaction was successful")
                }
            case .failure(let error):
                LoadingIndicator.hideLoadingIndicator()
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    func didChangeText(cell: AnnualCardInfoTableViewCell, text: String?, tag: Int) {
        switch tag {
        case AnnualCreditCardCell.accountNumber.rawValue:
            viewModel.accountNumber = text
        case AnnualCreditCardCell.expMonth.rawValue:
            viewModel.expirationMonth = text
        case AnnualCreditCardCell.expYear.rawValue:
            viewModel.expirationYear = text
        case AnnualCreditCardCell.cvv.rawValue:
            viewModel.cvv = text
        default:
            break
        }
    }
    
    func didChangeText(cell: AccountHolderTableViewCell, text: String?, tag: Int) {
        switch tag {
        case AnnualAccountHolderCell.firstName.rawValue:
            viewModel.accountHolderFirstName = text
        case AnnualAccountHolderCell.lastName.rawValue:
            viewModel.accountHolderLastName = text
        case AnnualAccountHolderCell.company.rawValue:
            viewModel.accountHolderCompany = text
        case AnnualAccountHolderCell.phone.rawValue:
            viewModel.accountHolderPhone = text
        case AnnualAccountHolderCell.email.rawValue:
            viewModel.accountHolderEmail = text
            
        case AnnualEndCustomerCell.firstName.rawValue:
            viewModel.endCustomerFirstName = text
        case AnnualEndCustomerCell.lastName.rawValue:
            viewModel.endCustomerLastName = text
        case AnnualEndCustomerCell.company.rawValue:
            viewModel.endCustomerCompany = text
        case AnnualEndCustomerCell.phone.rawValue:
            viewModel.endCustomerPhone = text
        case AnnualEndCustomerCell.email.rawValue:
            viewModel.endCustomerEmail = text
        default:
            break
        }
    }

    func didChangeText(cell: CardBillingAddressTableViewCell, text: String?, tag: Int) {
        switch tag {
        case AnnualAccountHolderBillingCell.address1.rawValue:
            viewModel.accountHolderAddress1 = text
        case AnnualAccountHolderBillingCell.address2.rawValue:
            viewModel.accountHolderAddress2 = text
        case AnnualAccountHolderBillingCell.city.rawValue:
            viewModel.accountHolderCity = text
        case AnnualAccountHolderBillingCell.state.rawValue:
            viewModel.accountHolderState = text
        case AnnualAccountHolderBillingCell.zip.rawValue:
            viewModel.accountHolderZip = text
        case AnnualAccountHolderBillingCell.country.rawValue:
            viewModel.accountHolderCountry = text
            
        case AnnualEndCustomerBillingCell.address1.rawValue:
            viewModel.endCustomerAddress1 = text
        case AnnualEndCustomerBillingCell.address2.rawValue:
            viewModel.endCustomerAddress2 = text
        case AnnualEndCustomerBillingCell.city.rawValue:
            viewModel.endCustomerCity = text
        case AnnualEndCustomerBillingCell.state.rawValue:
            viewModel.endCustomerState = text
        case AnnualEndCustomerBillingCell.zip.rawValue:
            viewModel.endCustomerZip = text
        case AnnualEndCustomerBillingCell.country.rawValue:
            viewModel.endCustomerCountry = text
        default:
            break
        }
    }
    
    func didChangeText(cell: ConsentCreatorTableViewCell, text: String?, tag: Int) {
        switch tag {
        case AnnualConsentCreatorCell.merchantId.rawValue:
            viewModel.merchantId = text
        case AnnualConsentCreatorCell.customerReferenceId.rawValue:
            viewModel.customerReferenceId = text
        case AnnualConsentCreatorCell.serviceDescription.rawValue:
            viewModel.serviceDescription = text
        case AnnualConsentCreatorCell.rpguid.rawValue:
            viewModel.rpguid = text
        case AnnualConsentCreatorCell.limitPerCharge.rawValue:
            viewModel.limitPerCharge = text
        case AnnualConsentCreatorCell.limitLifetime.rawValue:
            viewModel.limitLifetime = text
        default:
            break
        }
    }
    
    func didChangePicker(date: Date) {
        viewModel.startDate = date
    }
    
    private func configureTextFieldsForCreditCardDetails(cell: AnnualCardInfoTableViewCell) {
        cell.expMonthTextField.text = viewModel.expirationMonth
        cell.expYearTextField.text = viewModel.expirationYear
        cell.cvvTextField.text = viewModel.cvv
    }
    
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
    
    private func configureTextFieldsForConsentCreator(cell: ConsentCreatorTableViewCell) {
        cell.merchantIdTextField.text = viewModel.merchantId
        cell.customerReferenceIdTextField.text = viewModel.customerReferenceId
        cell.serviceDescriptionTextField.text = viewModel.serviceDescription
        cell.rpguidTextField.text = viewModel.rpguid
        cell.limitPerChargeTextField.text = viewModel.limitPerCharge
        cell.limitLifetimeTextField.text = viewModel.limitLifetime
    }
}

enum AnnualCreditCardCell: Int, CaseIterable {
    case accountNumber = 1
    case expMonth = 2
    case expYear = 3
    case cvv = 4
}

enum AnnualAccountHolderCell: Int, CaseIterable {
    case firstName = 5
    case lastName = 6
    case company = 7
    case phone = 8
    case email = 9
}

enum AnnualAccountHolderBillingCell: Int, CaseIterable {
    case address1 = 10
    case address2 = 11
    case city = 12
    case state = 13
    case zip = 14
    case country = 15
}

enum AnnualEndCustomerCell: Int, CaseIterable {
    case firstName = 16
    case lastName = 17
    case company = 18
    case phone = 19
    case email = 20
}

enum AnnualEndCustomerBillingCell: Int, CaseIterable {
    case address1 = 21
    case address2 = 22
    case city = 23
    case state = 24
    case zip = 25
    case country = 26
}

enum AnnualConsentCreatorCell: Int, CaseIterable {
    case merchantId = 27
    case customerReferenceId = 28
    case serviceDescription = 29
    case rpguid = 30
    case startDate = 31
    case limitPerCharge = 33
    case limitLifetime = 34
}
