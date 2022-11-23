import UIKit
import Combine

final class SceneCoordinator {
    
    private let rootNavigationController: UINavigationController
    private var coordinators: [AnyObject] = []
        
    
    init(_ rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
    }
    
    func start() {
        let coordinator = GalleryCoordinator(rootNavigationController)
        coordinator.start()
        
        coordinators.append(coordinator)
    }
    
}
