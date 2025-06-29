//
//  AppDelegate.swift
//  BienVert
//
//  Created by Armand Mégrot on 12/06/2025.
//

import HotwireNative
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication
            .LaunchOptionsKey: Any]?
    ) -> Bool {
        let localPathConfigURL = Bundle.main.url(
            forResource: "path-configuration",
            withExtension: "json"
        )!

        Hotwire.config.debugLoggingEnabled = true
        Hotwire.loadPathConfiguration(from: [
            .file(localPathConfigURL)
        ])
        Hotwire.registerBridgeComponents([
            NavbarButtonsComponent.self,
            PushSubscriptionComponent.self,
        ])

        UINavigationBar.appearance().scrollEdgeAppearance = .init()
        UITabBar.appearance().scrollEdgeAppearance = .init()

        return true
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        guard
            let sceneDelegate = application.connectedScenes.first?.delegate
                as? SceneDelegate
        else {
            print("Failed to get SceneDelegate")
            return
        }

        if let topViewController = sceneDelegate.getTopViewController()
            as? HotwireWebViewController
        {
            let component: PushSubscriptionComponent? = topViewController
                .bridgeDelegate.component()
            component?.saveDeviceToken(deviceToken)
        }
    }
}
