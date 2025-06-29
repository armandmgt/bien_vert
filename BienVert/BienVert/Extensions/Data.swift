//
//  Data.swift
//  BienVert
//
//  Created by Armand Mégrot on 29/06/2025.
//

import Foundation

extension Data {
    func hexEncodedString() -> String {
        map { String(format: "%02hhx", $0) }.joined()
    }
}
