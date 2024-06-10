
import UIKit
import EasyPay

class ViewController: UIViewController {
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
        let slideVC = CardSelectionViewController(merchantId: "1", amount: "9.86", paymentDelegate: self, preselectedCardId: 3374)
        self.present(slideVC, animated: true, completion: nil)
    }
    
    @IBAction private func managePaymentsSelectionWidgetButtonTapped(_ sender: UIButton) {
        let slideVC = CardSelectionViewController(merchantId: "1", selectionDelegate: self, preselectedCardId: nil)
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

extension ViewController: CardSelectiontDelegate {
    func didDeleteCard(consentId: Int, success: Bool) {}
    func didSelectCard(consentId: String) {}
}
