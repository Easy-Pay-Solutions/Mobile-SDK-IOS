
import Foundation

public struct CreateConsentAnnualResponseModel: Codable {
    public let functionOk: Bool
    public let responseMessage: String
    public let errorMessage: String
    public let errorCode: Int
    public let creationSuccess: Bool
    public let preConsentAuthSuccess: Bool
    public let preConsentAuthMessage: String
    public let preConsentAuthTxId: Int
    public let consentId: Int
    
    public init(functionOk: Bool,
                responseMessage: String,
                errorMessage: String,
                errorCode: Int,
                creationSuccess: Bool,
                preConsentAuthSuccess: Bool,
                preConsentAuthMessage: String,
                preConsentAuthTxId: Int,
                consentId: Int) {
        self.functionOk = functionOk
        self.responseMessage = responseMessage
        self.errorMessage = errorMessage
        self.errorCode = errorCode
        self.creationSuccess = creationSuccess
        self.preConsentAuthSuccess = preConsentAuthSuccess
        self.preConsentAuthMessage = preConsentAuthMessage
        self.preConsentAuthTxId = preConsentAuthTxId
        self.consentId = consentId
    }
    
    private enum CodingKeys: String, CodingKey {
        case functionOk = "FunctionOk"
        case responseMessage = "RespMsg"
        case errorMessage = "ErrMsg"
        case errorCode = "ErrCode"
        case creationSuccess = "CreationSuccess"
        case preConsentAuthSuccess = "PreConsentAuthSuccess"
        case preConsentAuthMessage = "PreConsentAuthMessage"
        case preConsentAuthTxId = "PreConsentAuthTxID"
        case consentId = "ConsentID"
    }
}
