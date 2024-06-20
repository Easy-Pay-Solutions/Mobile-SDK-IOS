
import UIKit
import EasyPay

protocol SinglePaymentFieldDelegate: AnyObject {
    func didChangeText(cell: SinglePaymentTableViewCell,
                       text: String?)
    func didEndEditing(cell: SinglePaymentTableViewCell,
                       text: String?)
    func didBeginEditing(cell: SinglePaymentTableViewCell,
                         text: String?)
}

class SinglePaymentTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    static let reuseId = "SinglePaymentTableViewCell"
    
    @IBOutlet private weak var borderView: UIView!
    @IBOutlet private weak var textFieldStackView: UIStackView!
    @IBOutlet private weak var clickPlaceholderButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var leftIcon: UIImageView!
    @IBOutlet weak var textField: UITextField!
    private var isSecureTextEntryEnabled: Bool = false
    private var isErrorState: Bool = false
    private var isNumbersOnlyAllowed: Bool = false
    var textMaxChar = 0
    weak var delegate: SinglePaymentFieldDelegate?

    func applyData(title: String,
                   showCardIcon: Bool = false,
                   maxCharLimit: Int,
                   keyboardType: UIKeyboardType = .default,
                   isNumbersOnlyAllowed: Bool = false,
                   isSecureTextEntryEnabled: Bool = false) {
        textField.delegate = self
        textField.keyboardType = keyboardType
        titleLabel.text = title
        titleLabel.accessibilityIdentifier = title
        leftIcon.isHidden = !showCardIcon
        textMaxChar = maxCharLimit
        self.isNumbersOnlyAllowed = isNumbersOnlyAllowed
        self.isSecureTextEntryEnabled = isSecureTextEntryEnabled
    }
    
    func setErrorState() {
        isErrorState = true
        leftIcon.image = Theme.Image.creditCardError
        textFieldStackView.backgroundColor = Theme.Color.errorRedContainer
        borderView.backgroundColor = Theme.Color.errorRedContainer
        textField.backgroundColor = Theme.Color.errorRedContainer
        titleLabel.textColor = Theme.Color.errorRed
        textField.textColor = Theme.Color.errorRed
        if isSecureTextEntryEnabled {
            textField.isSecureTextEntry = false
        }
    }
    
    func setNormalState() {
        isErrorState = false
        leftIcon.image = Theme.Image.creditCard
        textFieldStackView.backgroundColor = Theme.Color.inputBackground
        borderView.backgroundColor = Theme.Color.inputBackground
        textField.backgroundColor = Theme.Color.inputBackground
        titleLabel.textColor = Theme.Color.textSecondary
        textField.textColor = Theme.Color.textPrimary
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        
        if isNumbersOnlyAllowed {
            return UIValidation.containsOnlyNumbers(string) && UIValidation.textLimit(existingText: currentText,
                                                                                      newText: string,
                                                                                      limit: textMaxChar)
        }
        
        return UIValidation.textLimit(existingText: currentText,
                                      newText: string,
                                      limit: textMaxChar)
    }
    
    
    @IBAction private func didStartEditing(_ sender: UITextField) {
        showBorder(true)
        if isSecureTextEntryEnabled {
            textField.isSecureTextEntry = false
        }
        delegate?.didBeginEditing(cell: self, text: sender.text)
    }
    
    @IBAction private func didEndEditing(_ sender: UITextField) {
        showBorder(false)
        if isSecureTextEntryEnabled {
            textField.isSecureTextEntry = true
        }

        if StringUtils.isNilOrEmpty(textField.text) {
            showOnlyPlaceholder(true)
        }
        delegate?.didEndEditing(cell: self, text: sender.text)
    }
    
    
    @IBAction private func textFieldEditingChanged(_ sender: UITextField) {
        delegate?.didChangeText(cell: self, text: sender.text)
    }
    
    @IBAction func clickPlaceholderButtonTapped(_ sender: UIButton) {
        self.showOnlyPlaceholder(false)
        textField.becomeFirstResponder()
    }
    
    func showOnlyPlaceholder(_ yes: Bool) {
        animatePlaceholder(show: yes)
    }
    
    private func animatePlaceholder(show: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            self.setTitleLabelToPlaceholder(show)
            self.textField.alpha = 0.0
        }) { _ in
            UIView.animate(withDuration: 0.3, animations: {
                self.textField.isHidden = show
                self.clickPlaceholderButton.isEnabled = show
                self.textFieldStackView.setNeedsLayout()
                self.textFieldStackView.layoutIfNeeded()
            }) { _ in
                self.setAlphaAfterAnimation()
            }
        }
    }
    
    private func setTitleLabelToPlaceholder(_ yes: Bool) {
        titleLabel.font = yes
        ? Theme.Font.body3Regular
        : Theme.Font.supportiveText
    }
    
    private func showBorder(_ yes: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            self.borderView.layer.borderWidth = yes ? 1.0 : 0.0
            self.borderView.layer.borderColor = self.isErrorState
            ? Theme.Color.errorRed.cgColor
            : Theme.Color.textSecondary.cgColor
        })
    }
    
    private func setAlphaAfterAnimation() {
        self.textField.alpha = 1.0
    }
}
