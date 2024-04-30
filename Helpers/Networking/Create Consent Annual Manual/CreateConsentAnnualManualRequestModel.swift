
import Foundation

public struct CreateConsentAnnualManualRequestModel: Codable {
    let creditCardInfo: CreditCardInfo
    let consentAnnualCreate: CreateConsentAnnual
    let accountHolder: AccountHolder
    let endCustomer: AnnualEndCustomer?
    
    public init(creditCardInfo: CreditCardInfo,
                consentAnnualCreate: CreateConsentAnnual,
                accountHolder: AccountHolder,
                endCustomer: AnnualEndCustomer?) {
        self.creditCardInfo = creditCardInfo
        self.consentAnnualCreate = consentAnnualCreate
        self.accountHolder = accountHolder
        self.endCustomer = endCustomer
    }
    
    public struct AnnualEndCustomer: Codable {
        let firstName: String?
        let lastName: String?
        let company: String?
        let billingAddress: AnnualEndCustomerBillingAddress?
        let email: String?
        let phone: String?
        
        public init(firstName: String?,
                    lastName: String?,
                    company: String?,
                    billingAddress: AnnualEndCustomerBillingAddress?,
                    email: String?,
                    phone: String?) {
            self.firstName = firstName
            self.lastName = lastName
            self.company = company
            self.billingAddress = billingAddress
            self.email = email
            self.phone = phone
        }
    }
    
    public struct AnnualEndCustomerBillingAddress: Codable {
        let address1: String?
        let address2: String?
        let city: String?
        let state: String?
        let zip: String?
        let country: String?
        
        public init(address1: String?,
                    address2: String?,
                    city: String?,
                    state: String?,
                    zip: String?,
                    country: String?) {
            self.address1 = address1
            self.address2 = address2
            self.city = city
            self.state = state
            self.zip = zip
            self.country = country
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case creditCardInfo = "ccCardInfo"
        case consentAnnualCreate = "ConsentCreator"
        case accountHolder = "AcctHolder"
        case endCustomer = "EndCustomer"
    }
    
    public func convertToDictionary() -> [String: Any] {
        var endCustomerConverted: Any
       
        if let endCustomer {
            endCustomerConverted = [
            "EndCustomer": [
                "Firstname": endCustomer.firstName as Any,
                "Lastname": endCustomer.lastName as Any,
                "Company": endCustomer.company as Any,
                "Title": "",
                "Url": "",
                "BillIngAdress": [
                    "Address1": endCustomer.billingAddress?.address1,
                    "Address2": endCustomer.billingAddress?.address2,
                    "City": endCustomer.billingAddress?.city,
                    "State": endCustomer.billingAddress?.state,
                    "ZIP": endCustomer.billingAddress?.zip,
                    "Country": endCustomer.billingAddress?.country
                ],
                "Email": endCustomer.email as Any,
                "Phone": endCustomer.phone as Any
                ]
            ]
        } else {
            endCustomerConverted = [:]
        }
   
        return [
            "ccCardInfo": [
                "AccountNumber": creditCardInfo.accountNumber,
                "ExpMonth": creditCardInfo.expirationMonth as Any,
                "ExpYear": creditCardInfo.expirationYear as Any,
                "CSV": creditCardInfo.cvv
            ],
            "AcctHolder": [
                "Firstname": accountHolder.firstName,
                "Lastname": accountHolder.lastName,
                "Company": accountHolder.company as Any,
                "Title": "",
                "Url": "",
                "BillIngAdress": [
                    "Address1": accountHolder.billingAddress.address1,
                    "Address2": accountHolder.billingAddress.address2,
                    "City": accountHolder.billingAddress.city,
                    "State": accountHolder.billingAddress.state,
                    "ZIP": accountHolder.billingAddress.zip,
                    "Country": accountHolder.billingAddress.country
                ],
                "Email": accountHolder.email as Any,
                "Phone": accountHolder.phone as Any
            ],
            "EndCustomer": endCustomerConverted,
            "ConsentCreator": [
                "MerchID": consentAnnualCreate.merchID as Any,
                "CustomerRefID": consentAnnualCreate.customerRefID as Any,
                "ServiceDescrip": consentAnnualCreate.serviceDescrip as Any,
                "RPGUID": consentAnnualCreate.rpguid as Any,
                "StartDate": consentAnnualCreate.startDate,
                "NumDays": 365,
                "LimitPerCharge": ValidatorUtils.stripCurrencyFormatting(from: consentAnnualCreate.limitPerCharge) as Any,
                "LimitLifeTime": ValidatorUtils.stripCurrencyFormatting(from: consentAnnualCreate.limitLifeTime) as Any
            ],
        ]
    }
}
