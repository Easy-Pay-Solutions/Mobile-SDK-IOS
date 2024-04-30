
import UIKit

protocol ContactTableViewDelegate: AnyObject {
    func didChangeText(cell: AccountHolderTableViewCell,
                       text: String?,
                       tag: Int)
}

class AccountHolderTableViewCell: UITableViewCell, UITextFieldDelegate {
    static let reuseIdentifier = "AccountHolderTableViewCell"

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    weak var delegate: ContactTableViewDelegate?

    func configureTags(isAccountHolder: Bool) {
        if isAccountHolder {
            firstNameTextField.tag = AccountHolderCells.accountHolderFirstName.rawValue
            lastNameTextField.tag = AccountHolderCells.accountHolderLastName.rawValue
            companyTextField.tag = AccountHolderCells.accountHolderCompany.rawValue
            phoneTextField.tag = AccountHolderCells.accountHolderPhone.rawValue
            emailTextField.tag = AccountHolderCells.accountHolderEmail.rawValue
        } else {
            titleLabel.text = "End Customer"
            firstNameTextField.tag = EndCustomerCells.endCustomerFirstName.rawValue
            lastNameTextField.tag = EndCustomerCells.endCustomerLastName.rawValue
            companyTextField.tag = EndCustomerCells.endCustomerCompany.rawValue
            phoneTextField.tag = EndCustomerCells.endCustomerPhone.rawValue
            emailTextField.tag = EndCustomerCells.endCustomerEmail.rawValue
        }
    }
    
    func configureAnnualTags(isAccountHolder: Bool) {
        if isAccountHolder {
            firstNameTextField.tag = AnnualAccountHolderCell.firstName.rawValue
            lastNameTextField.tag = AnnualAccountHolderCell.lastName.rawValue
            companyTextField.tag = AnnualAccountHolderCell.company.rawValue
            phoneTextField.tag = AnnualAccountHolderCell.phone.rawValue
            emailTextField.tag = AnnualAccountHolderCell.email.rawValue
        } else {
            titleLabel.text = "End Customer"
            firstNameTextField.tag = AnnualEndCustomerCell.firstName.rawValue
            lastNameTextField.tag = AnnualEndCustomerCell.lastName.rawValue
            companyTextField.tag = AnnualEndCustomerCell.company.rawValue
            phoneTextField.tag = AnnualEndCustomerCell.phone.rawValue
            emailTextField.tag = AnnualEndCustomerCell.email.rawValue
        }
    }
    
    @IBAction private func textFieldEditingChanged(_ sender: UITextField) {
        delegate?.didChangeText(cell: self,
                                text: sender.text,
                                tag: sender.tag)
    }
}
