
import Foundation

public struct CreateConsentAnnualRequest: BaseRequest {
    public init(createConsentAnnualRequest: CreateConsentAnnualManualRequestModel) {
        self.createConsentAnnualRequest = createConsentAnnualRequest
    }
    
    public var path: String {
         "v1.0.0/ConsentAnnual/Create_MAN"
    }
    
    public var httpMethod: String {
        "POST"
    }
        
    public var body: Data {
        return try! JSONSerialization.data(withJSONObject: createConsentAnnualRequest.convertToDictionary(), options: [])
    }
    
    public let createConsentAnnualRequest: CreateConsentAnnualManualRequestModel
}
