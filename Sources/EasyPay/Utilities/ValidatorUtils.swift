
import UIKit

public class ValidatorUtils {
    private enum RegexPattern: String {
        case firstAndLastName = "^[a-zA-Z0-9'\\s\\-.,&?/]*$"
        case company = "^[a-zA-Z0-9\\-.,#_&/\\s]+$"
        case address = "^[a-zA-Z0-9\\-.,#_'/\\s]+$"
        case city = "^[a-zA-Z .]+$"
        case zipCode = "^[a-zA-Z0-9- ]*$"
        case stateOrCountry = #"^[a-zA-Z\s]+$"#
        case serviceDescription = "^[a-zA-Z0-9 ._\\-#]+$"
        case clientRefIdOrRpguid = "^[a-zA-Z0-9 _,.\\-#&=]+$"
        case email = ".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*"
        case onlyNumbers = "^[0-9]*$"
    }
    
    private class func checkRegex(_ text: String, regex: String) -> Bool {
        return NSPredicate.init(format: "SELF MATCHES %@", regex).evaluate(with: text.trimmingCharacters(in: CharacterSet.whitespaces))
    }
    
    public class func isValidFirstAndLastName(_ text: String) -> Bool {
        return checkRegex(text, regex: RegexPattern.firstAndLastName.rawValue)
    }
    
    public class func isValidCompany(_ text: String) -> Bool {
        return checkRegex(text, regex: RegexPattern.company.rawValue)
    }
    
    public class func isValidAddress(_ text: String) -> Bool {
        return checkRegex(text, regex: RegexPattern.address.rawValue)
    }
    
    public class func isValidCity(_ text: String) -> Bool {
        return checkRegex(text, regex: RegexPattern.city.rawValue)
    }
    
    public class func isValidZipCode(_ text: String) -> Bool {
        return checkRegex(text, regex: RegexPattern.zipCode.rawValue)
    }
    
    public class func isValidStateOrCountry(_ text: String) -> Bool {
        return checkRegex(text, regex: RegexPattern.stateOrCountry.rawValue)
    }
    
    public class func isValidUrl(_ text: String) -> Bool {
        if let url = URL(string: text) {
             return UIApplication.shared.canOpenURL(url)
         }
         return false
    }
    
    public class func isValidServiceDescription(_ text: String) -> Bool {
        return checkRegex(text, regex: RegexPattern.serviceDescription.rawValue)
    }
    
    public class func isValidClientRefIdOrRpguid(_ text: String) -> Bool {
        return checkRegex(text, regex: RegexPattern.clientRefIdOrRpguid.rawValue)
    }
    
    public class func isValidEmail(_ email: String?) -> Bool {
        if StringUtils.isNilOrEmpty(email) {
            return false
        }
        return checkRegex(email!, regex: RegexPattern.email.rawValue)
    }
    
    public class func checkMaxLimit(_ text: String, maxLimit: Int) -> Bool {
        return text.count <= maxLimit
    }
    
    public class func containsOnlyNumbers(_ text: String) -> Bool {
        return checkRegex(text, regex: RegexPattern.onlyNumbers.rawValue)
    }
    
    public class func stripCurrencyFormatting(from string: String?) -> String? {
        if let string {
            var result = string
            result = result.replacingOccurrences(of: "$", with: "")
            result = result.replacingOccurrences(of: ",", with: "")
            return result
        } else {
            return nil
        }
    }
}
