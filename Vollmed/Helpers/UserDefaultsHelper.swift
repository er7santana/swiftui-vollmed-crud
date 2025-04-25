//
//  UserDefaultsHelper.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 24/04/25.
//

import Foundation

struct UserDefaultsHelper {
    
    private init() {}
    
    static func save(value: String, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func getValue(for key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    static func remove(for key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
