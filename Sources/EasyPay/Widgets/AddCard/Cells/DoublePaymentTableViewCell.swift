
import UIKit
import EasyPay

protocol DoublePaymentFieldDelegate: AnyObject {
    func didChangeMonthYearText(cell: DoublePaymentTableViewCell,
                                text: String?)
    func didEndEditingMonthYear(cell: DoublePaymentTableViewCell,
                                text: String?)
    func didChangeTextCvc(cell: DoublePaymentTableViewCell,
                          text: String?)
    func didEndEditingCvc(cell: DoublePaymentTableViewCell,
                          text: String?)
    func didBeginEditingMonthYear(cell: DoublePaymentTableViewCell,
                                  text: String?)
    func didBeginEditingCvc(cell: DoublePaymentTableViewCell,
                                 text: String?)
}

class DoublePaymentTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    static let reuseId = "DoublePaymentTableViewCell"
    
    @IBOutlet private weak var leftBorderView: UIView!
    @IBOutlet private weak var rightBorderView: UIView!
    
    @IBOutlet private weak var leftTextFieldStackView: UIStackView!
    @IBOutlet private weak var rightTextFieldStackView: UIStackView!
    
    @IBOutlet private weak var leftClickPlaceholderButton: UIButton!
    @IBOutlet private weak var rightClickPlaceholderButton: UIButton!
    
    @IBOutlet private weak var leftTitleLabel: UILabel!
    @IBOutlet private weak var rightTitleLabel: UILabel!
    
    @IBOutlet private weak var eyeIconButton: UIButton!
    @IBOutlet weak var leftTextField: UITextField!
    @IBOutlet weak var rightTextField: UITextField!
    
    private var isLeftErrorState: Bool = false
    private var isRightErrorState: Bool = false
    
    private var isRightNumbersOnlyAllowed: Bool = false
    private var leftTextMaxChar = 0
    private var rightTextMaxChar = 0
    
    weak var delegate: DoublePaymentFieldDelegate?
    
    func applyData(leftTitle: String,
                   rightTitle: String,
                   leftMaxCharLimit: Int,
                   rightMaxCharLimit: Int,
                   isRightNumbersOnlyAllowed: Bool = false) {
        leftTextField.delegate = self
        rightTextField.delegate = self
        leftTitleLabel.text = leftTitle
        rightTitleLabel.text = rightTitle
        leftTextMaxChar = leftMaxCharLimit
        rightTextMaxChar = rightMaxCharLimit
        self.isRightNumbersOnlyAllowed = isRightNumbersOnlyAllowed
    }
    
    func setErrorState(left: Bool) {
        let stackView = left ? leftTextFieldStackView : rightTextFieldStackView
        let borderView = left ? leftBorderView : rightBorderView
        let textField = left ? leftTextField : rightTextField
        let titleLabel = left ? leftTitleLabel : rightTitleLabel
        
        stackView?.backgroundColor = Theme.Color.errorRedContainer
        borderView?.backgroundColor = Theme.Color.errorRedContainer
        textField?.backgroundColor = Theme.Color.errorRedContainer
        titleLabel?.textColor = Theme.Color.errorRed
        textField?.textColor = Theme.Color.errorRed
        if !left {
            let image = rightTextField.isSecureTextEntry
            ? Theme.Image.eyeIconError
            : Theme.Image.eyeIconCrossedError
            eyeIconButton.setImage(image, for: .normal)
        }
        left ? (isLeftErrorState = true) : (isRightErrorState = true)
    }
    
    func setNormalState(left: Bool) {
        let stackView = left ? leftTextFieldStackView : rightTextFieldStackView
        let borderView = left ? leftBorderView : rightBorderView
        let textField = left ? leftTextField : rightTextField
        let titleLabel = left ? leftTitleLabel : rightTitleLabel
        
        stackView?.backgroundColor = Theme.Color.inputBackground
        borderView?.backgroundColor = Theme.Color.inputBackground
        textField?.backgroundColor = Theme.Color.inputBackground
        titleLabel?.textColor = Theme.Color.textSecondary
        textField?.textColor = Theme.Color.textPrimary
        if !left {
            let image = rightTextField.isSecureTextEntry
            ? Theme.Image.eyeIcon
            : Theme.Image.eyeIconCrossed
            eyeIconButton.setImage(image, for: .normal)
        }
        left ? (isLeftErrorState = false) : (isRightErrorState = false)
    }
    
    func setRightError(_ yes: Bool) {
        isRightErrorState = yes
    }
    
    func setLeftError(_ yes: Bool) {
        isLeftErrorState = yes
    }
    
    @IBAction func eyeIconTapped(_ sender: UIButton) {
        rightTextField.isSecureTextEntry.toggle()
        if isRightErrorState {
            let image = rightTextField.isSecureTextEntry
            ? Theme.Image.eyeIconError
            : Theme.Image.eyeIconCrossedError
            eyeIconButton.setImage(image, for: .normal)
        } else {
            let image = rightTextField.isSecureTextEntry
            ? Theme.Image.eyeIcon
            : Theme.Image.eyeIconCrossed
            eyeIconButton.setImage(image, for: .normal)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == leftTextField {
            let allowedCharacters = CharacterSet(charactersIn: "0123456789/")
            let characterSet = CharacterSet(charactersIn: string)
            if !allowedCharacters.isSuperset(of: characterSet) {
                return false
            }
            
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else {
                return false
            }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            if updatedText.count > 5 {
                return false
            }
            
            if string.isEmpty && range.location == 2 && range.length == 1 {
                textField.text = String(updatedText.dropLast())
                return false
            }
            
            if updatedText.count == 2 && string != "" {
                textField.text = updatedText + "/"
                return false
            }
            
            return true
        } else {
            return UIValidation.containsOnlyNumbers(string) && UIValidation.textLimit(existingText: rightTextField.text,
                                                                                      newText: string,
                                                                                      limit: rightTextMaxChar)
        }
    }
    
    @IBAction private func textFieldEditingChanged(_ sender:
                                                   UITextField) {
        let isLeft = sender == leftTextField
        if isLeft {
            delegate?.didChangeMonthYearText(cell: self, text: sender.text)
        } else {
            delegate?.didChangeTextCvc(cell: self, text: sender.text)
        }
    }
    
    @IBAction private func didStartEditing(_ sender: UITextField) {
        let isLeft = sender == leftTextField
        showBorder(true, left: isLeft)
        if isLeft {
            delegate?.didBeginEditingMonthYear(cell: self, text: sender.text)
        } else {
            delegate?.didBeginEditingCvc(cell: self, text: sender.text)
        }
    }
    
    @IBAction private func didEndEditing(_ sender: UITextField) {
        let isLeft = sender == leftTextField
        showBorder(false, left: isLeft)
        if StringUtils.isNilOrEmpty(sender.text) {
            showOnlyPlaceholder(true, left: isLeft)
        }
        if isLeft {
            delegate?.didEndEditingMonthYear(cell: self, text: sender.text)
        } else {
            delegate?.didEndEditingCvc(cell: self, text: sender.text)
        }
    }
    
    @IBAction private func clickPlaceholderButtonTapped(_ sender: UIButton) {
        if sender == leftClickPlaceholderButton {
            self.showOnlyPlaceholder(false, left: true)
            leftTextField.becomeFirstResponder()
        } else {
            self.showOnlyPlaceholder(false, left: false)
            rightTextField.becomeFirstResponder()
        }
    }
    
    private func showOnlyPlaceholder(_ yes: Bool, left: Bool) {
        animatePlaceholder(show: yes, left: left)
    }
    
    private func animatePlaceholder(show: Bool, left: Bool) {
        let textField = left ? leftTextField : rightTextField
        let button = left ? leftClickPlaceholderButton : rightClickPlaceholderButton
        let stackView = left ? leftTextFieldStackView : rightTextFieldStackView
        
        UIView.animate(withDuration: 0.3, animations: {
            self.setTitleLabelToPlaceholder(show, left: left)
            textField?.alpha = 0.0
        }) { _ in
            UIView.animate(withDuration: 0.3, animations: {
                textField?.isHidden = show
                button?.isEnabled = show
                stackView?.setNeedsLayout()
                stackView?.layoutIfNeeded()
            }) { _ in
                self.setAlphaAfterAnimation(left: left)
            }
        }
    }
    
    private func setTitleLabelToPlaceholder(_ yes: Bool, left: Bool) {
        let titleLabel = left ? leftTitleLabel : rightTitleLabel
        titleLabel?.font = yes
        ? Theme.Font.body3Regular
        : Theme.Font.supportiveText
    }
    
    private func showBorder(_ yes: Bool, left: Bool) {
        let errorState = left ? isLeftErrorState : isRightErrorState
        let borderView = left ? leftBorderView : rightBorderView
        UIView.animate(withDuration: 0.3, animations: {
            borderView?.layer.borderWidth = yes ? 1.0 : 0.0
            borderView?.layer.borderColor = errorState
            ? Theme.Color.errorRed.cgColor
            : Theme.Color.textSecondary.cgColor
        })
    }
    
    private func setAlphaAfterAnimation(left: Bool) {
        let textField = left ? leftTextField : rightTextField
        textField?.alpha = 1.0
    }
}
