
import UIKit

protocol CardBillingAddressViewDelegate: AnyObject {
    func didChangeText(cell: CardBillingAddressTableViewCell,
                       text: String?,
                       tag: Int)
}

class CardBillingAddressTableViewCell: UITableViewCell {
    static let reuseIdentifier = "CardBillingAddressTableViewCell"

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var address1TextField: UITextField!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    
    weak var delegate: CardBillingAddressViewDelegate?

    func configureTags(isAccountHolder: Bool) {
        if isAccountHolder {
            address1TextField.tag = AccountHolderBillingCells.accountHolderAddress1.rawValue
            address2TextField.tag = AccountHolderBillingCells.accountHolderAddress2.rawValue
            cityTextField.tag = AccountHolderBillingCells.accountHolderCity.rawValue
            stateTextField.tag = AccountHolderBillingCells.accountHolderState.rawValue
            zipTextField.tag = AccountHolderBillingCells.accountHolderZip.rawValue
            countryTextField.tag = AccountHolderBillingCells.accountHolderCountry.rawValue
        } else {
            titleLabel.text = "End Customer Billing Address"
            address1TextField.tag = EndCustomerBillingCells.endCustomerAddress1.rawValue
            address2TextField.tag = EndCustomerBillingCells.endCustomerAddress2.rawValue
            cityTextField.tag = EndCustomerBillingCells.endCustomerCity.rawValue
            stateTextField.tag = EndCustomerBillingCells.endCustomerState.rawValue
            zipTextField.tag = EndCustomerBillingCells.endCustomerZip.rawValue
            countryTextField.tag = EndCustomerBillingCells.endCustomerCountry.rawValue
        }
    }
    
    func configureAnnualTags(isAccountHolder: Bool) {
        if isAccountHolder {
            address1TextField.tag = AnnualAccountHolderBillingCell.address1.rawValue
            address2TextField.tag = AnnualAccountHolderBillingCell.address2.rawValue
            cityTextField.tag = AnnualAccountHolderBillingCell.city.rawValue
            stateTextField.tag = AnnualAccountHolderBillingCell.state.rawValue
            zipTextField.tag = AnnualAccountHolderBillingCell.zip.rawValue
            countryTextField.tag = AnnualAccountHolderBillingCell.country.rawValue
        } else {
            titleLabel.text = "End Customer Billing Address"
            address1TextField.tag = AnnualEndCustomerBillingCell.address1.rawValue
            address2TextField.tag = AnnualEndCustomerBillingCell.address2.rawValue
            cityTextField.tag = AnnualEndCustomerBillingCell.city.rawValue
            stateTextField.tag = AnnualEndCustomerBillingCell.state.rawValue
            zipTextField.tag = AnnualEndCustomerBillingCell.zip.rawValue
            countryTextField.tag = AnnualEndCustomerBillingCell.country.rawValue
        }
    }
    
    @IBAction private func textFieldEditingChanged(_ sender: UITextField) {
        delegate?.didChangeText(cell: self,
                                text: sender.text,
                                tag: sender.tag)
    }
}
