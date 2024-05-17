
import Foundation

class CertificatePinningService: NSObject, URLSessionDelegate {
    private lazy var session = URLSession(configuration: .default,
                                          delegate: self,
                                          delegateQueue: nil)
    
    private let certificates: [Data] = {
        let url = Bundle.main.url(forResource: "run.mocky.io", withExtension: "cer")!
        let data = try! Data(contentsOf: url)
        return [data]
    }()
    
    
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if let trust = challenge.protectionSpace.serverTrust,
           SecTrustGetCertificateCount(trust) > 0 {
            if let certificate = SecTrustGetCertificateAtIndex(trust, 0) {
                let data = SecCertificateCopyData(certificate) as Data
                
                if certificates.contains(data) {
                    completionHandler(.useCredential, URLCredential(trust: trust))
                    return
                } else {
                    //TODO: Throw SSL Certificate Mismatch
                }
            }
            
        }
        completionHandler(.cancelAuthenticationChallenge, nil)
    }
}

