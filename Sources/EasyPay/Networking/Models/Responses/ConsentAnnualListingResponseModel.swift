
import Foundation

public struct ConsentAnnualListingResponseModel: Codable {
    public let functionOk: Bool?
    public var responseMessage: String?
    public let errorMessage: String?
    public let errorCode: Int?
    public let numberOfRecords: Int?
    public let consents: [ConsentAnnual]?

    public struct ConsentAnnual: Codable {
        public let id: Int?
        public let accountHolderId: Int?
        public let customerId: Int?
        public let merchantId: Int?
        public let customerRefId: String?
        public let rpguid: String?
        public let serviceDescription: String?
        public let accountHolderLastName: String?
        public let accountHolderFirstName: String?
        public let isEnabled: Bool?
        public let startDate: String?
        public let endDate: String?
        public let numberOfDays: Int?
        public let limitPerCharge: Double?
        public let limitLifeTime: Double?
        public let authTxID: Int?
        public let createdOn: String?
        public let createdBy: String?
        public let accountNumber: String?

        private enum CodingKeys: String, CodingKey {
            case id = "ID"
            case accountHolderId = "AcctHolderID"
            case customerId = "CustID"
            case merchantId = "MerchID"
            case customerRefId = "CustomerRefID"
            case rpguid = "RPGUID"
            case serviceDescription = "ServiceDescrip"
            case accountHolderLastName = "AcctHolderLastName"
            case accountHolderFirstName = "AcctHolderFirstName"
            case isEnabled = "IsEnabled"
            case startDate = "StartDate"
            case endDate = "EndDate"
            case numberOfDays = "NumDays"
            case limitPerCharge = "LimitPerCharge"
            case limitLifeTime = "LimitLifeTime"
            case authTxID = "AuthTxID"
            case createdOn = "CreatedOn"
            case createdBy = "CreatedBy"
            case accountNumber = "AcctNo"
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decodeIfPresent(Int.self, forKey: .id)
            self.accountHolderId = try container.decodeIfPresent(Int.self, forKey: .accountHolderId)
            self.customerId = try container.decodeIfPresent(Int.self, forKey: .customerId)
            self.merchantId = try container.decodeIfPresent(Int.self, forKey: .merchantId)
            self.customerRefId = try container.decodeIfPresent(String.self, forKey: .customerRefId)
            self.rpguid = try container.decodeIfPresent(String.self, forKey: .rpguid)
            self.serviceDescription = try container.decodeIfPresent(String.self, forKey: .serviceDescription)
            self.accountHolderLastName = try container.decodeIfPresent(String.self, forKey: .accountHolderLastName)
            self.accountHolderFirstName = try container.decodeIfPresent(String.self, forKey: .accountHolderFirstName)
            self.isEnabled = try container.decodeIfPresent(Bool.self, forKey: .isEnabled)
            self.numberOfDays = try container.decodeIfPresent(Int.self, forKey: .numberOfDays)
            self.limitPerCharge = try container.decodeIfPresent(Double.self, forKey: .limitPerCharge)
            self.limitLifeTime = try container.decodeIfPresent(Double.self, forKey: .limitLifeTime)
            self.authTxID = try container.decodeIfPresent(Int.self, forKey: .authTxID)
            self.createdBy = try container.decodeIfPresent(String.self, forKey: .createdBy)
            self.accountNumber = try container.decodeIfPresent(String.self, forKey: .accountNumber)
            
            if let createdOn = try container.decodeIfPresent(String.self, forKey: .createdOn) {
                let createdOnEpoch = extractEpoch(from: createdOn)
                self.createdOn = convertToUTC(timestampWithOffset: createdOnEpoch)
            } else {
                self.createdOn = try container.decodeIfPresent(String.self, forKey: .createdOn)
            }
            
            if let startDate = try container.decodeIfPresent(String.self, forKey: .startDate) {
                let createdOnEpoch = extractEpoch(from: startDate)
                self.startDate = convertToUTC(timestampWithOffset: createdOnEpoch)
            } else {
                self.startDate = try container.decodeIfPresent(String.self, forKey: .startDate)
            }
            
            if let endDate = try container.decodeIfPresent(String.self, forKey: .endDate) {
                let createdOnEpoch = extractEpoch(from: endDate)
                self.endDate = convertToUTC(timestampWithOffset: createdOnEpoch)
            } else {
                self.endDate = try container.decodeIfPresent(String.self, forKey: .endDate)
            }
        }
    }

    private enum CodingKeys: String, CodingKey {
        case functionOk = "FunctionOk"
        case responseMessage = "RespMsg"
        case errorMessage = "ErrMsg"
        case errorCode = "ErrCode"
        case numberOfRecords = "NumRecords"
        case consents = "Consents"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.functionOk = try container.decodeIfPresent(Bool.self, forKey: .functionOk)
        self.responseMessage = try container.decodeIfPresent(String.self, forKey: .responseMessage)
        self.errorMessage = try container.decodeIfPresent(String.self, forKey: .errorMessage)
        self.errorCode = try container.decodeIfPresent(Int.self, forKey: .errorCode)
        self.numberOfRecords = try container.decodeIfPresent(Int.self, forKey: .numberOfRecords)
        self.consents = try container.decodeIfPresent([ConsentAnnual].self, forKey: .consents)
    }
    
    private static func extractEpoch(from input: String) -> String {
        do {
            let regex = try NSRegularExpression(pattern: #"[\d-]+"#, options: [])
            
            let matches = regex.matches(in: input,
                                        options: [],
                                        range: NSRange(location: 0, length: input.utf16.count))
            
            let result = matches.map { match in
                guard let range = Range(match.range, in: input) else {
                    return input
                }
                return String(input[range])
            }
            return result.joined()
        } catch {
            return input
        }
    }
    
    private static func convertToUTC(timestampWithOffset: String) -> String? {
        let components = timestampWithOffset.split(separator: "-")
        
        guard components.count == 2,
              let timestamp = Double(components[0]),
              let offset = Int(components[1]) else {
            return nil
        }
        
        let utcTimestamp = timestamp - Double(offset * 3600)
        
        let date = Date(timeIntervalSince1970: utcTimestamp / 1000)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let utcDateString = dateFormatter.string(from: date)
        
        return utcDateString
    }
}
