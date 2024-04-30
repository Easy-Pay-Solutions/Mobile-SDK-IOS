
import UIKit
import EasyPay

protocol ConsentCellDelegate: AnyObject {
    func deleteConsent(at index: Int)
    func chargeConsent(at index: Int)
}

class CardDetailsTableViewCell: UITableViewCell {
    static let reuseIdentifier = "CardDetailsTableViewCell"
    weak var delegate: ConsentCellDelegate?
    
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var chargeButton: UIButton!
    @IBOutlet private weak var accountHolderId: UILabel!
    @IBOutlet private weak var cardholderName: UILabel!
    @IBOutlet private weak var cardNumber: UILabel!
    
   
    func applyData(consentAnnual: ConsentAnnualListingResponseModel.ConsentAnnual, tag: Int) {
        accountHolderId.text = consentAnnual.accountHolderId != nil ? String(consentAnnual.accountHolderId!) : nil
        if let firstName = consentAnnual.accountHolderFirstName, let lastName = consentAnnual.accountHolderLastName {
            cardholderName.text = firstName + " " + lastName
        } else {
            cardholderName.text = nil
        }
        
        if let accountNumber = consentAnnual.accountNumber {
            cardNumber.text = "**** **** **** " + accountNumber
        } else {
            cardNumber.text = nil
        }
        chargeButton.tag = tag
        deleteButton.tag = tag
    }
    
    @IBAction private func deleteButtonTapped(_ sender: UIButton) {
        print(sender.tag, "delete")
        delegate?.deleteConsent(at: sender.tag)
    }
    
    @IBAction private func chargeButtonTapped(_ sender: UIButton) {
        print(sender.tag, "charge")
        delegate?.chargeConsent(at: sender.tag)
    }
    
}
