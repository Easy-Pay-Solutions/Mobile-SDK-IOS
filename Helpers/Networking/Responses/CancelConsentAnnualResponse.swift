
import Foundation

public struct CancelConsentAnnualResponse: BaseResponse {
    public var body: Data? = nil
    
    public init(data: CancelConsentAnnualResponseModel) {
        self.data = data
    }
    
    public let data: CancelConsentAnnualResponseModel
    
    enum CodingKeys: String, CodingKey {
        case data = "ConsentAnnual_CancelResult"
    }
}
