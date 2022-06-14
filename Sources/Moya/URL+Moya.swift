import Foundation

public extension URL {

    /// Initialize URL from Moya's `TargetType`.
    init<T: TargetType>(target: T) {
        // When a TargetType's path is empty, URL.appendingPathComponent may introduce trailing /, which may not be wanted in some cases
        // See: https://github.com/Moya/Moya/pull/1053
        // And: https://github.com/Moya/Moya/issues/1049
        let targetPath = target.path
        if targetPath.isEmpty {
            self = target.baseURL
        }else if target.path.contains("?") {
            // 这里直接强制解包了，这里可以修改，如果你需要。
            let newPath = target.baseURL.absoluteString + target.path
            let encodPath = newPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            if let url = URL(string: encodPath) {
                self = url
            }else{
                self = target.baseURL
            }
        } else {
            self = target.baseURL.appendingPathComponent(targetPath)
        }
    }
}
