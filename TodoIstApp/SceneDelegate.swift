//
//  SceneDelegate.swift
//  TodoListApp
//
//  Created by Нурик  Генджалиев   on 13.06.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let mainVC = ToDoIstViewController()
        let mainNavVC = UINavigationController(rootViewController: mainVC)
        
        let addVC = AddEditToDoViewController()
        let editNavVC = UINavigationController(rootViewController: addVC)
        
        let tabBarController = MainTabBarController()
        tabBarController.viewControllers = [mainNavVC, editNavVC]
        
        window = UIWindow(windowScene: windowScene)
        setupGlobalAppearance()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
    
    private func setupGlobalAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        appearance.titlePositionAdjustment = UIOffset(
            horizontal: -UIScreen.main.bounds.width/2 + 16,
            vertical: 0
        )
        
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().tintColor = .systemYellow
        UINavigationBar.appearance().prefersLargeTitles = true
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
        CoreDataManager.shared.saveContext()
    }
    
    
}

