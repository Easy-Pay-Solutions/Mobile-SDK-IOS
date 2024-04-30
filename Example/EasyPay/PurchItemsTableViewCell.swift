
import UIKit

protocol PurchItemsTableViewCellDelegate: AnyObject {
    func didChangeText(cell: PurchItemsTableViewCell,
                       text: String?,
                       tag: Int)
}

class PurchItemsTableViewCell: UITableViewCell {
    static let reuseIdentifier = "PurchItemsTableViewCell"

    @IBOutlet weak var serviceDescriptionTextField: UITextField!
    @IBOutlet weak var clientRefIdTextField: UITextField!
    @IBOutlet weak var rpguidTextField: UITextField!
    
    weak var delegate: PurchItemsTableViewCellDelegate?

    func configureTags() {
        serviceDescriptionTextField.tag = PurchaseItemsCells.serviceDesription.rawValue
        clientRefIdTextField.tag = PurchaseItemsCells.clientRefId.rawValue
        rpguidTextField.tag = PurchaseItemsCells.rpguid.rawValue
    }
    
    @IBAction private func textFieldEditingChanged(_ sender: UITextField) {
        delegate?.didChangeText(cell: self,
                                text: sender.text,
                                tag: sender.tag)
    }
}
