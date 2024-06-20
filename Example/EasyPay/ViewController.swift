
import UIKit
import EasyPay

class ViewController: BaseViewController {
    let verManager = VersionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func prefilledCreditCardSaleManualButtonTapped(_ sender: UIButton) {
        let vc = CreditCardSaleManualViewController(viewModel: preparePrefilledCreditCardSaleViewModel())
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction private func creditCardSaleManualButtonTapped(_ sender: UIButton) {
        let vc = CreditCardSaleManualViewController(viewModel: CrediCardSaleManualViewModel())
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction private func annualConsentButtonTapped(_ sender: UIButton) {
        let vc = MainManualConsentViewController(viewModel: MainManualConsentViewModel(isPrefilled: false))
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction private func prefilledAnnualConsentButtonTapped(_ sender: UIButton) {
        let vc = MainManualConsentViewController(viewModel: MainManualConsentViewModel(isPrefilled: true))
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction private func managePaymentsWidgetButtonTapped(_ sender: UIButton) {
        let slideVC = AmountWidgetViewController()
        self.present(slideVC, animated: true, completion: nil)
    }
    
    @IBAction private func managePaymentsSelectionWidgetButtonTapped(_ sender: UIButton) {
        let slideVC = CardSelectionViewController(selectionDelegate: self, preselectedCardId: nil, paymentDetails: AddAnnualConsentWidgetModel(merchantId: "1", limitPerCharge: "1000.0", limitLifetime: "10000.0"))
        self.present(slideVC, animated: true, completion: nil)
    }
    
    private func preparePrefilledCreditCardSaleViewModel() -> CrediCardSaleManualViewModel {
        return CrediCardSaleManualViewModel(
            merchantId: "1",
            expirationMonth: "10",
            expirationYear: "26",
            cvv: "999",
            accountHolderFirstName: "Name",
            accountHolderLastName: "Surname",
            accountHolderCompany: "Another company",
            accountHolderPhone: "8775558472",
            accountHolderEmail: "someEmail@gmail.com",
            accountHolderAddress1: "123 Fake St.",
            accountHolderAddress2: "",
            accountHolderCity: "Portland",
            accountHolderState: "ME",
            accountHolderZip: "04005",
            accountHolderCountry: "USA",
            endCustomerFirstName: "Anna",
            endCustomerLastName: "Some surname",
            endCustomerCompany: "",
            endCustomerPhone: "8775558472",
            endCustomerEmail: "someEmail@gmail.com",
            endCustomerAddress1: "123 Fake St.",
            endCustomerAddress2: "",
            endCustomerCity: "Portland",
            endCustomerState: "ME",
            endCustomerZip: "04005",
            endCustomerCountry: "USA",
            totalAmount: "10",
            salesAmount: "0",
            surcharge: "0",
            serviceDescription: "FROM API TESTER",
            clientRefId: "12456",
            rpguid: "3d3424a6-c5f3-4c28")
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension ViewController: CardSelectiontDelegate, CardPaymentDelegate {
    func didSaveCard(consentId: Int?, success: Bool) {}
    func didPayWithCard(consentId: Int?, success: Bool) {
        if success {
            let message = consentId != nil
            ? "Payment successful with consent ID \(String(describing: consentId))"
            : "Payment was successful"
            self.showAlert(title: "Payment successful",
                           accessibilityIdentifier: "paymentSuccessfulAlert",
                           message: message,
                           actionName: "OK",
                           handler: nil)
        }
    }
    func didDeleteCard(consentId: Int, success: Bool) {}
    func didSelectCard(consentId: String) {}
}
