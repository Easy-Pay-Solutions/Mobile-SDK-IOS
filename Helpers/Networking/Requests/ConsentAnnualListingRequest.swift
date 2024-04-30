
import Foundation

public struct ConsentAnnualListingRequest: BaseRequest {
    public init(consentAnnualListingRequest: ConsentAnnualListingRequestModel) {
        self.consentAnnualListingRequest = consentAnnualListingRequest
    }
    
    public var path: String {
         "v1.0.0/Query/ConsentAnnual"
    }
    
    public var httpMethod: String {
        "POST"
    }
        
    public var body: Data {
        return try! JSONSerialization.data(withJSONObject: consentAnnualListingRequest.convertToDictionary(), options: [])
    }
    
    public let consentAnnualListingRequest: ConsentAnnualListingRequestModel
}
