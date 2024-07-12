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
    func didPayWithCard(consentId: Int?, paymentData: PaymentData?, success: Bool) {
        if success {
            if let presentedVC = self.presentedViewController {
                if presentedVC is UIAlertController {
                    presentedVC.dismiss(animated: false) {
                        self.showSuccessAlert(consentId: consentId, paymentData: paymentData)
                    }
                } else {
                    presentedVC.dismiss(animated: true) {
                        self.showSuccessAlert(consentId: consentId, paymentData: paymentData)
                    }
                }
            } else {
                showSuccessAlert(consentId: consentId, paymentData: paymentData)
            }
        } else {
            showFailureAlert(consentId: consentId)
        }
    }

    func didDeleteCard(consentId: Int, success: Bool) {}
    func didSelectCard(consentId: String) {}

    private func showSuccessAlert(consentId: Int?, paymentData: PaymentData?) {
        let message = consentId != nil
        ? "Payment successful with consent ID: \(String(describing: consentId)), TxID: \(String(describing: paymentData?.txId))"
        : "Payment successful, TxID: \(String(describing: paymentData?.txId))"
        showAlert(title: "Success",
                  accessibilityIdentifier: "paymentSuccessfulAlert",
                  message: message)
    }

    private func showFailureAlert(consentId: Int?) {
        let message = consentId != nil
        ? "Payment failed with consent ID: \(String(describing: consentId))"
        : "Payment failed"
        showAlert(title: "Failure", 
                  accessibilityIdentifier: "paymentFailedAlert",
                  message: message)
    }
}