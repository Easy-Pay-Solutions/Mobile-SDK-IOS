
import Foundation

public class AnnualQueryHelper {
    let customerReferenceId: String?
    let rpguid: String?
    private let merchantId: String
    private let endDate: Date?

    public init(merchantId: String, 
                customerReferenceId: String? = nil,
                rpguid: String? = nil,
                endDate: Date?) {
        self.merchantId = merchantId
        self.customerReferenceId = customerReferenceId
        self.rpguid = rpguid
        self.endDate = endDate
    }

    public func configureQuery() -> String {
        var queryString = ""

        if let customerReferenceId, !StringUtils.isNilOrEmpty(customerReferenceId) {
            queryString += "(F='\(customerReferenceId)')&&"
        }

        if let rpguid, !StringUtils.isNilOrEmpty(rpguid) {
            queryString += "(J='\(rpguid)')&&"
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
