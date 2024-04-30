
import Foundation

public struct CreditCardSaleResponse: BaseResponse {
    public var body: Data? = nil
    
    public init(data: CardSaleManualResponseModel) {
        self.data = data
    }
    
    public let data: CardSaleManualResponseModel
    
    enum CodingKeys: String, CodingKey {
        case data = "CreditCardSale_ManualResult"
    }
}
