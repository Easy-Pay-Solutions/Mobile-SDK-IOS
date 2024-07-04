
import UIKit

public class ManageCardCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "ManageCardCollectionViewCell"
    
    @IBOutlet private weak var cardLabel: UILabel!
    @IBOutlet private weak var cardImage: UIImageView!
    @IBOutlet private weak var selectedImage: UIImageView!
    @IBOutlet private weak var cardBackground: UIView!
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        applySelection(false)
    }
    
    func applyData(isNewCard: Bool = false,
                   lastDigits: String,
                   isSelected: Bool) {
        cardLabel.textColor = UIColor.label
        cardLabel.text = isNewCard 
        ? Localization.newCard
        : "\(Localization.asterixFourMask) \(lastDigits)"
        cardImage.image = isNewCard
        ? Theme.Image.plusIcon
        : Theme.Image.creditCardFilled
        applySelection(isSelected)
    }
    
    func applySelection(_ isSelected: Bool) {
        cardBackground.backgroundColor = isSelected 
        ? Theme.Color.technologyBlueBackground
        : Theme.Color.whiteBackground
        cardBackground.layer.borderColor = isSelected
        ? Theme.Color.technologyBlue2.cgColor
        : Theme.Color.borderTile.cgColor
        selectedImage.isHidden = !isSelected
        cardLabel.textColor = isSelected
        ? Theme.Color.cardLabelSelected
        : Theme.Color.cardLabelColor
    }
}
