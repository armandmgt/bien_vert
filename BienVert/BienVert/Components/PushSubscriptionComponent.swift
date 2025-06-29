//
//  PushSubscriptionComponent.swift
//  BienVert
//
//  Created by Armand Mégrot on 29/06/2025.
//

import HotwireNative
import UIKit

final class PushSubscriptionComponent: BridgeComponent {
    override class var name: String { "push-subscription" }

    override func onReceive(message: Message) {
        guard let event = Event(rawValue: message.event) else { return }
        guard let data: MessageData = message.data() else { return }

        switch event {
        case .connect:
            UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .badge, .sound]
            ) { granted, error in
                if let error = error {
                    print(
                        "Error requesting notification authorization: \(error)"
                    )
                } else if granted {
                    DispatchQueue.main.async {
                        if data.needsNewToken || !UIApplication.shared.isRegisteredForRemoteNotifications {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                }
            }
        }
    }

    public func saveDeviceToken(_ deviceToken: Data) {
        reply(
            to: "connect",
            with: ResponseMessageData(
                deviceToken: deviceToken.hexEncodedString(),
            )
        )
    }
}

extension PushSubscriptionComponent {
    fileprivate enum Event: String {
        case connect
    }
}

extension PushSubscriptionComponent {
    fileprivate struct MessageData: Decodable {
        let needsNewToken: Bool
    }

    struct ResponseMessageData: Encodable {
        let deviceToken: String
    }
}
