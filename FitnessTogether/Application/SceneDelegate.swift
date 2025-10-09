//
//  SceneDelegate.swift
//  FitnessTogether
//
//  Created by Данила Бондарь on 17.07.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let ftManager = FTManagerAPI()
        
        
        
        let factory = BaseCoachViewControllerFactory(ftManager: ftManager)
        let c2 = BaseCoachCoordinator(factory: factory)
        
        let f1 = BaseAuthViewControllerFactory(ftManager: ftManager)
        let c1 = BaseAuthCoordinator(factory: f1)
        
        let f3 = BaseClientViewControllerFactory(ftManager: ftManager)
        let c3 = BaseClientCoordinator(factory: f3)
        
        
        let bag = CoordinatorBag(authCoordinator: c1, coachCoordinator: c2, clientCoordinator: c3)
        let appCoordinator = BaseAppCoordinator(window: window!, coordinators: bag, ftManager: ftManager)
        
        
//        window?.rootViewController = c2.mainVC
//        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

