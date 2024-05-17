
import Foundation

public struct ListingConsentAnnualResponse: BaseResponse {
    public var body: Data? = nil
    
    public init(data: ConsentAnnualListingResponseModel) {
        self.data = data
    }
    
    public let data: ConsentAnnualListingResponseModel
    
    enum CodingKeys: String, CodingKey {
        case data = "ConsentAnnual_QueryResult"
    }
}
