
import Foundation

public struct TransactionRequest: Codable {
    let creditCardInfo: CreditCardInfo
    let accountHolder: AccountHolder
    let endCustomer: EndCustomer?
    let amounts: Amounts
    let purchItems: PurchItems
    let merchantId: Int?
    
    public init(creditCardInfo: CreditCardInfo,
                accountHolder: AccountHolder,
                endCustomer: EndCustomer?,
                amounts: Amounts,
                purchItems: PurchItems,
                merchantId: Int?) {
        self.creditCardInfo = creditCardInfo
        self.accountHolder = accountHolder
        self.endCustomer = endCustomer
        self.amounts = amounts
        self.purchItems = purchItems
        self.merchantId = merchantId
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
            "Amounts": [
                "TotalAmt": ValidatorUtils.stripCurrencyFormatting(from: amounts.totalAmount) as Any,
                "SalesTax": ValidatorUtils.stripCurrencyFormatting(from: amounts.salesAmount) as Any,
                "Surcharge": ValidatorUtils.stripCurrencyFormatting(from: amounts.surcharge) as Any,
                "Tip": 0.0,
                "CashBack": 0.0,
                "ClinicAmount": 0.0,
                "VisionAmount": 0.0,
                "PrescriptionAmount": 0.0,
                "DentalAmount": 0.0,
                "TotalMedicalAmount": 0.0
            ],
            "PurchItems": [
                "ServiceDescrip": purchItems.serviceDescription,
                "ClientRefID": purchItems.clientRefId,
                "RPGUID": purchItems.rpguid
            ],
            "MerchID": merchantId as Any
        ]
    }
}

public struct CreditCardInfo: Codable {
    let accountNumber: String //credit card number encoded in base 64
    let expirationMonth: Int?
    let expirationYear: Int?
    let cvv: String
    
    public init(accountNumber: String, expirationMonth: Int?, expirationYear: Int?, cvv: String) {
        self.accountNumber = accountNumber
        self.expirationMonth = expirationMonth
        self.expirationYear = expirationYear
        self.cvv = cvv
    }
}

public struct CreditCardSaleManual: Codable {
    let merchantId: Int
    let accountNumber: String
    let expirationMonth: Int?
    let expirationYear: Int?
    let cvv: Int
    
    let accountHolder: AccountHolder
    let endCustomer: EndCustomer?
    let amounts: Amounts?
    let purchItems: PurchItems?
    
    public init(merchantId: Int,
                accountNumber: String,
                expirationMonth: Int? = nil,
                expirationYear: Int? = nil,
                cvv: Int,
                accountHolder: AccountHolder,
                endCustomer: EndCustomer? = nil,
                amounts: Amounts? = nil,
                purchItems: PurchItems? = nil) {
        self.merchantId = merchantId
        self.accountNumber = accountNumber
        self.expirationMonth = expirationMonth
        self.expirationYear = expirationYear
        self.cvv = cvv
        self.accountHolder = accountHolder
        self.endCustomer = endCustomer
        self.amounts = amounts
        self.purchItems = purchItems
    }
}

public struct AccountHolder: Codable {
    let firstName: String
    let lastName: String
    let company: String?
    let billingAddress: BillingAddress
    let email: String?
    let phone: String?
    
    public init(firstName: String,
                lastName: String,
                company: String? = nil,
                billingAddress: BillingAddress,
                email: String? = nil,
                phone: String? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.company = company
        self.billingAddress = billingAddress
        self.email = email
        self.phone = phone
    }
}

public struct BillingAddress: Codable {
    let address1: String
    let address2: String?
    let city: String?
    let state: String?
    let zip: String
    let country: String?
    
    public init(address1: String,
                address2: String? = nil,
                city: String? = nil,
                state: String? = nil,
                zip: String,
                country: String? = nil) {
        self.address1 = address1
        self.address2 = address2
        self.city = city
        self.state = state
        self.zip = zip
        self.country = country
    }
}

public struct EndCustomerBillingAddress: Codable {
    let address1: String?
    let address2: String?
    let city: String?
    let state: String?
    let zip: String?
    let country: String?
    
    public init(address1: String? = nil,
                address2: String? = nil,
                city: String? = nil,
                state: String? = nil,
                zip: String? = nil,
                country: String? = nil) {
        self.address1 = address1
        self.address2 = address2
        self.city = city
        self.state = state
        self.zip = zip
        self.country = country
    }
}

public struct EndCustomer: Codable {
    let firstName: String?
    let lastName: String?
    let company: String?
    let billingAddress: EndCustomerBillingAddress?
    let email: String?
    let phone: String?
    
    public init(firstName: String? = nil,
                lastName: String? = nil,
                company: String? = nil,
                billingAddress: EndCustomerBillingAddress?,
                email: String? = nil,
                phone: String? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.company = company
        self.billingAddress = billingAddress
        self.email = email
        self.phone = phone
    }
}

public struct Amounts: Codable {
    let totalAmount: String
    let salesAmount: String?
    let surcharge: String?
    
    public init(totalAmount: String,
                salesAmount: String? = nil,
                surcharge: String? = nil) {
        self.totalAmount = totalAmount
        self.salesAmount = salesAmount
        self.surcharge = surcharge
    }
}

public struct PurchItems: Codable {
    let serviceDescription: String?
    let clientRefId: String?
    let rpguid: String?
    
    public init(serviceDescription: String? = nil,
                clientRefId: String? = nil,
                rpguid: String? = nil) {
        self.serviceDescription = serviceDescription
        self.clientRefId = clientRefId
        self.rpguid = rpguid
    }
}
