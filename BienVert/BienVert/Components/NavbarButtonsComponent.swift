//
//  NavbarButtonsComponent.swift
//  BienVert
//
//  Created by Armand Mégrot on 14/06/2025.
//

import HotwireNative
import UIKit

final class NavbarButtonsComponent: BridgeComponent {
    override class var name: String { "navbar-buttons" }

    private var viewController: UIViewController? {
        delegate?.destination as? UIViewController
    }

    override func onReceive(message: Message) {
        guard let event = Event(rawValue: message.event) else { return }

        switch event {
        case .connect:
            addMenuButtons(via: message)
        }
    }

    private func addMenuButtons(via message: Message) {
        guard let data: MessageData = message.data() else { return }

        var actions = [UIAction]()
        for (index, item) in data.items.enumerated() {
            let image = UIImage(systemName: item.image ?? "")
            let action = UIAction(title: item.title, image: image) {
                [unowned self] _ in
                reply(
                    to: message.event,
                    with: SelectionMessageData(index: index)
                )
            }
            actions.append(action)
        }
        actions.append(
            UIAction(title: "Déconnexion", image: UIImage(systemName: "power"))
            { [] _ in
                let logoutURL = rootURL.appendingPathComponent("session")
                var request = URLRequest(url: logoutURL)
                request.httpMethod = "DELETE"
                request.setValue(data.csrfToken, forHTTPHeaderField: "X-CSRF-Token")
                let session = URLSession(configuration: .default, delegate: RedirectBlocker(), delegateQueue: nil)
                let task = session.dataTask(with: request) { data, response, error in
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 302 {
                        DispatchQueue.main.async {
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let window = windowScene.windows.first,
                               let tabBarController = window.rootViewController as? HotwireTabBarController {
                                tabBarController.load(HotwireTab.all)
                            }
                        }
                    }
                }
                task.resume()
            }
        )

        let button = UIBarButtonItem(
            title: "Menu",
            image: UIImage(systemName: "ellipsis"),
            menu: UIMenu(children: actions)
        )

        viewController?.navigationItem.rightBarButtonItem = button
    }
}

extension NavbarButtonsComponent {
    fileprivate enum Event: String {
        case connect
    }
}

extension NavbarButtonsComponent {
    fileprivate struct MessageData: Decodable {
        let items: [Item]
        let csrfToken: String
    }

    fileprivate struct Item: Decodable {
        let title: String
        let image: String?

        enum CodingKeys: String, CodingKey {
            case title
            case image = "iosImage"
        }
    }

    fileprivate struct SelectionMessageData: Encodable {
        let index: Int?
    }
}

private class RedirectBlocker: NSObject, URLSessionDelegate, URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        completionHandler(nil)
    }
}
