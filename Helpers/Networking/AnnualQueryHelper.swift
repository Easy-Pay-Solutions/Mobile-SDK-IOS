
import Foundation

public class AnnualQueryHelper {
    private let merchantId: String
    private let customerReferenceId: String?
    private let endDate: Date?

    
    public init(merchantId: String, customerReferenceId: String?, endDate: Date?) {
        self.merchantId = merchantId
        self.customerReferenceId = customerReferenceId
        self.endDate = endDate
    }
    
    public func configureQuery() -> String {
        var queryString = ""
        
        if let customerReferenceId {
            queryString += "(F LIKE '%\(customerReferenceId)%')&&"
        }
        
        if let endDate {
            let date = formatDate(endDate)
            queryString += "(C>='\(date)')&&"
        } else {
            let date = formatDate(Date())
            queryString += "(C>='\(date)')&&"
        }
        
        queryString += "(H=1)&&"
        
        queryString += "(A=\(merchantId))"
        
        return queryString
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date)
    }
}
