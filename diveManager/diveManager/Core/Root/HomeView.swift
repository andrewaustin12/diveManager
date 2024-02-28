//
//  HomeView.swift
//  diveManager
//
//  Created by andrew austin on 2/27/24.
//

import SwiftUI

import SwiftUI

struct HomeView: View {
    @StateObject var diveManager = DiveManager()

    var body: some View {
        NavigationStack {
            Text("Home")
        }
    }
}


#Preview {
    HomeView()
}
