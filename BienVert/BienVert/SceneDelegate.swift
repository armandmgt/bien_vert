//
//  SceneDelegate.swift
//  BienVert
//
//  Created by Armand Mégrot on 12/06/2025.
//

import HotwireNative
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private lazy var tabBarController = HotwireTabBarController(
        navigatorDelegate: self
    )
    private let navigator = Navigator(
        configuration: .init(
            name: "unauthenticated-navigator",
            startLocation: Endpoint.rootURL.appending(
                components: "session",
                "new"
            ),
        )
    )

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard (scene as? UIWindowScene) != nil else { return }

        window?.rootViewController = navigator.rootViewController
        navigator.start()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didSignIn),
            name: .didSignIn,
            object: nil
        )
    }

    @objc private func didSignIn() {
        if window?.rootViewController != tabBarController {
            window?.rootViewController = tabBarController
            tabBarController.load(Tab.authenticated)
            tabBarController.selectedIndex = 0
        }
    }

    private func didSignOut() {
        if window?.rootViewController != navigator.rootViewController {
            UIApplication.shared.unregisterForRemoteNotifications()
            window?.rootViewController = navigator.rootViewController
            navigator.rootViewController.popToRootViewController(
                animated: false
            )
            navigator.reload()
        }
    }
}

extension SceneDelegate: NavigatorDelegate {
    func handle(proposal: VisitProposal, from navigator: Navigator)
        -> ProposalResult
    {
        print(#function, proposal)
        if proposal.properties["is_after_sign_out_path"] as? Bool ?? false {
            didSignOut()
            return .reject
        }
        return .accept
    }
}
