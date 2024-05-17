
import Foundation

public struct CardSaleManualResponseModel: Codable {
    public init(avsResult: String, 
                acquirerResponseEMV: String? = nil,
                cvvResult: String,
                errorCode: Int,
                errorMessage: String,
                functionOk: Bool,
                isPartialApproval: Bool,
                requiresVoiceAuth: Bool,
                responseMessage: String,
                responseApprovedAmount: Int,
                responseAuthorizedAmount: Int,
                responseBalanceAmount: Int,
                txApproved: Bool,
                txId: Int,
                txnCode: String) {
        self.avsResult = avsResult
        self.acquirerResponseEMV = acquirerResponseEMV
        self.cvvResult = cvvResult
        self.errorCode = errorCode
        self.errorMessage = errorMessage
        self.functionOk = functionOk
        self.isPartialApproval = isPartialApproval
        self.requiresVoiceAuth = requiresVoiceAuth
        self.responseMessage = responseMessage
        self.responseApprovedAmount = responseApprovedAmount
        self.responseAuthorizedAmount = responseAuthorizedAmount
        self.responseBalanceAmount = responseBalanceAmount
        self.txApproved = txApproved
        self.txId = txId
        self.txnCode = txnCode
    }
    
    public let avsResult: String
    public let acquirerResponseEMV: String?
    public let cvvResult: String
    public let errorCode: Int
    public let errorMessage: String
    public let functionOk: Bool
    public let isPartialApproval: Bool
    public let requiresVoiceAuth: Bool
    public let responseMessage: String
    public let responseApprovedAmount: Int
    public let responseAuthorizedAmount: Int
    public let responseBalanceAmount: Int
    public let txApproved: Bool
    public let txId: Int
    public let txnCode: String
    
    enum CodingKeys: String, CodingKey {
        case avsResult = "AVSresult"
        case acquirerResponseEMV = "AcquirerResponseEMV"
        case cvvResult = "CVVresult"
        case errorCode = "ErrCode"
        case errorMessage = "ErrMsg"
        case functionOk = "FunctionOk"
        case isPartialApproval = "IsPartialApproval"
        case requiresVoiceAuth = "RequiresVoiceAuth"
        case responseMessage = "RespMsg"
        case responseApprovedAmount = "ResponseApprovedAmount"
        case responseAuthorizedAmount = "ResponseAuthorizedAmount"
        case responseBalanceAmount = "ResponseBalanceAmount"
        case txApproved = "TxApproved"
        case txId = "TxID"
        case txnCode = "TxnCode"
    }
}
