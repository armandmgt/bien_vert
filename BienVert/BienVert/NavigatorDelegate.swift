//
//  NavigatorDelegate.swift
//  BienVert
//
//  Created by Armand Mégrot on 18/06/2025.
//

import Foundation
import HotwireNative
import UIKit

class NavigatorDelegate: HotwireNative.NavigatorDelegate {
    func visitableDidFailRequest(
        _ visitable: Visitable,
        error: Error,
        retryHandler: RetryBlock?
    ) {
        if let httpError = error as? TurboError,
            httpError == .http(statusCode: 401)
        {
            if let viewController = visitable as? UIViewController {
                if !(viewController.presentedViewController
                    is LoginViewController)
                {
                    let loginViewController = LoginViewController()
                    viewController.present(
                        loginViewController,
                        animated: true,
                        completion: nil
                    )
                }
            }
            return
        }

        if let errorPresenter = visitable as? ErrorPresenter {
            errorPresenter.presentError(error, retryHandler: retryHandler)
        }
    }
}
