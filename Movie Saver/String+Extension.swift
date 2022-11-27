import Foundation

extension String {
    
    func isURL() -> Bool {
        let url = URL(string: self)
        return url?.host != nil
    }
    
    func toURL() -> URL? {
        return URL(string: self)
    }

}
