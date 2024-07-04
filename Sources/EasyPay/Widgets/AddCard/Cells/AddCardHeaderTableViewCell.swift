
import UIKit

@objc protocol CloseButtonDelegate: AnyObject {
    func didTapClose(_ sender: UIButton)
}

class AddCardHeaderTableViewCell: UITableViewCell {
    
    weak var delegate: CloseButtonDelegate?
    static let reuseId = "AddCardHeaderTableViewCell"

    @IBAction private func closeButtonClicked(_ sender: UIButton) {
        delegate?.didTapClose(sender)
    }
}
