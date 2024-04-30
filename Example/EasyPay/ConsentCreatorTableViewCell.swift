
import UIKit

protocol ConsentCreatorTableViewCellDelegate: AnyObject {
    func didChangeText(cell: ConsentCreatorTableViewCell,
                       text: String?,
                       tag: Int)
    func didChangePicker(date: Date)
}

class ConsentCreatorTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ConsentCreatorTableViewCell"

    @IBOutlet weak var merchantIdTextField: UITextField!
    @IBOutlet weak var customerReferenceIdTextField: UITextField!
    @IBOutlet weak var serviceDescriptionTextField: UITextField!
    @IBOutlet weak var rpguidTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var limitPerChargeTextField: UITextField!
    @IBOutlet weak var limitLifetimeTextField: UITextField!
    
    weak var delegate: ConsentCreatorTableViewCellDelegate?
    
    func configureTags() {
        merchantIdTextField.tag = AnnualConsentCreatorCell.merchantId.rawValue
        customerReferenceIdTextField.tag = AnnualConsentCreatorCell.customerReferenceId.rawValue
        serviceDescriptionTextField.tag = AnnualConsentCreatorCell.serviceDescription.rawValue
        rpguidTextField.tag = AnnualConsentCreatorCell.rpguid.rawValue
        startDatePicker.tag = AnnualConsentCreatorCell.startDate.rawValue
        limitPerChargeTextField.tag = AnnualConsentCreatorCell.limitPerCharge.rawValue
        limitLifetimeTextField.tag = AnnualConsentCreatorCell.limitLifetime.rawValue
    }

    @IBAction private func textFieldEditingChanged(_ sender: UITextField) {
        delegate?.didChangeText(cell: self,
                                text: sender.text,
                                tag: sender.tag)
    }
    
    @IBAction func startDatePickerChanged(_ sender: UIDatePicker) {
        delegate?.didChangePicker(date: sender.date)
    }
}
