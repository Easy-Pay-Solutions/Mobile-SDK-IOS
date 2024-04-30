
import UIKit
import EasyPay

class MainManualConsentViewController: BaseViewController {
    private let viewModel: MainManualConsentViewModel
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LoadingIndicator.showLoadingIndicator()
        viewModel.downloadAnnualConsents { [weak self] result in
            LoadingIndicator.hideLoadingIndicator()
            switch result {
            case .success(_):
                self?.tableView.reloadData()
            case .failure(let error):
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    init?(viewModel: MainManualConsentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "MainManualConsentViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction private func addCardButtonTapped(_ sender: UIButton) {
        var vc = AddAnnualConsentViewController(viewModel: AddAnnualConsentViewModel())

        if viewModel.isPrefilled {
            let prefilledViewModel = AddAnnualConsentViewModel(
                expirationMonth: "10",
                expirationYear: "26",
                cvv: "989",
                accountHolderFirstName: "Name",
                accountHolderLastName: "Surname",
                accountHolderCompany: "Some company",
                accountHolderPhone: "8775558472",
                accountHolderEmail: "h4_sam.usevicha@gmail.com",
                endCustomerFirstName: "Name",
                endCustomerLastName: "Surname",
                endCustomerCompany: "Some company",
                endCustomerPhone: "8775558472",
                endCustomerEmail: "h4_sam.usevicha@gmail.com",
                accountHolderAddress1: "123 Fake St.",
                accountHolderAddress2: "",
                accountHolderCity: "Portland",
                accountHolderState: "ME",
                accountHolderZip: "04005",
                accountHolderCountry: "USA",
                endCustomerAddress1: "123 Fake St.",
                endCustomerAddress2: "",
                endCustomerCity: "Portland",
                endCustomerState: "ME",
                endCustomerZip: "04005",
                endCustomerCountry: "USA",
                merchantId: "1",
                customerReferenceId: "12456",
                serviceDescription: "FROM API TESTER",
                rpguid: "3d3424a6-c5f3-4c28",
                numberOfDays: "365",
                limitPerCharge: "1000",
                limitLifetime: "100000")
            vc = AddAnnualConsentViewController(viewModel: prefilledViewModel)
        }
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    private func configureTableView() {
        tableView.register(UINib(nibName: CardDetailsTableViewCell.reuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: CardDetailsTableViewCell.reuseIdentifier)
    }
}

extension MainManualConsentViewController: UITableViewDelegate, UITableViewDataSource, ConsentCellDelegate {
    func deleteConsent(at index: Int) {
        if let consentId = viewModel.annualConData?.consents?[index].id {
            LoadingIndicator.showLoadingIndicator()
            viewModel.deleteAnnualConsent(consentId: consentId) { [weak self] result in
                LoadingIndicator.hideLoadingIndicator()
                switch result {
                case .success(_):
                    LoadingIndicator.showLoadingIndicator()
                    self?.viewModel.downloadAnnualConsents { [weak self] result in
                        LoadingIndicator.hideLoadingIndicator()
                        switch result {
                        case .success(let response):
                            LoadingIndicator.hideLoadingIndicator()
                            if response.data.errorMessage != "" && response.data.errorCode != 0 {
                                self?.showAlert(title: "Error", message: response.data.errorMessage ?? "")
                            } else {
                                self?.showAlert(title: "Success", message: "Consent was deleted successfully")
                            }
                            self?.tableView.reloadData()
                        case .failure(let error):
                            self?.tableView.reloadData()
                            self?.showAlert(title: "Error", message: error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    func chargeConsent(at index: Int) {
        showInputDialog(title: "Charge a card",
                        subtitle: "Please enter the charge amount below.",
                        actionTitle: "Charge",
                        cancelTitle: "Cancel",
                        inputPlaceholder: "Charge amount",
                        inputKeyboardType: .decimalPad, actionHandler:
                            { (input: String?) in
            if let consentId = self.viewModel.annualConData?.consents?[index].id, let input = input, !StringUtils.isNilOrEmpty(input) {
                LoadingIndicator.showLoadingIndicator()
                self.viewModel.chargeAnnualConsent(consentId: consentId, processAmount: input) { [weak self] result in
                    LoadingIndicator.hideLoadingIndicator()
                    switch result {
                    case .success(let response):
                        LoadingIndicator.hideLoadingIndicator()
                        if response.data.errorMessage != "" && response.data.errorCode != 0 {
                            self?.showAlert(title: "Error", message: response.data.errorMessage ?? "")
                        } else {
                            self?.showAlert(title: "Success", message: "Transaction was successful")
                        }
                    case .failure(let error):
                        self?.showAlert(title: "Error", message: error.localizedDescription)
                    }
                }
            } else if StringUtils.isNilOrEmpty(input) {
                self.showAlert(title: "Error", message: "Please enter valid charge amount")
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.annualConData?.consents?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardDetailsTableViewCell") as? CardDetailsTableViewCell else { return UITableViewCell(frame: .zero) }
        if let consents = viewModel.annualConData?.consents {
            cell.applyData(consentAnnual: consents[indexPath.row], tag: indexPath.row)
        }
        cell.tag = indexPath.row
        cell.delegate = self
        return cell
    }
}
