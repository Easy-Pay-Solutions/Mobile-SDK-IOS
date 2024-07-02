
import Foundation

public struct AddAnnualConsentWidgetModel {
    public init(merchantId: String,
                accountHolderCompany: String? = nil,
                accountHolderPhone: String? = nil,
                accountHolderEmail: String? = nil,
                endCustomerFirstName: String? = nil,
                endCustomerLastName: String? = nil,
                endCustomerCompany: String? = nil,
                endCustomerPhone: String? = nil,
                endCustomerEmail: String? = nil,
                accountHolderAddress2: String? = nil,
                accountHolderCity: String? = nil,
                accountHolderState: String? = nil,
                accountHolderCountry: String? = nil,
                endCustomerAddress1: String? = nil,
                endCustomerAddress2: String? = nil,
                endCustomerCity: String? = nil,
                endCustomerState: String? = nil,
                endCustomerZip: String? = nil,
                endCustomerCountry: String? = nil,
                customerReferenceId: String,
                serviceDescription: String? = nil,
                rpguid: String? = nil,
                startDate: Date? = nil,
                limitPerCharge: String,
                limitLifetime: String) {
        self.merchantId = merchantId
        self.accountHolderCompany = accountHolderCompany
        self.accountHolderPhone = accountHolderPhone
        self.accountHolderEmail = accountHolderEmail
        self.endCustomerFirstName = endCustomerFirstName
        self.endCustomerLastName = endCustomerLastName
        self.endCustomerCompany = endCustomerCompany
        self.endCustomerPhone = endCustomerPhone
        self.endCustomerEmail = endCustomerEmail
        self.accountHolderAddress2 = accountHolderAddress2
        self.accountHolderCity = accountHolderCity
        self.accountHolderState = accountHolderState
        self.accountHolderCountry = accountHolderCountry
        self.endCustomerAddress1 = endCustomerAddress1
        self.endCustomerAddress2 = endCustomerAddress2
        self.endCustomerCity = endCustomerCity
        self.endCustomerState = endCustomerState
        self.endCustomerZip = endCustomerZip
        self.endCustomerCountry = endCustomerCountry
        self.customerReferenceId = customerReferenceId
        self.serviceDescription = serviceDescription
        self.rpguid = rpguid
        self.startDate = startDate
        self.limitPerCharge = limitPerCharge
        self.limitLifetime = limitLifetime
    }
    
    public let merchantId: String
    
    public let accountHolderCompany: String?
    public let accountHolderPhone: String?
    public let accountHolderEmail: String?
    
    public let accountHolderAddress2: String?
    public let accountHolderCity: String?
    public let accountHolderState: String?
    public let accountHolderCountry: String?
    
    public let endCustomerFirstName: String?
    public let endCustomerLastName: String?
    public let endCustomerCompany: String?
    public let endCustomerPhone: String?
    public let endCustomerEmail: String?
    
    public let endCustomerAddress1: String?
    public let endCustomerAddress2: String?
    public let endCustomerCity: String?
    public let endCustomerState: String?
    public let endCustomerZip: String?
    public let endCustomerCountry: String?
    
    public let customerReferenceId: String
    public let serviceDescription: String?
    public let rpguid: String?
    public let startDate: Date?
    public let limitPerCharge: String
    public let limitLifetime: String
}
