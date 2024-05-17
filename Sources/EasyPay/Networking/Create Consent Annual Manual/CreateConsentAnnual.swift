
import Foundation

public struct CreateConsentAnnual: Codable {
    let merchID: Int?
    let customerRefID: String?
    let serviceDescrip: String?
    let rpguid: String?
    let startDate: String //Timestamp in milliseconds in format \/Date(1710936735853)\/
    let limitPerCharge: String
    let limitLifeTime: String
    
    public init(merchID: Int?,
                customerRefID: String? = nil,
                serviceDescrip: String? = nil,
                rpguid: String? = nil,
                startDate: String,
                limitPerCharge: String,
                limitLifeTime: String) {
        self.merchID = merchID
        self.customerRefID = customerRefID
        self.serviceDescrip = serviceDescrip
        self.rpguid = rpguid
        self.startDate = startDate
        self.limitPerCharge = limitPerCharge
        self.limitLifeTime = limitLifeTime
    }
}
