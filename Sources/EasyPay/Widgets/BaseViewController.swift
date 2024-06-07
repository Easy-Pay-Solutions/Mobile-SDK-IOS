
import UIKit

public class BaseViewController: UIViewController {
    public var isLoading: Bool = false
    
    func showAlert (title: String,
                    message: String,
                    actionName: String = "Ok",
                    handler: ((UIAlertAction) -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionName, style: .default, handler: handler)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
