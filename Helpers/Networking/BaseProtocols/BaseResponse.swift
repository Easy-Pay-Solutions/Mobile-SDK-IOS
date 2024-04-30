
import Foundation

public protocol BaseResponse: Codable {
    var body: Data? { get }
}
