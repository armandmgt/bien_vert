//
//  NotificationTokenViewModel.swift
//  BienVert
//
//  Created by Armand on 04/10/2025.
//

import Foundation
import HotwireNative

class NotificationTokenViewModel {
    func post(_ token: String) async -> Result<Bool, Error> {
        var request = URLRequest(
            url: Endpoint.rootURL.appending(components: "push_subscriptions")
        )
        request.httpMethod = "POST"
        request.addValue(
            Hotwire.config.userAgent,
            forHTTPHeaderField: "User-Agent"
        )
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONEncoder().encode(
                NotificationToken(deviceToken: token)
            )
            let (_, response) = try await URLSession.shared.data(for: request)
            let statusCode = (response as! HTTPURLResponse).statusCode

            if statusCode == 200 {
                return .success(true)
            } else {
                return .failure(TurboError.http(statusCode: statusCode))
            }
        } catch {
            return .failure(error)
        }
    }
}

extension NotificationTokenViewModel {
    fileprivate struct NotificationToken: Encodable {
        let deviceToken: String
        let platform = "ios"

        enum CodingKeys: String, CodingKey {
            case deviceToken
            case platform
        }
    }
}
