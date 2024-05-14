//
//  SceneDelegate.swift
//  Crypto-App
//
//  Created by murat albayrak on 8.05.2024.
//

import UIKit
import CryptoAPI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//        
//        self.window = UIWindow(windowScene: windowScene)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        guard let rootVC = storyboard.instantiateViewController(withIdentifier: "CoinListController") as? CoinListController else {
//            return
//        }
//        
//        let viewModel = ViewModel()
//        rootVC.viewModel = viewModel
//        
//        self.window?.rootViewController = rootVC
//        self.window?.makeKeyAndVisible()
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Tab bar controller oluştur
        let tabBarController = UITabBarController()
        
        // İlgili view controller'ları oluştur
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let coinListVC = storyboard.instantiateViewController(withIdentifier: "CoinListController") as? CoinListController,
              let favoriteCoinsVC = storyboard.instantiateViewController(withIdentifier: "FavoriteMenuController") as? FavoriteMenuController else {
            fatalError("Unable to instantiate view controllers")
        }
        
        // Her view controller için bir navigation controller oluştur
        let coinListNav = UINavigationController(rootViewController: coinListVC)
       
        let favoriteCoinsNav = UINavigationController(rootViewController: favoriteCoinsVC)
        
        // Her bir view controller için bir tab bar item oluştur
        let coinListTabBarItem = UITabBarItem(title: "Coin List", image: UIImage(systemName: "list.dash"), selectedImage: nil)
        let favoriteCoinsTabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart.fill"), selectedImage: nil)

        // Tab bar item'ları ilgili navigation controller'lara ata
        coinListNav.tabBarItem = coinListTabBarItem
        favoriteCoinsNav.tabBarItem = favoriteCoinsTabBarItem
        
        // Her bir navigation controller'ı tab bar controller'a ekle
        tabBarController.viewControllers = [coinListNav, favoriteCoinsNav]
        
        let viewModel = ViewModel()
        coinListVC.viewModel = viewModel
        // Tab bar controller'ı ana view controller olarak ayarla
        self.window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
        
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

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

