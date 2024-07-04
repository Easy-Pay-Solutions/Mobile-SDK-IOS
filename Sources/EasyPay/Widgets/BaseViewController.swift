
import UIKit

public class BaseViewController: UIViewController {
    public var isLoading: Bool = false
    
    func showAlert(title: String,
                   message: String,
                   actionName: String = "Ok",
                   handler: ((UIAlertAction) -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionName, style: .default, handler: handler)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showYesNoAlert(title: String,
                        message: String,
                        yesMessage: String,
                        noMessage: String,
                        yesAccessibilityIdentifier: String? = nil,
                        noHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                        yesHandler: ((UIAlertAction) -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: yesMessage,
                                      style: .default,
                                      handler: yesHandler)
        if let yesAccessibilityIdentifier {
            yesAction.accessibilityIdentifier = yesAccessibilityIdentifier
        }
        alert.addAction(yesAction)

        alert.addAction(UIAlertAction(title: noMessage,
                                      style: .cancel,
                                      handler: noHandler))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showToast(message: String?, controller: UIViewController, success: Bool, action: Selector?, hideAutomaticallyDelay: CFTimeInterval? = nil, shouldBeMovedHigher: Bool = false) {
        let toastContainer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 48))
        toastContainer.tag = 213721372137
        toastContainer.backgroundColor = success
            ? Theme.Color.confirmationGreenContainer
            : Theme.Color.errorRedContainer
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 8
        toastContainer.clipsToBounds  =  true

        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.black
        toastLabel.textAlignment = .left
        toastLabel.font = Theme.Font.body3Regular
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0
        toastLabel.accessibilityIdentifier = success ? "successToastMessage" : "failureToastMessage"

        toastContainer.addSubview(toastLabel)
        controller.view.addSubview(toastContainer)

        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false

        let toastButton = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        toastButton.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.addSubview(toastButton)
        toastButton.image = success ? Theme.Image.checkCircleFilled : Theme.Image.xCircleFilled
        toastButton.contentMode = .scaleAspectFit

        let a1 = NSLayoutConstraint(item: toastButton, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 8)
        let a2 = NSLayoutConstraint(item: toastButton, attribute: .trailing, relatedBy: .equal, toItem: toastLabel, attribute: .leading, multiplier: 1, constant: -8)
        let a3 = NSLayoutConstraint(item: toastButton, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -8)
        let a4 = NSLayoutConstraint(item: toastButton, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 8)
        toastContainer.addConstraints([a1, a2, a3, a4])

        let b1 = toastLabel.centerYAnchor.constraint(equalTo: toastButton.centerYAnchor, constant: 0)
        let b2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -10)
        toastContainer.addConstraints([b1, b2])

        let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: controller.view, attribute: .leading, multiplier: 1, constant: 20)
        let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: controller.view, attribute: .trailing, multiplier: 1, constant: -20)
        let c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: controller.view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: shouldBeMovedHigher ? -85 : -20)
        controller.view.addConstraints([c1, c2, c3])

        UIView.animate(withDuration: 0.7, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 0.85
        }, completion: { _ in
            toastContainer.alpha = 1.0
            if let hideAutomaticallyDelay = hideAutomaticallyDelay {
                DispatchQueue.main.asyncAfter(deadline: .now() + hideAutomaticallyDelay) {
                    UIView.animate(withDuration: 0.7, delay: 0.0, options: .curveEaseOut, animations: {
                        toastContainer.alpha = 0.0
                    })
                }
            }
        })
    }
}
