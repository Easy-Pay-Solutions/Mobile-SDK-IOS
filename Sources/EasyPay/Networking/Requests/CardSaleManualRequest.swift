
import Foundation

public struct CardSaleManualRequest: BaseRequest {
    public init(transactionRequest: TransactionRequest) {
        self.transactionRequest = transactionRequest
    }
    
    public var path: String {
         "v1.0.0/CardSale/Manual"
    }
    
    public var httpMethod: String {
        "POST"
    }
        
    public var body: Data {
        return try! JSONSerialization.data(withJSONObject: transactionRequest.convertToDictionary(), options: [])
    }
    
    public let transactionRequest: TransactionRequest
}
