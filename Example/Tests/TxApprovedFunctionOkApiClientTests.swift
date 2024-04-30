
import XCTest
@testable import EasyPay

class TxApprovedFunctionOkApiClientTests: XCTestCase {
    
    let encoder = JSONEncoder()

    func testIfFunctionOkAndTxApprovedAreTrue() {
        let mockClass = MockTxApprovedFunctions()
        do {
            let data = try encoder.encode(dataFunctionOkTrue)
            let flags = mockClass.parseResponseForFlags(data: data)
            XCTAssert(flags.functionOK == true)
            XCTAssert(flags.txApproved == true)
        } catch {
            fatalError()
        }
    }
    
    func testIfFunctionOkAndTxApprovedAreFalse() {
        let mockClass = MockTxApprovedFunctions()
        do {
            let data = try encoder.encode(dataFunctionOkFalse)
            let flags = mockClass.parseResponseForFlags(data: data)
            XCTAssert(flags.functionOK == false)
            XCTAssert(flags.txApproved == false)
        } catch {
            fatalError()
        }
    }
    
    func testIfFunctionOkTrueAndTxApprovedFalse() {
        let mockClass = MockTxApprovedFunctions()
        do {
            let data = try encoder.encode(dataFunctionOkTrueTxApprovedFalse)
            let flags = mockClass.parseResponseForFlags(data: data)
            XCTAssert(flags.functionOK == true)
            XCTAssert(flags.txApproved == false)
        } catch {
            fatalError()
        }
    }
    
    func testIfFunctionOkFalseAndTxApprovedTrue() {
        let mockClass = MockTxApprovedFunctions()
        do {
            let data = try encoder.encode(dataFunctionOkFalseTxApprovedTrue)
            let flags = mockClass.parseResponseForFlags(data: data)
            XCTAssert(flags.functionOK == false)
            XCTAssert(flags.txApproved == true)
        } catch {
            fatalError()
        }
    }
    
    private struct MockCreditCardSaleResponse: BaseResponse {
        public var body: Data? = nil
        
        public init(data: CardSaleManualResponseModel) {
            self.data = data
        }
        
        let data: CardSaleManualResponseModel
        
        enum CodingKeys: String, CodingKey {
            case data = "CreditCardSale_ManualResult"
        }
    }
    
    private let dataFunctionOkTrue = MockCreditCardSaleResponse(data: CardSaleManualResponseModel(
        avsResult: "Y",
        acquirerResponseEMV: "",
        cvvResult: "",
        errorCode: 0,
        errorMessage: "",
        functionOk: true,
        isPartialApproval: false,
        requiresVoiceAuth: false,
        responseMessage: "OK",
        responseApprovedAmount: 0,
        responseAuthorizedAmount: 0,
        responseBalanceAmount: 0,
        txApproved: true,
        txId: 0,
        txnCode: "OK"))
    
    private let dataFunctionOkFalse = MockCreditCardSaleResponse(data: CardSaleManualResponseModel(
        avsResult: "Y",
        acquirerResponseEMV: "",
        cvvResult: "",
        errorCode: 0,
        errorMessage: "",
        functionOk: false,
        isPartialApproval: false,
        requiresVoiceAuth: false,
        responseMessage: "OK",
        responseApprovedAmount: 0,
        responseAuthorizedAmount: 0,
        responseBalanceAmount: 0,
        txApproved: false,
        txId: 0,
        txnCode: "OK"))
    
    private let dataFunctionOkTrueTxApprovedFalse = MockCreditCardSaleResponse(data: CardSaleManualResponseModel(
        avsResult: "Y",
        acquirerResponseEMV: "",
        cvvResult: "",
        errorCode: 0,
        errorMessage: "",
        functionOk: true,
        isPartialApproval: false,
        requiresVoiceAuth: false,
        responseMessage: "OK",
        responseApprovedAmount: 0,
        responseAuthorizedAmount: 0,
        responseBalanceAmount: 0,
        txApproved: false,
        txId: 0,
        txnCode: "OK"))
    
    private let dataFunctionOkFalseTxApprovedTrue = MockCreditCardSaleResponse(data: CardSaleManualResponseModel(
        avsResult: "Y",
        acquirerResponseEMV: "",
        cvvResult: "",
        errorCode: 0,
        errorMessage: "",
        functionOk: false,
        isPartialApproval: false,
        requiresVoiceAuth: false,
        responseMessage: "OK",
        responseApprovedAmount: 0,
        responseAuthorizedAmount: 0,
        responseBalanceAmount: 0,
        txApproved: true,
        txId: 0,
        txnCode: "OK"))
    
    
    private final class MockTxApprovedFunctions {
        func parseResponseForFlags(data: Data) -> (functionOK: Bool, txApproved: Bool) {
            var functionOK: Bool = false
            var txApproved: Bool = true
            
            functionOK = (findErrorCode(in: data as Any, forKey: "FunctionOk") ?? 0) == 1
            
            if let txCode = findErrorCode(in: data as Any, forKey: "TxApproved") {
                txApproved = txCode == 1
            }
            return (functionOK, txApproved)
        }
        
        private func flattenDictionary(_ dictionary: [String: Any]) -> [String: Any] {
            var flattenedDictionary = [String: Any]()
            
            for (key, value) in dictionary {
                if let nestedDictionary = value as? [String: Any] {
                    for (nestedKey, nestedValue) in nestedDictionary {
                        flattenedDictionary["\(nestedKey)"] = nestedValue
                    }
                } else {
                    flattenedDictionary[key] = value
                }
            }
            return flattenedDictionary
        }
        
        private func findErrorCode(in jsonObject: Any, forKey: String) -> Int? {
            guard let jsonObject = jsonObject as? Data else {
                return nil
            }
            if let jsonStringData = String(data: jsonObject, encoding: .utf8)?.data(using: .utf8) {
                if let dictionary = try? JSONSerialization.jsonObject(with: jsonStringData, options: []) as? [String: Any] {
                    let newDict = flattenDictionary(dictionary)
                    if let errCode = newDict["\(forKey)"] as? Int {
                        return errCode
                    }
                    for (_, value) in newDict {
                        if let foundErrCode = findErrorCode(in: value, forKey: forKey) {
                            return foundErrCode
                        }
                    }
                }
            }
            return nil
        }
    }
}
