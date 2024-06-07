import SwiftUI
import TipKit

struct EstProfitTip: Tip {
    // A parameter to track whether the tip should be shown
    @Parameter
    static var isProfitTaped: Bool = false
    
    var title: Text {
        Text("Total annual profit divided by the current day of the year.")
            
            .foregroundStyle(.secondary)
    }
    
    var message: Text? {
        Text("This average daily profit is then mulitplyed by 365.")
            
            .foregroundStyle(.secondary)
    }
  
    var rules: [Rule] {
        // Rule to show the tip when the icon is tapped
        #Rule(Self.$isProfitTaped) {
            // Set the conditions for when the tip displays.
            $0 == true
        }
    }
}

struct EstTaxTip: Tip {
    // A parameter to track whether the tip should be shown
    @Parameter
    static var isTaxTapped: Bool = false
    
    var title: Text {
        Text("20% of your forecased yearly profit.")
            .foregroundStyle(.secondary)
    }
    
    var message: Text? {
        Text("This estimate helps you think ahead for tax season. The percentage can be customized in Settings")
            .foregroundStyle(.secondary)
    }
    
    var rules: [Rule] {
        // Rule to show the tip when the icon is tapped
        #Rule(Self.$isTaxTapped) {
            // Set the conditions for when the tip displays.
            $0 == true
        }
    }
}

