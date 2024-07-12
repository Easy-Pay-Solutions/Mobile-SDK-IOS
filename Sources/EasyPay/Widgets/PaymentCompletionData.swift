//
//  PaymentCompletionData.swift
//  EasyPay
//
//  Created by Igor SOKÓŁ on 12/07/2024.
//

import Foundation

public struct PaymentData {
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
}

extension ProcessPaymentAnnualResponseModel {
    func toPaymentData() -> PaymentData {
        return PaymentData(functionOk: self.functionOk,
                           txApproved: self.txApproved,
                           responseMessage: self.responseMessage,
                           errorMessage: self.errorMessage,
                           errorCode: self.errorCode,
                           txnCode: self.txnCode,
                           avsResult: self.avsResult,
                           cvvResult: self.cvvResult,
                           acquirerResponseEMV: self.acquirerResponseEMV,
                           txId: self.txId,
                           requiresVoiceAuth: self.requiresVoiceAuth,
                           isPartialApproval: self.isPartialApproval,
                           responseAuthorizedAmount: self.responseAuthorizedAmount,
                           responseBalanceAmount: self.responseBalanceAmount,
                           responseApprovedAmount: self.responseApprovedAmount)
    }
}

extension CardSaleManualResponseModel {
    func toPaymentData() -> PaymentData {
        return PaymentData(functionOk: self.functionOk,
                           txApproved: self.txApproved,
                           responseMessage: self.responseMessage,
                           errorMessage: self.errorMessage,
                           errorCode: self.errorCode,
                           txnCode: self.txnCode,
                           avsResult: self.avsResult,
                           cvvResult: self.cvvResult,
                           acquirerResponseEMV: self.acquirerResponseEMV,
                           txId: self.txId,
                           requiresVoiceAuth: self.requiresVoiceAuth,
                           isPartialApproval: self.isPartialApproval,
                           responseAuthorizedAmount: self.responseAuthorizedAmount,
                           responseBalanceAmount: self.responseBalanceAmount,
                           responseApprovedAmount: self.responseApprovedAmount)
    }
}
