//
//  Tab.swift
//  BienVert
//
//  Created by Armand on 02/10/2025.
//

import HotwireNative
import UIKit

enum Tab {
    static var authenticated: [HotwireTab] { [
        HotwireTab(
            title: "Plantes",
            image: UIImage(systemName: "leaf")!,
            url: Endpoint.rootURL
        ),

        HotwireTab(
            title: "Nouvelle reconnaissance",
            image: UIImage(systemName: "sparkle.magnifyingglass")!,
            url: Endpoint.rootURL.appending(components: "recognition_requests", "new")
        )
    ] }
}
