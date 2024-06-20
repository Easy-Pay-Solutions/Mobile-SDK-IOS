

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
        let alert = UIAlertController(title: "Amount is invalid", message: "Please provide valid amount to pay", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: {_ in })
        alert.addAction(action)
        
        let slideVC = CardSelectionViewController(amount: convertDecimalFormatting(amountTextField.text), paymentDelegate: self, preselectedCardId: 3374, paymentDetails: AddAnnualConsentWidgetModel(merchantId: "1", limitPerCharge: "1000.0", limitLifetime: "10000.0")) ?? alert
        self.present(slideVC, animated: true, completion: nil)
    }
    
    private func convertDecimalFormatting(_ string: String?) -> String {
        guard let string = string else { return "" }
        return string.replacingOccurrences(of: ",", with: ".")
    }
    
}

extension AmountWidgetViewController: CardSelectiontDelegate, CardPaymentDelegate {
    func didSaveCard(consentId: Int?, success: Bool) {}
    func didPayWithCard(consentId: Int?, success: Bool) {
        if success {
            if let presentedVC = self.presentedViewController {
                if presentedVC is UIAlertController {
                    presentedVC.dismiss(animated: false) {
                        self.showSuccessAlert(consentId: consentId)
                    }
                } else {
                    presentedVC.dismiss(animated: true) {
                        self.showSuccessAlert(consentId: consentId)
                    }
                }
            } else {
                showSuccessAlert(consentId: consentId)
            }
        }
    }

    func showSuccessAlert(consentId: Int?) {
        let message = consentId != nil
        ? "Payment successful with consent ID \(String(describing: consentId))"
        : "Payment was successful"
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func didDeleteCard(consentId: Int, success: Bool) {}
    func didSelectCard(consentId: String) {}
}
