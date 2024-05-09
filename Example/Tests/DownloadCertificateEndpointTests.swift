import XCTest
import Security
@testable import EasyPay

class DownloadCertificateEndpointTests: XCTestCase {
    let api = ApiClient(configuration: Config(
        apiKey: "",
        hmacToken: "", 
        sentryKey: ""))
    
    let successExpectation = XCTestExpectation(description: "Download succeded")
    let failExpectation = XCTestExpectation(description: "Download failed")

    let faultyUrlString = "kdfjdkld"
    let session = URLSession(configuration: URLSessionConfiguration.default)

    func testDownloadingCertificateSucesss() {
        api.downloadManuallyCertificate { result in
            switch result {
            case .success(_):
                XCTAssertEqual(self.api.certificateStatus, .success)
                self.successExpectation.fulfill()
            case .failure(_):
                XCTAssertEqual(self.api.certificateStatus, .failed)
            }
        }
        wait(for: [successExpectation], timeout: 5.0)
    }
    
    func testDownloadingCertificateFailure() {
        mockDownloadCertificate { data, error in
            if error == nil, data == nil {
                self.failExpectation.fulfill()
            }
        }
        wait(for: [failExpectation], timeout: 5.0)
    }
    
    //Mock helper
    func mockDownloadCertificate(completion: @escaping (Data?, Error?) -> Void) {
        guard ValidatorUtils.isValidUrl(faultyUrlString), let certificateUrl = URL(string: faultyUrlString) else {
            completion(nil, NetworkingError.invalidCertificatePathURL)
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
    
}

