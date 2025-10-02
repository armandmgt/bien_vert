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
            .file(localPathConfigURL),
            .server(Endpoint.rootURL.appending(components: "hotwire", "configurations", "ios.json"))
        ])
        Hotwire.registerBridgeComponents([
            AuthenticationComponent.self,
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
    }
}
