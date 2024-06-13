import Foundation
import Combine

extension UserDefaults {
    static let taxRatePublisher = PassthroughSubject<Double, Never>()
    static let commissionRatePublisher = PassthroughSubject<Double, Never>()
    static let currencyPublisher = PassthroughSubject<Currency, Never>()
    
    var taxRate: Double {
        get {
            return double(forKey: "taxRate")
        }
        set {
            set(newValue, forKey: "taxRate")
            UserDefaults.taxRatePublisher.send(newValue)
        }
    }
    
    var commissionRate: Double {
        get {
            return double(forKey: "commissionRate")
        }
        set {
            set(newValue, forKey: "commissionRate")
            UserDefaults.commissionRatePublisher.send(newValue)
        }
    }
    
    var currency: Currency {
        get {
            guard let rawValue = string(forKey: "selectedCurrency"),
                  let currency = Currency(rawValue: rawValue) else {
                return .usd // Default value
            }
            return currency
        }
        set {
            set(newValue.rawValue, forKey: "selectedCurrency")
            UserDefaults.currencyPublisher.send(newValue)
        }
    }
}

enum Currency: String, CaseIterable {
    case usd = "USD"
    case euro = "Euro"
    case pound = "British Pound"
    case baht = "Thai Baht"
    
    var symbol: String {
        switch self {
        case .usd:
            return "$"
        case .euro:
            return "€"
        case .pound:
            return "£"
        case .baht:
            return "฿"
        }
    }
    
    var iconName: String {
        switch self {
        case .usd:
            return "dollarsign"
        case .euro:
            return "eurosign"
        case .pound:
            return "sterlingsign"
        case .baht:
            return "bahtsign"
        }
    }
}
