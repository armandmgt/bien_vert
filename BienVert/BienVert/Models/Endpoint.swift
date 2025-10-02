//
//  Endpoint.swift
//  BienVert
//
//  Created by Armand on 02/10/2025.
//

import Foundation

class Endpoint {
    static let rootURL = URL(string: ProcessInfo.processInfo.environment["APP_URL"] ?? "https://bien-vert.armandmgt.fr/")!
}
