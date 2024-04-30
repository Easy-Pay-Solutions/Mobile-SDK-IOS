
import UIKit

protocol AmountsTableViewCellViewDelegate: AnyObject {
    func didChangeText(cell: AmountsTableViewCell,
                       text: String?,
                       tag: Int)
}

class AmountsTableViewCell: UITableViewCell {
    static let reuseIdentifier = "AmountsTableViewCell"

    @IBOutlet weak var totalAmount: UITextField!
    @IBOutlet weak var salesAmount: UITextField!
    @IBOutlet weak var surchargeTextField: UITextField!
    @IBOutlet weak var tipTextField: UITextField!
    
    weak var delegate: AmountsTableViewCellViewDelegate?

    func configureTags() {
        totalAmount.tag = AmountsBillingCells.totalAmount.rawValue
        salesAmount.tag = AmountsBillingCells.salesAmount.rawValue
        surchargeTextField.tag = AmountsBillingCells.surchargeAmount.rawValue
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        delegate?.didChangeText(cell: self,
                                text: sender.text,
                                tag: sender.tag)
    }
    
}
