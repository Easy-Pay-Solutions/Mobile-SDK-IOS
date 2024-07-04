
import Foundation

public func safeIndexAccess<T>(array: [T]?, index: Int) -> T? {
    guard let array = array, array.indices.contains(index) else {
        return nil
    }
    return array[index]
}
