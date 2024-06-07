
import UIKit

public enum ManageCardState {
    case selection
    case payment
}

public protocol CardSelectiontDelegate: AnyObject {
    func didSelectCard(consentId: String)
}

public protocol CardPaymentDelegate: AnyObject {
    func didPayWithCard(consentId: String)
}

public class CardSelectionViewController: BaseViewController {
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBOutlet private weak var sliderLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var cardStackView: UIStackView!
    @IBOutlet private weak var cardActionsStackView: UIStackView!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var deleteCardButton: UIButton!
    @IBOutlet private weak var accountHolderName: UILabel!
    @IBOutlet private weak var cardNumber: UILabel!
    @IBOutlet private weak var payButton: UIButton!
    private var viewModel: CardSelectionViewModel
    
    public weak var selectionDelegate: CardSelectiontDelegate?
    public weak var paymentDelegate: CardPaymentDelegate?
    
    private let vcName = "CardSelectionViewController"

    public init(merchantId: String, amount: String, paymentDelegate: AnyObject) {
        self.viewModel = CardSelectionViewModel(state: .payment, merchantId: merchantId, amount: amount)
        self.paymentDelegate = paymentDelegate as? any CardPaymentDelegate
        super.init(nibName: vcName, bundle: Bundle(identifier: Theme.bundleId))
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    public init(merchantId: String, selectionDelegate: AnyObject) {
        self.viewModel = CardSelectionViewModel(state: .selection, merchantId: merchantId, amount: "")
        self.selectionDelegate = selectionDelegate as? any CardSelectiontDelegate
        super.init(nibName: vcName, bundle: Bundle(identifier: Theme.bundleId))
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        applyDesign()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let presentationController = self.presentationController as? PresentationController {
            presentationController.updatePresentedViewHeight(calculateDecreasedHeight())
            cardStackView.isHidden = true
            cardActionsStackView.isHidden = true
        }
        
        self.isLoading = true
        viewModel.downloadAnnualConsents() { [weak self] result in
            guard let s = self else { return }
            s.isLoading = false
            switch result {
            case .success(_):
                s.collectionView.reloadData()
            case .failure(let error):
                s.showAlert(title: Localization.error, message: error.localizedDescription)
            }
        }
    }

    //MARK: Configuring design
 
    private func calculateIncreasedHeight() -> CGFloat {
        let sum = 26.0 + sliderLabel.frame.size.height + 24.0 + collectionView.frame.size.height + 24.0 + cardStackView.frame.size.height +  24.0 + cardActionsStackView.frame.size.height + 32.0
        return sum / UIScreen.main.bounds.height
    }
    
    private func calculateDecreasedHeight() -> CGFloat {
        let sum = 26.0 + sliderLabel.frame.size.height + 24.0 + collectionView.frame.size.height + 32.0
        return sum / UIScreen.main.bounds.height
    }
    
    private func applyDesign() {
        sliderLabel.text = viewModel.state == .payment
        ? Localization.selectPaymentMethod
        : Localization.yourCards
        
        payButton.isHidden = viewModel.state != .payment
        payButton.setTitle("\(Localization.pay$)\(viewModel.amount)", for: .normal)
        
        let attributedButtonText = NSAttributedString(string: Localization.deleteThisCard,
                                                      attributes:
                                                        [.font: Theme.Font.body3Action as Any,
                                                         .underlineStyle: NSUnderlineStyle.single.rawValue,
                                                         .underlineColor: Theme.Color.textButton
                                                        ])
        deleteCardButton.setAttributedTitle(attributedButtonText, for: .normal)
    }
    
    func updateSelectedCard(index: Int) {
        if let consents = viewModel.annualConsents?.consents, consents.indices.contains(index) {
            let consent = consents[index]
            let accountNumber = consent.accountNumber ?? Localization.asterixFourMask
            cardNumber.text = "\(Localization.asterixThreeFourMask) \(accountNumber)"
            
            if let firstName = consent.accountHolderFirstName, !firstName.isEmpty,
               let lastName = consent.accountHolderLastName, !lastName.isEmpty {
                accountHolderName.text = firstName + " " + lastName
            } else if let firstName = consent.accountHolderFirstName, !firstName.isEmpty {
                accountHolderName.text = firstName
            } else if let lastName = consent.accountHolderLastName, !lastName.isEmpty {
                accountHolderName.text = lastName
            } else {
                accountHolderName.text = nil
            }
        }
    }
    
    @IBAction private func closeButtonTapped(_ sender: UIButton) {
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
}

extension CardSelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func configureCollectionView() {
        let bundleId = Bundle(identifier: Theme.bundleId)
        let nib = UINib(nibName: ManageCardCollectionViewCell.reuseId, bundle: bundleId)
        collectionView.register(nib, forCellWithReuseIdentifier: ManageCardCollectionViewCell.reuseId)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let consentsCount = viewModel.annualConsents?.consents?.count {
            return consentsCount + 1
        } else {
            return 1
        }
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: ManageCardCollectionViewCell.reuseId, for: indexPath) as? ManageCardCollectionViewCell else { return UICollectionViewCell(frame: .zero)}
        
        if indexPath.row == 0 {
            cell.applyData(isNewCard: true, lastDigits: "", isSelected: false)
        } else {
            let isSelected = viewModel.selectedIndex == indexPath.row
            let consents = viewModel.annualConsents?.consents
            let accountNumber = safeIndexAccess(array: consents, index: indexPath.row - 1)?.accountNumber ?? ""
            cell.applyData(lastDigits: accountNumber, isSelected: isSelected)
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            viewModel.selectedIndex = -1
            self.showAlert(title: "Add a card", message: "Feature is coming soon")

            if let presentationController = self.presentationController as? PresentationController {
                presentationController.updatePresentedViewHeight(calculateDecreasedHeight())
                cardStackView.isHidden = true
                cardActionsStackView.isHidden = true
            }
        } else {
            let consents = viewModel.annualConsents?.consents
            let consent = safeIndexAccess(array: consents, index: indexPath.row - 1)?.id

            if let consent = consent {
                let id = String(consent)
                selectionDelegate?.didSelectCard(consentId: id)
            }
            
            if let cell = collectionView.cellForItem(at: indexPath) as? ManageCardCollectionViewCell {
                viewModel.selectedIndex = indexPath.row
                cell.applySelection(true)
                updateSelectedCard(index: viewModel.selectedIndex - 1)
            }
            
            if let presentationController = self.presentationController as? PresentationController {
                presentationController.updatePresentedViewHeight(calculateIncreasedHeight())
                cardStackView.isHidden = false
                cardActionsStackView.isHidden = false
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ManageCardCollectionViewCell, indexPath.row != 0 {
            viewModel.selectedIndex = indexPath.row
            cell.applySelection(false)
        }
    }
}

extension CardSelectionViewController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
