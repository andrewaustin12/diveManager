//
//  UserDefaults.swift
//  diveManager
//
//  Created by andrew austin on 6/2/24.
//

import Foundation

import Combine
import Foundation

extension UserDefaults {
    static let taxRatePublisher = PassthroughSubject<Double, Never>()
    static let commissionRatePublisher = PassthroughSubject<Double, Never>()
    
    var taxRate: Double {
        get {
            return double(forKey: "taxRate")
        }
        set {
            set(newValue, forKey: "taxRate")
            UserDefaults.taxRatePublisher.send(newValue)
        }
    }
    
    var commisionRate: Double {
        get {
            return double(forKey: "commissionRate")
        }
        set {
            set(newValue, forKey: "taxRate")
            UserDefaults.commissionRatePublisher.send(newValue)
        }
    }
}
