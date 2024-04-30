
import XCTest
@testable import EasyPay

class NoInternetConnectionTests: XCTestCase {
    private let api = MockNoConnectionApiClient(configuration: Config(
        apiKey: "",
        hmacToken: ""))
    
    lazy var request = CancelConsentAnnualRequest(cancelConsentAnnualRequest: CancelConsentAnnualManualRequestModel(consentId: 1))
    let failExpectation = XCTestExpectation(description: "Request was not successful")
    
    func testNoInternetConnection() {
        api.cancelAnnualConsent(request: request) { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                XCTAssert(error.localizedDescription ==  "The Internet connection appears to be offline.", "Error should be no connection")
                self.failExpectation.fulfill()
            }
        }
        wait(for: [failExpectation], timeout: 15.0)
    }
    
    private final class MockNoConnectionApiClient {
        private let baseURL = URL(string: "https://easypay5.com/APIcardProcMobile")
        private let session: URLSession
        private let encryptionUtils: EncryptionUtils
        private var configuration: Config
        private(set) public var certificateStatus: CertificateStatus? = .loading
        
        init(configuration: Config) {
            let config = URLSessionConfiguration.default
            session = URLSession(configuration: config)
            self.configuration = configuration
            self.encryptionUtils = EncryptionUtils(apiKey: configuration.apiKey, hmacSecret: configuration.hmacSecret)
        }
        
        public func cancelAnnualConsent(request: CancelConsentAnnualRequest,
                                        completion: @escaping (Result<CancelConsentAnnualResponse, Error>) -> Void) {
            fetchData(request: request) {
                (result: Result<CancelConsentAnnualResponse, Error>) in
                switch result {
                case .success(let response):
                    completion(.success(response))
                case .failure(let error):
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

        private func fetchData<T: Codable>(request: BaseRequest, completion: @escaping (Result<T, Error>) -> Void) {
            
            let dataRequest = requestHelper(request: request, baseURL: baseURL!)
            
            let task = session.dataTask(with: dataRequest) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                    completion(.failure(NetworkingError.unsuccesfulRequest(statusCode: String(statusCode))))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NetworkingError.noDataReceived))
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedResponse))
                    return
                } catch {
                    completion(.failure(NetworkingError.dataDecodingFailure))
                    return
                }
            }
            
            task.resume()
        }
    }
}
