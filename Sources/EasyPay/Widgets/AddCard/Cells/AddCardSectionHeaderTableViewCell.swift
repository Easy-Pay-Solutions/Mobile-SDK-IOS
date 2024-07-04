
import UIKit

class AddCardSectionHeaderTableViewCell: UITableViewCell {
    
    static let reuseId = "AddCardSectionHeaderTableViewCell"

    @IBOutlet private weak var headerTitle: UILabel!
    
    func applyData(title: String) {
        headerTitle.text = title
    }
}
