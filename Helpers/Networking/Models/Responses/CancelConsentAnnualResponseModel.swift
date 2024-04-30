
import Foundation

public struct CancelConsentAnnualResponseModel: Codable {
    public init(functionOk: Bool?,
                responseMessage: String?,
                errorMessage: String?,
                errorCode: Int?,
                cancelledConsentId: Int?,
                cancelSuccess: Bool?) {
        self.functionOk = functionOk
        self.responseMessage = responseMessage
        self.errorMessage = errorMessage
        self.errorCode = errorCode
        self.cancelledConsentId = cancelledConsentId
        self.cancelSuccess = cancelSuccess
    }
    
   public let functionOk: Bool?
   public let responseMessage: String?
   public let errorMessage: String?
   public let errorCode: Int?
   public let cancelledConsentId: Int?
   public let cancelSuccess: Bool?

    enum CodingKeys: String, CodingKey {
        case functionOk = "FunctionOk"
        case responseMessage = "RespMsg"
        case errorMessage = "ErrMsg"
        case errorCode = "ErrCode"
        case cancelledConsentId = "CancelledConsentID"
        case cancelSuccess = "CancelSuccess"
    }
}
