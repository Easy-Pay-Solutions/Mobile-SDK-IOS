
import Foundation
import Sentry

public enum CertificateStatus {
    case success
    case loading
    case failed
}

public final class ApiClient {
    private let certificateString = "https://easypaysoftware.com/mobile.easypay5.com.cer"
    private let baseURL = URL(string: "https://easypay5.com/APIcardProcMobile")
    private let session: URLSession
    private let versionManager = VersionManager()
    private var configuration: Config
    private let encryptionUtils: EncryptionUtils
    private(set) public var certificateStatus: CertificateStatus? = .loading
    
    init(configuration: Config) {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
        self.configuration = configuration
        self.encryptionUtils = EncryptionUtils(apiKey: configuration.apiKey, hmacSecret: configuration.hmacSecret)
    }
    
    public func chargeCreditCard(request: CardSaleManualRequest,
                                 completion: @escaping (Result<CreditCardSaleResponse, Error>) -> Void) {
        fetchData(request: request) {
            (result: Result<CreditCardSaleResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                SentrySDK.capture(error: error)
                completion(.failure(error))
            }
        }
    }
    
    public func listAnnualConsents(request: ConsentAnnualListingRequest,
                                    completion: @escaping (Result<ListingConsentAnnualResponse, Error>) -> Void) {
        fetchData(request: request) {
            (result: Result<ListingConsentAnnualResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                SentrySDK.capture(error: error)
                completion(.failure(error))
            }
        }
    }
    
    public func createAnnualConsent(request: CreateConsentAnnualRequest,
                                    completion: @escaping (Result<CreateConsentAnnualResponse, Error>) -> Void) {
        fetchData(request: request) {
            (result: Result<CreateConsentAnnualResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                SentrySDK.capture(error: error)
                completion(.failure(error))
            }
        }
    }
    
    public func cancelAnnualConsent(request: CancelConsentAnnualRequest,
                                    completion: @escaping (Result<CancelConsentAnnualResponse, Error>) -> Void) {
        fetchData(request: request) {
            (result: Result<CancelConsentAnnualResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                SentrySDK.capture(error: error)
                completion(.failure(error))
            }
        }
    }
    
    public func processPaymentAnnualConsent(request: ProcessPaymentAnnualRequest,
                                            completion: @escaping (Result<ProcessPaymentAnnualResponse, Error>) -> Void) {
        fetchData(request: request) {
            (result: Result<ProcessPaymentAnnualResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                SentrySDK.capture(error: error)
                completion(.failure(error))
            }
        }
    }
    
    private func requestHelper(request: BaseRequest, baseURL: URL) -> URLRequest {
        let resourceUrl = baseURL.appendingPathComponent(request.path)
        var urlRequest = URLRequest(url: resourceUrl)
        urlRequest.httpMethod = request.httpMethod
        urlRequest.httpBody = request.body
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(try? encryptionUtils.sessionKey(), forHTTPHeaderField: "SessKey")
        return urlRequest
    }
    
    private func requestValidation(request: BaseRequest) -> (Error?, Bool) {
        let factory = ValidatorFactory.produce(request: request)
        return factory.validate(request)
    }
    
    private func fetchData<T: Codable>(request: BaseRequest, completion: @escaping (Result<T, Error>) -> Void) {
        guard certificateStatus == .success else {
            completion(.failure(RsaCertificateError.failedToLoadCertificateData))
            return
        }
        
        let dataRequest = requestHelper(request: request, baseURL: baseURL!)
        
        let requestValidation = requestValidation(request: request)
        
        if requestValidation.0 != nil {
            completion(.failure(requestValidation.0!))
            return
        }
        
        let task = session.dataTask(with: dataRequest) { (data, response, error) in
            if let error = error {
                SentrySDK.capture(error: error)
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                let error = NetworkingError.unsuccesfulRequest(statusCode: String(statusCode))
                SentrySDK.capture(error: error)
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NetworkingError.noDataReceived
                SentrySDK.capture(error: error)
                completion(.failure(error))
                return
            }
            
            if let sessionKeyExpired = self.findErrorCode(in: data, forKey: "ErrCode"), sessionKeyExpired == AuthenticationError.missingSessionKeyOrExpired.rawValue {
                completion(.failure(AuthenticationError.missingSessionKeyOrExpired))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
                return
            } catch {
                let error = NetworkingError.dataDecodingFailure
                SentrySDK.capture(error: error)
                completion(.failure(error))
                return
            }
        }
        
        task.resume()
    }
    
    public func downloadCertificate(completion: @escaping (Data?, Error?) -> Void) {
        guard ValidatorUtils.isValidUrl(certificateString), let certificateUrl = URL(string: certificateString) else {
            let error = NetworkingError.invalidCertificatePathURL
            SentrySDK.capture(error: error)
            completion(nil, error)
            return
        }
        let task = session.dataTask(with: certificateUrl) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            completion(data, nil)
            return
        }
        task.resume()
    }
    
    public func downloadManuallyCertificate(_ completion: @escaping (Result<Data, Error>) -> Void) {
        self.certificateStatus = .loading
        self.downloadCertificate { [weak self] data, error in
            guard let self = self else { return }
            if error != nil {
                self.certificateStatus = .failed
                completion(.failure(RsaCertificateError.failedToLoadCertificateData))
                return
            }
            if let data {
                self.configuration.setupThumbprint(thumbprint(for: data))
                self.certificateStatus = .success
                self.configuration.configureCertificate(encryptionUtils: self.encryptionUtils,
                                                        certificateData: data)
                completion(.success(data))
                return
            }
        }
    }
    
    private func parseResponseForFlags(data: Data) -> (functionOK: Bool, txApproved: Bool) {
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
    
    func thumbprint(for certificateData: Data) -> String {
        let sha1Digest = certificateData.sha1()
        let thumbprint = sha1Digest.map { String(format: "%02hhx", $0) }.joined()
        return thumbprint
    }
}
