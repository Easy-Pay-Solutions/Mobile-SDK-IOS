
import Foundation

public struct ProcessPaymentAnnualResponseModel: Codable {
    public init(functionOk: Bool,
                txApproved: Bool,
                responseMessage: String,
                errorMessage: String,
                errorCode: Int,
                txnCode: String,
                avsResult: String,
                cvvResult: String,
                acquirerResponseEMV: String,
                txId: Int,
                requiresVoiceAuth: Bool,
                isPartialApproval: Bool,
                responseAuthorizedAmount: Double,
                responseBalanceAmount: Double,
                responseApprovedAmount: Double) {
        self.functionOk = functionOk
        self.txApproved = txApproved
        self.responseMessage = responseMessage
        self.errorMessage = errorMessage
        self.errorCode = errorCode
        self.txnCode = txnCode
        self.avsResult = avsResult
        self.cvvResult = cvvResult
        self.acquirerResponseEMV = acquirerResponseEMV
        self.txId = txId
        self.requiresVoiceAuth = requiresVoiceAuth
        self.isPartialApproval = isPartialApproval
        self.responseAuthorizedAmount = responseAuthorizedAmount
        self.responseBalanceAmount = responseBalanceAmount
        self.responseApprovedAmount = responseApprovedAmount
    }
    
    public let functionOk: Bool?
    public let txApproved: Bool?
    public let responseMessage: String?
    public let errorMessage: String?
    public let errorCode: Int?
    public let txnCode: String?
    public let avsResult: String?
    public let cvvResult: String?
    public let acquirerResponseEMV: String?
    public let txId: Int?
    public let requiresVoiceAuth: Bool?
    public let isPartialApproval: Bool?
    public let responseAuthorizedAmount: Double?
    public let responseBalanceAmount: Double?
    public let responseApprovedAmount: Double?
    
    enum CodingKeys: String, CodingKey {
        case functionOk = "FunctionOk"
        case txApproved = "TxApproved"
        case responseMessage = "RespMsg"
        case errorMessage = "ErrMsg"
        case errorCode = "ErrCode"
        case txnCode = "TxnCode"
        case avsResult = "AVSresult"
        case cvvResult = "CVVresult"
        case acquirerResponseEMV = "AcquirerResponseEMV"
        case txId = "TxID"
        case requiresVoiceAuth = "RequiresVoiceAuth"
        case isPartialApproval = "IsPartialApproval"
        case responseAuthorizedAmount = "ResponseAuthorizedAmount"
        case responseBalanceAmount = "ResponseBalanceAmount"
        case responseApprovedAmount = "ResponseApprovedAmount"
    }
}
