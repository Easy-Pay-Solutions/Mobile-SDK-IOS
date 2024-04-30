
import UIKit

public class StringUtils {
    public class func isNilOrEmpty(_ testString : String?) -> Bool {
        if testString == nil {
            return true
        }
        if testString!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return true
        }
        
        return false
    }
    
    public class func trimmingEmptyOrWhitespace(_ string: String?) -> String? {
        if let string  {
            let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
            
            guard !trimmedString.isEmpty else {
                return nil
            }
            
            return trimmedString
        } else {
            return nil
        }
    }
}
