
import Foundation

public struct ConsentAnnualListingRequestModel {
    private let query: String
    
    public init(query: AnnualQueryHelper) {
        self.query = query.configureQuery()
    }

    public func convertToDictionary() -> [String: Any] {
        return [
            "Query": query,
        ]
    }
}

public struct ConsentAnnualListingRequestModel2 {
    private let query: String
    
    public init(query: String, merchantId: Int) {
        self.query = query
    }

    public func convertToDictionary() -> [String: Any] {
        return [
            "Query": query,
        ]
    }
}
