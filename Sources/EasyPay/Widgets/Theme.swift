
import UIKit

public struct Theme {
    private static let bundleId = "org.cocoapods.EasyPay"
    
    static func moduleBundle() -> Bundle? {
#if SWIFT_PACKAGE
        return Bundle.module
#else
        return Bundle(identifier: bundleId)
#endif
    }
    
    public struct Color {
        static let cardLabelColor: UIColor = {
            UIColor(named: "cardLabelColor", in: moduleBundle(), compatibleWith: nil)
        }() ?? UIColor.black
        
        static let errorRed: UIColor = {
            UIColor(named: "errorRed", in: moduleBundle(), compatibleWith: nil)
        }() ?? UIColor.black
        
        static let cardLabelSelected: UIColor = {
            UIColor(named: "cardLabelSelected", in: moduleBundle(), compatibleWith: nil)
        }() ?? UIColor.black
        
        static let technologyBlue2: UIColor = {
            UIColor(named: "technologyBlue2", in: moduleBundle(), compatibleWith: nil)
        }() ?? UIColor.black
        
        static let borderTile: UIColor = {
            UIColor(named: "borderTile", in: moduleBundle(), compatibleWith: nil)
        }() ?? UIColor.black
        
        static let technologyBlueBackground: UIColor = {
            UIColor(named: "technologyBlueBackground", in: moduleBundle(), compatibleWith: nil)
        }() ?? UIColor.black
        
        static let whiteBackground: UIColor = {
            UIColor(named: "whiteBackground", in: moduleBundle(), compatibleWith: nil)
        }() ?? UIColor.black
        
        static let textButton: UIColor = {
            UIColor(named: "textButton", in: moduleBundle(), compatibleWith: nil)
        }() ?? UIColor.black
        
        static let confirmationGreenContainer: UIColor = {
            UIColor(named: "confirmationGreenContainer", in: moduleBundle(), compatibleWith: nil)
        }() ?? UIColor.black
        
        static let errorRedContainer: UIColor = {
            UIColor(named: "errorRedContainer", in: moduleBundle(), compatibleWith: nil)
        }() ?? UIColor.black
        
        static let confirmationGreen: UIColor = {
            UIColor(named: "confirmationGreen", in: moduleBundle(), compatibleWith: nil)
        }() ?? UIColor.black
        
        static let errorSurface: UIColor = {
            UIColor(named: "errorSurface", in: moduleBundle(), compatibleWith: nil)
        }() ?? UIColor.black
        
        static let textSecondary: UIColor = {
            UIColor(named: "textSecondary", in: moduleBundle(), compatibleWith: nil)
        }() ?? UIColor.black
        
        static let textTertiary: UIColor = {
            UIColor(named: "textTertiary", in: moduleBundle(), compatibleWith: nil)
        }() ?? UIColor.black
        
        static let textPrimary: UIColor = {
            UIColor(named: "textPrimary", in: moduleBundle(), compatibleWith: nil)
        }() ?? UIColor.black
        
        static let inputBackground: UIColor = {
            UIColor(named: "inputBackground", in: moduleBundle(), compatibleWith: nil)
        }() ?? UIColor.black
        
        static let buttonDisabled: UIColor = {
            UIColor(named: "buttonDisabled", in: moduleBundle(), compatibleWith: nil)
        }() ?? UIColor.black
        
        static let checkboxBackground: UIColor = {
            UIColor(named: "checkboxBackground", in: moduleBundle(), compatibleWith: nil)
        }() ?? UIColor.black
        
        static let checkboxBorder: UIColor = {
            UIColor(named: "checkboxBorder", in: moduleBundle(), compatibleWith: nil)
        }() ?? UIColor.black
    }

    public struct Image {
        static let plusIcon: UIImage? = UIImage(named: "plusIcon", in: moduleBundle(), with: nil)
        static let creditCardFilled: UIImage? = UIImage(named: "creditCardFilled", in: moduleBundle(), with: nil)
        static let creditCard: UIImage? = UIImage(named: "creditCard", in: moduleBundle(), with: nil)
        static let creditCardError: UIImage? = UIImage(named: "creditCardError", in: moduleBundle(), with: nil)
        static let xCircleFilled: UIImage? = UIImage(named: "xCircleFilled", in: moduleBundle(), with: nil)
        static let checkCircleFilled: UIImage? = UIImage(named: "checkCircleFilled", in: moduleBundle(), with: nil)
        static let check: UIImage? = UIImage(named: "Check", in: moduleBundle(), with: nil)
        static let eyeIconError: UIImage? = UIImage(named: "eyeIconError", in: moduleBundle(), with: nil)
        static let eyeIcon: UIImage? = UIImage(named: "eyeIcon", in: moduleBundle(), with: nil)
        static let eyeIconCrossed: UIImage? = UIImage(named: "eyeIconCrossed", in: moduleBundle(), with: nil)
        static let eyeIconCrossedError: UIImage? = UIImage(named: "eyeIconCrossedError", in: moduleBundle(), with: nil)
    }
    
    public struct Font {
        static let body3Action: UIFont = UIFont(name: "Inter-SemiBold", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        static let body2Regular: UIFont = UIFont(name: "Inter-Regular", size: 16.0) ?? UIFont.systemFont(ofSize: 16.0, weight: .regular)
        static let body3Regular: UIFont = UIFont(name: "Inter-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0, weight: .regular)
        static let supportiveText: UIFont = UIFont(name: "Inter-Regular", size: 11.0) ?? UIFont.systemFont(ofSize: 11.0, weight: .regular)
    }
}
