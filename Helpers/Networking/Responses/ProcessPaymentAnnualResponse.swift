
import Foundation

public struct ProcessPaymentAnnualResponse: BaseResponse {
    public var body: Data? = nil
    
    public init(data: ProcessPaymentAnnualResponseModel) {
        self.data = data
    }
    
    public let data: ProcessPaymentAnnualResponseModel
    
    enum CodingKeys: String, CodingKey {
        case data = "ConsentAnnual_ProcPaymentResult"
    }
}
