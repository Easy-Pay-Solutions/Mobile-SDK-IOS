//
//  ErrorMapper.swift
//  EasyPay
//
//  Created by Igor SOKÓŁ on 02/07/2024.
//

import Foundation

struct ErrorMapper {

    enum ErrorCodeMessage: Int {
        case cannotValidateCardInfo = 55716
    }

    static func mapError(code: Int?) -> String? {
        switch code {
        case ErrorCodeMessage.cannotValidateCardInfo.rawValue:
            return Localization.cannotValidateCardInfo
        default:
            return nil
        }
    }
}
