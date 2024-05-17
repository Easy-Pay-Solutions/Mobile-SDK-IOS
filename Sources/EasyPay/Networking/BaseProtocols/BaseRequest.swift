
import Foundation

public protocol BaseRequest {
    var body: Data { get }
    var path: String { get }
    var httpMethod: String { get }
}
