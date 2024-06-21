
import UIKit
import EasyPay

public enum ManageCardState {
    case selection
    case payment
}

public protocol CardSelectiontDelegate: AnyObject {
    func didSelectCard(consentId: String)
    func didDeleteCard(consentId: Int, success: Bool)
    func didSaveCard(consentId: Int?, success: Bool)
}

public protocol CardPaymentDelegate: AnyObject {
    func didPayWithCard(consentId: Int?, success: Bool)
    func didDeleteCard(consentId: Int, success: Bool)
}

protocol InternalClosingDelegate: AnyObject {
    func shouldCloseScreen()
}

public class CardSelectionViewController: BaseViewController {
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBOutlet private weak var collectionViewLoading: UIActivityIndicatorView!
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
    
    public init?(amount: String, paymentDelegate: AnyObject, preselectedCardId: Int?, paymentDetails: AddAnnualConsentWidgetModel) {
        let viewModel = CardSelectionViewModel(state: .payment, amount: amount, preselectedCardId: preselectedCardId, paymentDetails: paymentDetails)
        self.paymentDelegate = paymentDelegate as? any CardPaymentDelegate

        guard viewModel.isValidCurrency(amount) else {
            return nil
        }

        self.viewModel = viewModel
        super.init(nibName: vcName, bundle: Bundle(identifier: Theme.bundleId))
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }

    public init(selectionDelegate: AnyObject, preselectedCardId: Int?, paymentDetails: AddAnnualConsentWidgetModel) {
        self.viewModel = CardSelectionViewModel(state: .selection, amount: "", preselectedCardId: preselectedCardId, paymentDetails: paymentDetails)
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

        showLoading(true)
        viewModel.downloadAnnualConsents() { [weak self] result in
            guard let s = self else { return }
            s.showLoading(false)
            switch result {
            case .success(_):
                s.collectionView.reloadData()
        
                if let presentationController = s.presentationController as? PresentationController, s.viewModel.isPreselected {
                    presentationController.updatePresentedViewHeight(s.calculateIncreasedHeight())
                    s.cardStackView.isHidden = false
                    s.cardActionsStackView.isHidden = false
                    s.collectionView.layoutIfNeeded()
                    
                    UIView.animate(withDuration: 0.3) {
                        s.updateSelectedCard(index: s.viewModel.selectedIndex - 1)
                        s.collectionView.selectItem(at: IndexPath(row: s.viewModel.findCollectionViewIndex(), section: 0), animated: true, scrollPosition: .centeredHorizontally)
                    }
                }
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
            cardNumber.text = "\(Localization.asterixFourMask) \(accountNumber)"
            
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
        closeWidget()
    }
    
    private func closeWidget() {
        self.dismiss(animated: true, completion: nil)
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func deleteCardButtonTapped(_ sender: UIButton) {
        self.showYesNoAlert(title: Localization.deleteThisCard,
                            message: Localization.deleteCardMessgae,
                            yesMessage: Localization.delete,
                            noMessage: Localization.cancel,
                            yesAccessibilityIdentifier: "deleteAction",
                            yesHandler: { [weak self] _ in
            guard let s = self, let selectedCard = s.viewModel.selectedCardConsentId() else { return }
            s.showLoading(true)
            s.viewModel.deleteAnnualConsent(consentId: selectedCard) { [weak self] result in
                s.showLoading(false)
                switch result {
                case .success(_):
                    s.showLoading(true)
                    s.notifyDeleteDelegate(success: true, selectedCard: selectedCard)
                    s.viewModel.downloadAnnualConsents() { [weak self] result in
                        s.showLoading(false)
                        guard let s = self else { return }
                        switch result {
                        case .success(_):
                            s.reloadAfterSuccessDeletingCard()
                        case .failure(let error):
                            s.showAlert(title: Localization.error, message: error.localizedDescription)
                        }
                    }
                case .failure(_):
                    s.showErrorDeletingCard(selectedCard: selectedCard)
                }
            }
        })
    }
    
    private func reloadAfterSuccessDeletingCard() {
        collectionView.reloadData()
        viewModel.selectedIndex = -1
        if let presentationController = presentationController as? PresentationController {
            presentationController.updatePresentedViewHeight(calculateDecreasedHeight())
            cardStackView.isHidden = true
            cardActionsStackView.isHidden = true
            collectionView.layoutIfNeeded()
        }
        showToast(message: Localization.selectedCardDeleted, controller: self, success: true, action: nil, hideAutomaticallyDelay: 3.0, shouldBeMovedHigher: false)
    }
    
    private func showErrorDeletingCard(selectedCard: Int) {
        showLoading(false)
        notifyDeleteDelegate(success: false, selectedCard: selectedCard)
        showToast(message: Localization.errorDeletingCard, controller: self, success: false, action: nil, hideAutomaticallyDelay: 3.0)
    }
    
    private func notifyDeleteDelegate(success: Bool, selectedCard: Int) {
        viewModel.state == .selection
        ? selectionDelegate?.didDeleteCard(consentId: selectedCard, success: success)
        : paymentDelegate?.didDeleteCard(consentId: selectedCard, success: success)
    }
    
    private func showPayButtonError(_ yes: Bool, declineError: Bool = false) {
        payButton.backgroundColor = yes
        ? Theme.Color.errorRedContainer
        : Theme.Color.confirmationGreen
        let titleColor = yes
        ? Theme.Color.errorRed
        : UIColor.white
        errorLabel.text = declineError
        ? Localization.unableToProcessPaymentError
        : Localization.easyPayApiError
        errorLabel.isHidden = !yes
        payButton.isEnabled = !yes
        payButton.setTitleColor(titleColor, for: .normal)
        if let presentationController = self.presentationController as? PresentationController {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            presentationController.updatePresentedViewHeight(calculateIncreasedHeight())
        }
    }

    @IBAction private func payButtonTapped(_ sender: UIButton) {
        chargeConsentAnnual()
    }
    
    private func paymentSuccesRespondeHandler(response: ProcessPaymentAnnualResponse, selectedCard: Int) {
        if response.data.errorMessage != "" && response.data.errorCode != 0 {
            showPayButtonError(true)
            notifyPayDelegate(success: false, selectedCard: selectedCard)
        } else if response.data.functionOk == true && response.data.txApproved == false {
            showPayButtonError(true, declineError: true)
            notifyPayDelegate(success: false, selectedCard: selectedCard)
        } else {
            notifyPayDelegate(success: true, selectedCard: selectedCard)
            closeWidget()
        }
    }
    
    private func chargeConsentAnnual() {
        guard let selectedCard = self.viewModel.selectedCardConsentId() else { return }

        self.viewModel.chargeAnnualConsent(consentId: selectedCard) { [weak self] result in
            guard let s = self else { return }
            s.showLoading(true)
            switch result {
            case .success(let response):
                s.showLoading(false)
                s.paymentSuccesRespondeHandler(response: response, selectedCard: selectedCard)
            case .failure(_):
                s.showLoading(false)
                s.notifyPayDelegate(success: false, selectedCard: selectedCard)
                s.showPayButtonError(true)
            }
        }
    }
    
    private func notifyPayDelegate(success: Bool, selectedCard: Int) {
        paymentDelegate?.didPayWithCard(consentId: selectedCard, success: success)
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
        showPayButtonError(false)
        
        if indexPath.row == 0 {
            viewModel.selectedIndex = -1
            self.presentAddNewCard()

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
    
    private func presentAddNewCard() {
        let state: AddCardState = viewModel.state == .selection
        ? .saveOnly
        : .payAndSave
        let vc = AddCardViewController(state: state, amount: viewModel.amount, delegate: self, paymentDetails: viewModel.paymentDetails)
        vc.closePaymentSheetDelegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    private func showLoading(_ yes: Bool) {
        enableButtons(!yes)
        self.isLoading = yes
        yes
        ? collectionViewLoading.startAnimating()
        : collectionViewLoading.stopAnimating()
    }
    
    private func enableButtons(_ yes: Bool) {
        payButton.isEnabled = yes
        deleteCardButton.isEnabled = yes
    }
}

extension CardSelectionViewController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension CardSelectionViewController: SavingCardDelegate, PayingSavingCardDelegate, InternalClosingDelegate {
    func shouldCloseScreen() {
        closeWidget()
    }
    
    public func didOnlySaveCard(consentId: Int?, success: Bool) {
        selectionDelegate?.didSaveCard(consentId: consentId, success: success)
        if success {
            if success {
                self.showToast(message: Localization.cardWasSaved, 
                               controller: self,
                               success: true,
                               action: nil)
            }
            if let consentId {
                selectionDelegate?.didSelectCard(consentId: String(consentId))
            }
        }
    }
    
    public func didPayWithCard(consentId: Int?, success: Bool) {
        paymentDelegate?.didPayWithCard(consentId: consentId, success: success)
    }
    
    public func didSaveCard(consentId: Int?, success: Bool) {
        selectionDelegate?.didSaveCard(consentId: consentId, success: success)
    }
}

