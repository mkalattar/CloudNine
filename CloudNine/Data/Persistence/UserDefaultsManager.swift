//
//  UserDefaultsManager.swift
//  CloudNine
//
//  Created by Mohamed Attar on 26/03/2025.
//

import Foundation

protocol UserDefaultsManagerProtocol {
    func save<T>(_ value: T, forKey key: String)
    func value<T>(forKey key: String) -> T?
    func exists(forKey key: String) -> Bool
}

class UserDefaultsManager: UserDefaultsManagerProtocol {
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func save<T>(_ value: T, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }

    func value<T>(forKey key: String) -> T? {
        return userDefaults.object(forKey: key) as? T
    }
    
    func exists(forKey key: String) -> Bool {
        return userDefaults.object(forKey: key) != nil
    }
}
