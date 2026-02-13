//
//  NotificationCountComponent.swift
//  BienVert
//
//  Created by Armand on 13/02/2026.
//

import HotwireNative
import UIKit

final class NotificationCountComponent: BridgeComponent {
  override class var name: String { "notification-count" }

  override func onReceive(message: Message) {
    guard let event = Event(rawValue: message.event) else { return }

    switch event {
    case .connect:
      setTabBarBadge(via: message)
    }
  }

  private func setTabBarBadge(via message: Message) {
    guard let data: MessageData = message.data() else { return }

    UNUserNotificationCenter.current().setBadgeCount(data.count)
    NotificationCenter.default.post(name: .badgeUpdated, object: data.count)
  }
}

extension Notification.Name {
  static let badgeUpdated = Notification.Name("badgeUpdated")
}

extension NotificationCountComponent {
  fileprivate enum Event: String {
    case connect
  }
}

extension NotificationCountComponent {
  fileprivate struct MessageData: Decodable {
    let count: Int
  }
}
