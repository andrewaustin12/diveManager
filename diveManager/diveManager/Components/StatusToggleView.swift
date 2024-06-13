//
//  StatusToggleView.swift
//  diveManager
//
//  Created by andrew austin on 6/11/24.
//

import SwiftUI

struct StatusToggleView: View {
    
    @Binding var isPaid: Bool

    var body: some View {
        HStack {
            Text("Status")
            Spacer()
            Toggle(isOn: $isPaid) {
                Text(isPaid ? "Paid" : "Unpaid")
                    .foregroundColor(isPaid ? .green : .red)
                    .bold()
                    .padding(7)
                    .background(isPaid ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                    .cornerRadius(8)
            }
            
        }
    }
}



struct StatusToggleView_Previews: PreviewProvider {
    @State static var isPaid = true

    static var previews: some View {
        StatusToggleView(isPaid: $isPaid)
            .environmentObject(DataModel())
    }
}

