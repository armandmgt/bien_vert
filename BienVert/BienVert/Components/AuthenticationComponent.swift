//
//  AuthenticationComponent.swift
//  BienVert
//
//  Created by Armand on 02/10/2025.
//

import HotwireNative
import UIKit

final class AuthenticationComponent: BridgeComponent {
  override class var name: String { "authentication" }

  override func onReceive(message: Message) {
    print(#function, "received message:", message)
    NotificationCenter.default.post(name: .didSignIn, object: nil)
  }
}

extension Notification.Name {
  static let didSignIn = Notification.Name("didSignIn")
  static let didSignOut = Notification.Name("didSignOut")
}
