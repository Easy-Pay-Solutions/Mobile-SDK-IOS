
import Foundation

public struct Theme {
    static let bundleId = "org.cocoapods.EasyPay"
    
    public struct Color {
        static let cardLabelColor: UIColor = {
            UIColor.color(named:  "cardLabelColor", inBundleWithIdentifier: bundleId)
        }()
        static let errorRed: UIColor = {
            UIColor.color(named:  "errorRed", inBundleWithIdentifier: bundleId)
        }()
        static let cardLabelSelected: UIColor = {
            UIColor.color(named:  "cardLabelSelected", inBundleWithIdentifier: bundleId)
        }()
        static let technologyBlue2: UIColor = {
            UIColor.color(named:  "technologyBlue2", inBundleWithIdentifier: bundleId)
        }()
        static let borderTile: UIColor = {
            UIColor.color(named:  "borderTile", inBundleWithIdentifier: bundleId)
        }()
        static let technologyBlueBackground: UIColor = {
            UIColor.color(named:  "technologyBlueBackground", inBundleWithIdentifier: bundleId)
        }()
        static let whiteBackground: UIColor = {
            UIColor.color(named:  "whiteBackground", inBundleWithIdentifier: bundleId)
        }()
        static let textButton: UIColor = {
            UIColor.color(named:  "textButton", inBundleWithIdentifier: bundleId)
        }()
        static let confirmationGreenContainer: UIColor = {
            UIColor.color(named:  "confirmationGreenContainer", inBundleWithIdentifier: bundleId)
        }()
        static let errorRedContainer: UIColor = {
            UIColor.color(named:  "errorRedContainer", inBundleWithIdentifier: bundleId)
        }()
    }

    public struct Image {
        static let plusIcon: UIImage? = UIImage.image(named: "plusIcon", inBundleWithIdentifier: bundleId)
        static let creditCardFilled: UIImage? = UIImage.image(named: "creditCardFilled", inBundleWithIdentifier: bundleId)
        static let xCircleFilled: UIImage? = UIImage.image(named: "xCircleFilled", inBundleWithIdentifier: bundleId)
        static let checkCircleFilled: UIImage? = UIImage.image(named: "checkCircleFilled", inBundleWithIdentifier: bundleId)
    }
    
    public struct Font {
        static let body3Action: UIFont = UIFont(name: "Inter-SemiBold", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        static let body3Regular: UIFont = UIFont(name: "Inter-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0, weight: .regular)
    }
}

extension UIColor {
    static func color(named name: String, inBundleWithIdentifier identifier: String) -> UIColor {
        if let bundleURL = Bundle(identifier: identifier),
           let color = UIColor(named: name, in: bundleURL, compatibleWith: nil) {
            return color
        } else {
            print("Color \(name) not found in bundle with identifier \(identifier)")
            return .clear // Default fallback color
        }
    }
}

extension UIImage {
    static func image(named name: String, inBundleWithIdentifier identifier: String) -> UIImage? {
        if let bundle = Bundle(identifier: identifier),
           let image = UIImage(named: name, in: bundle, compatibleWith: nil) {
            return image
        } else {
            print("Image \(name) not found in bundle with identifier \(identifier)")
            return nil // Default fallback image
        }
    }
}
