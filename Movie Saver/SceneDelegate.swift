import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var mainCoordinator: AnyObject?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        let rootNavigationController = UINavigationController();
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()
        
        let galleryCoordinator = GalleryCoordinator(rootNavigationController)
        galleryCoordinator.start()
        
        mainCoordinator = galleryCoordinator
    }
    
}
