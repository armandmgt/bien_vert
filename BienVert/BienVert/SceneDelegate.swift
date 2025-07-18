//
//  SceneDelegate.swift
//  BienVert
//
//  Created by Armand Mégrot on 12/06/2025.
//

import HotwireNative
import UIKit

let rootURL = URL(string: ProcessInfo.processInfo.environment["APP_URL"] ?? "https://bien-vert.armandmgt.fr/")!

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private var navigatorDelegate: NavigatorDelegate
    private let tabBarController: HotwireTabBarController

    override init() {
        navigatorDelegate = NavigatorDelegate(hotwireTabs: HotwireTab.all)
        tabBarController = HotwireTabBarController(navigatorDelegate: navigatorDelegate)
        navigatorDelegate.tabBarController = tabBarController

        super.init()
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        window?.rootViewController = tabBarController
        tabBarController.load(HotwireTab.all)
    }

    public func getTopViewController() -> UIViewController? {
        return tabBarController.activeNavigator.activeNavigationController.topViewController
    }

    public func focusTab(_ tab: HotwireTab) {
        tabBarController.selectedIndex = HotwireTab.all.firstIndex(of: tab) ?? 0
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
