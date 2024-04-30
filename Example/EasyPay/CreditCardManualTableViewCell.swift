
import UIKit
import EasyPay

protocol CreditCardDetailsTableViewDelegate: AnyObject {
    func didChangeText(cell: CreditCardManualTableViewCell,
                       text: String?,
                       tag: Int)
}

class CreditCardManualTableViewCell: UITableViewCell {
    static let reuseIdentifier = "CreditCardManualTableViewCell"
    
    @IBOutlet weak var creditCardNumberTextField: SecureTextField!
    @IBOutlet weak var merchantIdTextField: UITextField!
    @IBOutlet weak var expMonthTextField: UITextField!
    @IBOutlet weak var expYearTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    
    weak var delegate: CreditCardDetailsTableViewDelegate?
    
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
        merchantIdTextField.tag = CreditCardSaleManualCells.merchId.rawValue
        creditCardNumberTextField.tag = CreditCardSaleManualCells.accountNumber.rawValue
        expMonthTextField.tag = CreditCardSaleManualCells.expMonth.rawValue
        expYearTextField.tag = CreditCardSaleManualCells.expYear.rawValue
        cvvTextField.tag = CreditCardSaleManualCells.cvv.rawValue
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
