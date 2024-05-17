import Foundation

public struct CreateConsentAnnualResponse: BaseResponse {
    public var body: Data? = nil
    
    public init(data: CreateConsentAnnualResponseModel) {
        self.data = data
    }
    
    public let data: CreateConsentAnnualResponseModel
    
    enum CodingKeys: String, CodingKey {
        case data = "ConsentAnnual_Create_MANResult"
    }
}
