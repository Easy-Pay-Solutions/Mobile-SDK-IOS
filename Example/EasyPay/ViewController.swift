
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
            accountHolderEmail: "h4_sam.usevich@gmail.com",
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
            endCustomerEmail: "h4_sam.usevicha@gmail.com",
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
