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
