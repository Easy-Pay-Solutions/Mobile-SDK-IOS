# README

# Easy Pay iOS SDK

Easy Pay library offers an access to the Easy Pay API for seamless integration with iOS applications.

[General Easy Pay Developer Documentation](https://easypaysoftware.com/en/home)

## Installation

1. Setup with Swift Package Manager 
```
.package(url: "https://github.com/Easy-Pay-Solutions/Mobile-SDK-IOS.git", from: "1.0.6")
```
2. Setup with Cocoapods
```
pod 'EasyPay'
```
## Requirements

* Xcode 15 or above
* compatible with iOS 13.0 or above

## Get started

1. Prerequisites - obtained from Easy Pay HMAC secret and API key and optionally Sentry key

2. Configure Easy Pay class for example in your Payment Module or in AppDelegate (didFinishLaunchingWithOptions). Set isProduction = true to enable jailbroken device detection

```
EasyPay.shared.configureSecrets(apiKey: "YOURAPIKEY",
                                hmacSecret: "YOURHMACSECRET",
                                sentryKey: "YOURSENTRYKEY", 
                                isProduction: Bool)
 ```
3. Please keep in mind that during the Easy Pay initialization, the process of downloading the certificate is starting. Proceeding with any call before downloading has finished will result in an error (RsaCertificateError.failedToLoadCertificateData). You can check the status of downloading by accessing the following enum:
```
EasyPay.shared.certificateStatus
```
4. To enable jailbreak detection please set isProduction: true when initializing the library and add the following URL schemes to main Info.plist
```
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>undecimus</string>
    <string>sileo</string>
    <string>zbra</string>
    <string>filza</string>
    <string>activator</string>
</array>
```

## Widgets
EasyPay's prebuilt payment UI components that allows you to collect credit card information in a secure way and process payments.

### Managing cards
For managing saved cards without paying following initializer should be used:

```
 CardSelectionViewController(selectionDelegate: AnyObject, preselectedCardId: Int?, paymentDetails: AddAnnualConsentWidgetModel) throws
```
PreselectedCardId is optional parameter that allows to mark a card as selected by passing the consentId of this card. If nil or incorrect consentId is passed the selection will be ignored. 

Payment details parameter is used for passing additional payment details not visible for the end user.
Either ```customerReferenceId``` or ```rpguid``` must be provided to get the list of consents of a specific customer. In case of of incorrect initialization data ```CardSelectionViewControllerInitError``` will be thrown.

If you would like to receive callbacks conform to CardSelectionDelegate with following methods:
```
func didSelectCard(consentId: String) {}
```
```
func didDeleteCard(consentId: Int, success: Bool) {}
```
```
func didSaveCard(consentId: Int?, 
                 expMonth: Int?,
                 expYear: Int?,
                 last4digits: String?,
                 success: Bool)  {}
```
### Managing cards and payment
For managing saved cards and paying following initializer should be used:
```
CardSelectionViewController(amount: String, paymentDelegate: AnyObject, preselectedCardId: Int?, paymentDetails: AddAnnualConsentWidgetModel) throws
```
Amount should be higher than 0 and it is required parameter.

PreselectedCardId is optional parameter that allows to mark a card as selected by passing the consentId of this card. If nil or incorrect consentId is passed the selection will be ignored. 

Payment details parameter is used for passing additional payment details not visible for the end user.
Either ```customerReferenceId``` or ```rpguid``` must be provided to get the list of consents of a specific customer. In case of of incorrect initialization data ```CardSelectionViewControllerInitError``` will be thrown.

If you would like to receive callbacks conform to CardPaymentDelegate with following methods:

```
func didPayWithCard(consentId: Int?, paymentData: PaymentData?, success: Bool) {}
```
```
func didDeleteCard(consentId: Int, success: Bool) {}
```

## Public methods in EasyPay class

```
EasyPay.shared.configureSecrets(apiKey: String, hmacSecret: String)
```

```
EasyPay.shared.loadCertificate(_ completion: @escaping (Result<Data, Error>) -> Void)
```
## Public methods in ApiClient in EasyPay 
### 1. Charge Credit Card - CreditCardSale_Manual [Easy Pay API Documentation](https://easypaypi.com/APIDocsDev/).

This method processes a credit card cardsale when the credit card details are entered manually. Details include the card number, expiration date, CVV, card holder name and address.
```
EasyPay.apiClient.chargeCreditCard(request: CardSaleManualRequest,
                                   completion: @escaping (Result<CreditCardSaleResponse, Error>) -> Void)
```
#### Data Classes (Request)

* ChargeCreditCard
    * TransactionRequest
        *  creditCardInfo: CreditCardInfo
        *  accountHolder: AccountHolder
        *  endCustomer: EndCustomer?
        *  amounts: Amounts
        *  purchItems: PurchItems
        *  merchantId: Int

#### Data Classes (Response)

* ChargeCreditCard
    * CardSaleManualResponseModel

### 2. List Annual Consents - ConsentAnnual_Query [Easy Pay API Documentation](https://easypaypi.com/APIDocsDev/).

A query that returns annual consent details. Depending on the query sent, a single consent or multiple consents may be returned.
```
EasyPay.apiClient.listAnnualConsents(request: ConsentAnnualListingRequest,
                                     completion: @escaping (Result<ListingConsentAnnualResponse, Error>) -> Void)
```
#### Data Classes (Request)

* ListAnnualConsents
    * AnnualQueryHelper
        * merchantId: String
        * customerReferenceId: String?
        * rpguid: String?
        * endDate: Date?
Either customerReferenceId or rpguid must be provided to get the list of consents of a specific customer.

#### Data Classes (Response)

* ListAnnualConsents
    * ConsentAnnualListingResponseModel

### 3. Create Annual Consent - ConsentAnnual_Create_MAN [Easy Pay API Documentation](https://easypaypi.com/APIDocsDev/).

This method creates an annual consent by sending the credit card details, which include: card number, expiration date, CVV, and card holder contact data. It is not created by swiping the card through a reader device.
```
EasyPay.apiClient.createAnnualConsent(request: CreateConsentAnnualRequest,
                                      completion: @escaping (Result<CreateConsentAnnualResponse, Error>) -> Void)
```
#### Data Classes (Request)

* CreateAnnualConsent
    * CreateConsentAnnualManualRequestModel
        * creditCardInfo: CreditCardInfo
        * consentAnnualCreate: CreateConsentAnnual
        * accountHolder: AccountHolder
        * endCustomer: AnnualEndCustomer?

#### Data Classes (Response)

* CreateAnnualConsent
    * CreateConsentAnnualResponseModel
    
### 4. Cancel Annual Consent - ConsentAnnual_Cancel [Easy Pay API Documentation](https://easypaypi.com/APIDocsDev/).

Cancels an annual consent. Credit card data is removed from the system after the cancellation is complete.
```
EasyPay.apiClient.cancelAnnualConsent(request: CancelConsentAnnualRequest,
                                      completion: @escaping (Result<CancelConsentAnnualResponse, Error>) -> Void)
```

#### Data Classes (Request)

* CancelAnnualConsent
    * CancelConsentAnnualManualRequestModel
        * consentId: Int

#### Data Classes (Response)

* CancelAnnualConsent
    * CancelConsentAnnualResponseModel
    
### 5. Process Payment Annual Consent - ConsentAnnual_ProcPayment [Easy Pay API Documentation](https://easypaypi.com/APIDocsDev/).

This method uses the credit card stored on file to process a payment for an existing consent.

```
EasyPay.apiClient.processPaymentAnnualConsent(request: ProcessPaymentAnnualRequest,
                                              completion: @escaping (Result<ProcessPaymentAnnualResponse, Error>) -> Void)
```
#### Data Classes (Request)

*  ProcessPaymentAnnualConsent
    * ProcessPaymentAnnualRequestModel
        * consentId: Int
        * processAmount: String

#### Data Classes (Response)

*  ProcessPaymentAnnualConsent
    * ProcessPaymentAnnualResponseModel

## SecureTextField

The SDK contains a component called SecureTextField which ensures a safe input of numbers for credit card details. It is a subclass of UITextField which enables freedom of styling as needed.

Setting up requires configuring the certificate once it was downloaded to encrypt credit card data.

```
nameOfYourTextField.setupConfig(EasyPay.shared.config)
```

To receive the encrypted card string required to send to the API, you can use the following method:

```
nameOfYourTextField.encryptCardData()
```

## How to properly consume the API response

The response must be consumed in the intended order and format. Clients who deviate from this can experience unwanted behavior.
```
if response.data.errorMessage != "" && response.data.errorCode != 0 {
    //This indicates an error which was handled on the EasyPay servers, consume the ErrCode and the ErrMsg 
    return
} else if response.data.functionOk == true && response.data.txApproved == false {
    //This indicates a declined authorization, display the TXID, RspMsg (friendly decline message), also the decline Code (TxnCode)
} else {
   //Transaction has been approved, display the TXID,  and approval code (also in TXNCODE)  
}
```
For all other calls you will consume the response in the same way. If there is No TxApproved flag, then you can omit the last evaluation.

## Possible Errors

### RsaCertificateError

| Error name  | Suggested solution |
| ------------- |:-------------:|
| failedToLoadCertificateData      | Check certificate status, wait until the full download before proceeding with calls, try to download it again manually     |
| failedToCreateCertificate      | Contact Easy Pay     |
| failedToExtractPublicKey      | Contact Easy Pay     |

### AuthenticationError

| Error name  | Suggested solution |
| ------------- |:-------------:|
| missingSessionKeyOrExpired      | Check if you have provided the correct api key and hmacSecret, contact Easy Pay to receive updated secrets |

### NetworkingError

| Error name  | Suggested solution |
| ------------- |:-------------:|
| unsuccesfulRequest      | Check HTTP status code |
| noDataReceived      | Data from backend was empty, contact Easy Pay  |
| dataDecodingFailure      | Data from backend was not decoded properly, contact with Easy Pay |
| invalidCertificatePathURL    | Contact Easy Pay  |

## Semantic Versioning

Semantic versioning follows a three-part version number: MAJOR.MINOR.PATCH.

Increment the:
- MAJOR version when you make incompatible API changes,
- MINOR version when you add functionality in a backwards-compatible manner, and
- PATCH version when you make backwards-compatible bug fixes.
