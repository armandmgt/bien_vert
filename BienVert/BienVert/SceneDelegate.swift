//
//  SceneDelegate.swift
//  BienVert
//
//  Created by Armand Mégrot on 12/06/2025.
//

import HotwireNative
import UIKit

let rootURL = URL(string: "https://bien-vert.armandmgt.fr")!

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private let navigator = Navigator(configuration: .init(
        name: "main",
        startLocation: rootURL
    ))

    private let tabBarController = HotwireTabBarController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        window?.rootViewController = tabBarController
        tabBarController.load(HotwireTab.all)
    }
}

extension HotwireTab {
    static let all = [
        HotwireTab(
            title: "Plantes",
            image: UIImage(systemName: "leaf")!,
            url: rootURL
        ),

        HotwireTab(
            title: "Nouvelle reconnaissance",
            image: UIImage(systemName: "sparkle.magnifyingglass")!,
            url: rootURL.appending(path: "recognition_requests/new")
        )
    ]
}
