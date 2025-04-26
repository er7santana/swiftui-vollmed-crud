//
//  Encodable+Extensions.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 26/04/25.
//

import Foundation

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
