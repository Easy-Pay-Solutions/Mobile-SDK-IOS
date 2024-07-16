
import Foundation

public struct ConsentAnnualListingRequestModel {
    public let queryHelper: AnnualQueryHelper

    private var query: String { queryHelper.configureQuery() }

    public init(query: AnnualQueryHelper) {
        self.queryHelper = query
    }

    public func convertToDictionary() -> [String: Any] {
        return [
            "Query": query,
        ]
    }
}
