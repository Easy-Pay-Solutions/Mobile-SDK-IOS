import UIKit
import EasyPay

class WidgetParametersViewController: BaseViewController {

    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var amountTextField: UITextField!
    @IBOutlet private weak var customerRefIdTextField: UITextField!
    @IBOutlet private weak var actionButton: UIButton!

    private let state: ManageCardState

    init?(state: ManageCardState) {
        self.state = state
        super.init(nibName: "WidgetParametersViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureForController()
        initComponents()
    }

    // MARK: - IBActions

    @IBAction private func managePaymentsWidgetButtonTapped(_ sender: UIButton) {
        let alert = createErrorAlert()
        let slideVC = createWidget() ?? alert
        self.present(slideVC, animated: true, completion: nil)
    }

    // MARK: - Widgets creation

    private func createWidget() -> UIViewController? {
        switch state {
        case .selection:
            return createSelectionWidget()
        case .payment:
            return createPaymentWidget()
        }
    }

    private func createSelectionWidget() -> UIViewController? {
        return CardSelectionViewController(selectionDelegate: self,
                                           preselectedCardId: 3374,
                                           paymentDetails: getWidgetViewModel())
    }

    private func createPaymentWidget() -> UIViewController? {
        let amount = convertDecimalFormatting(amountTextField.text)
        return CardSelectionViewController(amount: amount,
                                           paymentDelegate: self,
                                           preselectedCardId: 3374,
                                           paymentDetails: getWidgetViewModel())
    }

    private func getWidgetViewModel() -> AddAnnualConsentWidgetModel {
        let customerRefId = customerRefIdTextField.text ?? ""
        return AddAnnualConsentWidgetModel(merchantId: "1",
                                           customerReferenceId: customerRefId,
                                           limitPerCharge: "1000.0",
                                           limitLifetime: "10000.0")
    }

    // MARK: - Components init

    private func initComponents() {
        switch state {
        case .selection:
            initSelectionComponents()
        case .payment:
            initPaymentComponents()
        }
    }

    private func initSelectionComponents() {
        actionButton.setTitle("Manage Payments", for: .normal)
        amountTextField.isHidden = true
        amountLabel.isHidden = true
    }

    private func initPaymentComponents() {
        actionButton.setTitle("Pay", for: .normal)
    }

    // MARK: - Helpers

    private func createErrorAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Parameters are invalid",
                                      message: "Please provide all parameters properly",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: {_ in })
        alert.addAction(action)
        return alert
    }

    private func convertDecimalFormatting(_ string: String?) -> String {
        guard let string = string else { return "" }
        return string.replacingOccurrences(of: ",", with: ".")
    }

    @objc private func hideKeyboard() {
        amountTextField.endEditing(true)
        customerRefIdTextField.endEditing(true)
    }

    private func addGestureForController() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        self.view.addGestureRecognizer(tapGesture)
    }
}

extension WidgetParametersViewController: CardSelectiontDelegate, CardPaymentDelegate {
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
        alert.view.accessibilityIdentifier = "paymentSuccessfulAlert"
        self.present(alert, animated: true, completion: nil)
    }

    func didDeleteCard(consentId: Int, success: Bool) {}
    func didSelectCard(consentId: String) {}
}
