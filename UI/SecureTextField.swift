
import UIKit
import Sentry

public enum SecureTextFieldError: Error {
    case setupConfigError
}

public class SecureTextField: UITextField {
    private var secureText: String? = ""
    private var configuration: Config?
    private var encryptionUtils: EncryptionUtils?
    
    public func setupConfig(_ config: Config) {
        self.configuration = config
        self.encryptionUtils = EncryptionUtils(apiKey: config.apiKey, hmacSecret: config.hmacSecret)
    }
    
    public func encryptCardData() throws -> String? {
        if let encryptionUtils {
            if let certificate = configuration?.publicKey {
                let encryptedBase64 = encryptionUtils.encryptBase64(text: super.text ?? "", with: certificate)
                if let thumbprint = configuration?.thumbprint, let encryptedBase64, !StringUtils.isNilOrEmpty(encryptedBase64) {
                    return "\(encryptedBase64)|\(thumbprint)"
                } else {
                    return ""
                }
            }
        } else {
            let error = SecureTextFieldError.setupConfigError
            SentrySDK.capture(error: error)
            throw error
        }
        return nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSecureTextEntry()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSecureTextEntry()
    }
    
    private func setupSecureTextEntry() {
        self.isSecureTextEntry = true
    }
    
    public override var isSecureTextEntry: Bool {
        get {
            return true
        }
        set {
            super.isSecureTextEntry = true
        }
    }
    
    public override var autocorrectionType: UITextAutocorrectionType {
        get {
            return .no
        }
        set {
            super.autocorrectionType = .no
        }
    }
    
    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
         return false
     }

    public override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
         return []
     }
    
    public override var text: String? {
        get {
            secureText = super.text
            return ""
        }
        set {
            secureText = super.text
            secureText = newValue
        }
    }
}
