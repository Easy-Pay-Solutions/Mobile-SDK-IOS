
import Foundation

public class UIValidation {
    class func isValidFirstName(_ testString: String) -> Bool {
        let regex = #"^[a-zA-Z0-9-'.,&?/\s]*$"#
        return NSPredicate.init(format: "SELF MATCHES %@", regex).evaluate(with: testString.trimmingCharacters(in: CharacterSet.whitespaces))
    }
    
    class func isValidAdress(_ testString: String) -> Bool {
        let regex = #"^[a-zA-Z0-9-'.,\s#_/]*$"#
        return NSPredicate.init(format: "SELF MATCHES %@", regex).evaluate(with: testString.trimmingCharacters(in: CharacterSet.whitespaces))
    }
    
    class func containsOnlyNumbers(_ text: String) -> Bool {
        let regex = "^[0-9]*$"
        return NSPredicate.init(format: "SELF MATCHES %@", regex).evaluate(with: text.trimmingCharacters(in: CharacterSet.whitespaces))
    }
    
    class func textLimit(existingText: String?,
                         newText: String,
                         limit: Int) -> Bool {
        let text = existingText ?? ""
        return text.count + newText.count <= limit
    }
}
