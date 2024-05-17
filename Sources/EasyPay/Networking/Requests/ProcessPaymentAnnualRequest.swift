
import Foundation

public struct ProcessPaymentAnnualRequest: BaseRequest {
    public init(processPaymentAnnualRequest: ProcessPaymentAnnualRequestModel) {
        self.processPaymentAnnualRequest = processPaymentAnnualRequest
    }
    
    public var path: String {
         "v1.0.0/ConsentAnnual/ProcPayment"
    }
    
    public var httpMethod: String {
        "POST"
    }
        
    public var body: Data {
        return try! JSONSerialization.data(withJSONObject: processPaymentAnnualRequest.convertToDictionary(), options: [])
    }
    
    public let processPaymentAnnualRequest: ProcessPaymentAnnualRequestModel
}
