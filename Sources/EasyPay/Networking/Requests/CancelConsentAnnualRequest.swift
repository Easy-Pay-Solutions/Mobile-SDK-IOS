
import Foundation

public struct CancelConsentAnnualRequest: BaseRequest {
    public init(cancelConsentAnnualRequest: CancelConsentAnnualManualRequestModel) {
        self.cancelConsentAnnualRequest = cancelConsentAnnualRequest
    }
    
    public var path: String {
         "v1.0.0/ConsentAnnual/Cancel"
    }
    
    public var httpMethod: String {
        "POST"
    }
        
    public var body: Data {
        return try! JSONSerialization.data(withJSONObject: cancelConsentAnnualRequest.convertToDictionary(), options: [])
    }
    
    public let cancelConsentAnnualRequest: CancelConsentAnnualManualRequestModel
}
