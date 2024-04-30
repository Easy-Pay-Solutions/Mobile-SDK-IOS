
import UIKit
import EasyPay

protocol AnnualCardInfoTableViewCellDelegate: AnyObject {
    func didChangeText(cell: AnnualCardInfoTableViewCell,
                       text: String?,
                       tag: Int)
}

class AnnualCardInfoTableViewCell: UITableViewCell {
    static let reuseIdentifier = "AnnualCardInfoTableViewCell"
    
    @IBOutlet weak var creditCardNumberTextField: SecureTextField!
    @IBOutlet weak var expMonthTextField: UITextField!
    @IBOutlet weak var expYearTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!

    weak var delegate: AnnualCardInfoTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        if #available(iOS 17, *) {
            expMonthTextField.textContentType = .creditCardExpirationMonth
        }
    }
    
    func configureCertificate() {
        creditCardNumberTextField.setupConfig(EasyPay.shared.config)
    }
    
    func configureTags() {
        creditCardNumberTextField.tag = AnnualCreditCardCell.accountNumber.rawValue
        expMonthTextField.tag = AnnualCreditCardCell.expMonth.rawValue
        expYearTextField.tag = AnnualCreditCardCell.expYear.rawValue
        cvvTextField.tag = AnnualCreditCardCell.cvv.rawValue
    }
    
    @IBAction private func textFieldEditingChanged(_ sender: UITextField) {
        delegate?.didChangeText(cell: self,
                                text: sender.text,
                                tag: sender.tag)
    }

    @IBAction private func secureTextFieldEditingChanged(_ sender: SecureTextField) {
        let encryptedData = try? sender.encryptCardData()
        delegate?.didChangeText(cell: self,
                                text: encryptedData,
                                tag: sender.tag)
    }
}
