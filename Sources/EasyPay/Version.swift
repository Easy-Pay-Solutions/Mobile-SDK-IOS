
import Foundation

public enum VersionType {
    case actual //version is matching
    case deprecated //minor version y differs
    case outdated //major version x differs
}

public class VersionManager {
    let currentVersion = "1.0.0"
    private let minVersion = "1.0.0"
    
    public init() {}

    public func checkVersionType() -> VersionType {
        //TODO: Fetch from server
        let appVersion = "1.0.0"
        
        if currentVersion == appVersion {
            return .actual
        }
        
        if compareMajorVersions(appVersion: appVersion, minVersion: minVersion) == .outdated {
            return .outdated
        }
        
        if compareMinorVersions(appVersion: appVersion, minVersion: minVersion) == .deprecated {
            return .deprecated
        }
        return .actual
    }
    
    private func compareMajorVersions(appVersion: String, minVersion: String) -> VersionType {
        let appVersionComponents = appVersion.components(separatedBy: ".")
        let minVersionComponents = minVersion.components(separatedBy: ".")
        
        let appMajorVersion = Int(appVersionComponents.first ?? "0") ?? 0
        let minAppMajorVersion = Int(minVersionComponents.first ?? "0") ?? 0
        
        if appMajorVersion < minAppMajorVersion {
            return .outdated
        } else {
            return .actual
        }
    }
    
    private func compareMinorVersions(appVersion: String, minVersion: String) -> VersionType {
        let appVersionComponents = appVersion.components(separatedBy: ".")
        let minVersionComponents = minVersion.components(separatedBy: ".")
        
        let appMinorVersion = Int(appVersionComponents.dropFirst().first ?? "0") ?? 0
        let minAppMinorVersion = Int(minVersionComponents.dropFirst().first ?? "0") ?? 0
        
        if appMinorVersion < minAppMinorVersion {
            return .deprecated
        } else {
            return .actual
        }
    }
}
