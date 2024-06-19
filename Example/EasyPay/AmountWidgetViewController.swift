

import UIKit
import EasyPay

class AmountWidgetViewController: BaseViewController {
    
    @IBOutlet private weak var amountTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureForController()
    }
    
    private func addGestureForController() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        amountTextField.endEditing(true)
    }
    
    @IBAction private func managePaymentsWidgetButtonTapped(_ sender: UIButton) {
        let slideVC = CardSelectionViewController(amount: convertDecimalFormatting(amountTextField.text), paymentDelegate: self, preselectedCardId: 3374, paymentDetails: AddAnnualConsentWidgetModel(merchantId: "1", limitPerCharge: "1000.0", limitLifetime: "10000.0"))
        self.present(slideVC, animated: true, completion: nil)
    }
    
    private func convertDecimalFormatting(_ string: String?) -> String {
        guard let string = string else { return "" }
        return string.replacingOccurrences(of: ",", with: ".")
    }
    
}

extension AmountWidgetViewController: CardSelectiontDelegate, CardPaymentDelegate {
    func didSaveCard(consentId: Int?, success: Bool) {}
    func didPayWithCard(consentId: Int, success: Bool) {
        if success {
            if let presentedVC = self.presentedViewController {
                presentedVC.dismiss(animated: false, completion: {
                    self.showSuccessAlert(consentId: consentId)
                })
            } else {
                showSuccessAlert(consentId: consentId)
            }
        }
    }
    func didDeleteCard(consentId: Int, success: Bool) {}
    func didSelectCard(consentId: String) {}
    
    private func showSuccessAlert(consentId: Int) {
        self.showAlert(title: "Payment successful",
                       message: "Paid with consentId: \(consentId)",
                       actionName: "OK",
                       handler: nil)
    }
}
