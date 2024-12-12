//
//  SceneDelegate.swift
//  AEZAKMIApp
//
//  Created by Ваня Сокол on 05.12.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = NSLocalizedString("Cancel", comment: "")
        
        window?.rootViewController = UINavigationController(rootViewController: CountriesViewController())
        window?.makeKeyAndVisible()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        CoreDataManager.shared.saveContext()
    }
}

