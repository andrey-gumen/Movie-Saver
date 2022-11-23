import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var rootCoordinator: AnyObject?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        let rootNavigationController = UINavigationController();
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()
        
        let rootCoordinator = SceneCoordinator(rootNavigationController)
        rootCoordinator.start()
        
        self.rootCoordinator = rootCoordinator
    }
    
}
