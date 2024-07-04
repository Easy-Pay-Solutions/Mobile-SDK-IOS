
import UIKit

@objc protocol PayActionsDelegate: AnyObject {
    func didTapPay(_ sender: UIButton)
    func didTapCheckbox(_ sender: UIButton)
}

class PayActionsTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var completeLabel: UILabel!
    @IBOutlet private weak var checkboxStack: UIStackView!
    @IBOutlet private weak var completeHintStack: UIStackView!
    @IBOutlet private weak var checkboxButton: UIButton!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var payButton: UIButton!
    weak var delegate: PayActionsDelegate?

    static let reuseId = "PayActionsTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
        enablePayButton(false)
    }
    
    private func applyDesign() {
        payButton.layer.cornerRadius = 8.0
        errorLabel.isHidden = true
        
        checkboxButton.layer.borderWidth = 1
        checkboxButton.layer.cornerRadius = 4.0
        checkboxButton.layer.borderColor = Theme.Color.checkboxBorder.cgColor
    }
    
    func applyState(state: AddCardState, amount: String) {
        checkboxStack.isHidden = state == .saveOnly
        if state == .payAndSave {
            applyAmount(amount: amount)
            completeLabel.text = Localization.completeAllFieldsToPay
        } else {
            payButton.setTitle(Localization.saveCard, for: .normal)
            completeLabel.text = Localization.completeAllFieldsToSave
            errorLabel.text = Localization.unableToSaveCardDetailsError
        }
    }
    
    private func applyAmount(amount: String) {
        payButton.setTitle("\(Localization.pay$)\(amount)", for: .normal)
    }
    
    func applyError(_ yes: Bool, text: String?) {
        if let text {
            errorLabel.text = text
        }
        errorLabel.isHidden = !yes
        payButton.isEnabled = !yes
        let backgroundColor: UIColor = yes ? Theme.Color.errorRedContainer : Theme.Color.confirmationGreen
        let fontColor: UIColor = yes ? Theme.Color.errorRed : .white
        payButton.backgroundColor = backgroundColor
        payButton.setTitleColor(fontColor, for: .normal)
        showCompleteHint(!yes)
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
    }

    func showCompleteHint(_ yes: Bool) {
        completeHintStack.isHidden = !yes
    }
    
    func enablePayButton(_ yes: Bool) {
        payButton.isEnabled = yes
        payButton.backgroundColor = yes
        ? Theme.Color.confirmationGreen
        : Theme.Color.buttonDisabled
        let titleColor = yes
        ? UIColor.white
        : Theme.Color.textTertiary
        payButton.setTitleColor(titleColor, for: .normal)
    }
    
    @IBAction private func payButtonClicked(_ sender: UIButton) {
        delegate?.didTapPay(sender)
    }

    func applyCheckboxButtonTag(tag: Int) {
        checkboxButton.tag = tag
    }
    
    func applySelectedState(_ isSelected: Bool) {
        let checkboxImage = isSelected
        ? Theme.Image.check
        : nil
        checkboxButton.setImage(checkboxImage, for: .normal)
        
        let backgroundColor: UIColor = isSelected
        ? Theme.Color.technologyBlue2
        : Theme.Color.checkboxBackground
        let borderColor: UIColor = isSelected
        ? Theme.Color.technologyBlue2
        : Theme.Color.checkboxBorder

        checkboxButton.backgroundColor = backgroundColor
        checkboxButton.isSelected = isSelected
        checkboxButton.layer.borderColor = borderColor.cgColor
    }

    @IBAction private func checkboxButtonTapped(_ sender: UIButton) {
        delegate?.didTapCheckbox(sender)
        applySelectedState(sender.isSelected)
    }
}
