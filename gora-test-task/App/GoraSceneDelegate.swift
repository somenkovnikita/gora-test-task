//
//  GoraSceneDelegate.swift
//  gora-test-task
//
//  Created by Nikita Somenkov on 18.12.2021.
//

import UIKit

class GoraSceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowsScene = scene as? UIWindowScene else {
            return
        }

        window = UIWindow(windowScene: windowsScene)
        window?.rootViewController = UsersBuilder().buildWithNavigation().view

        window?.makeKeyAndVisible()
    }

}

