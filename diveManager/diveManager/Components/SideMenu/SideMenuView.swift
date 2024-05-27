//
//  SideMenuView.swift
//  diveManager
//
//  Created by andrew austin on 2/29/24.
//

import SwiftUI

struct sideBar: Identifiable {
    var id = UUID()
    var icon: String
    var title: String
    var tab: TabIcon
    var index: Int
}

let sidebar = [
    sideBar(icon: "house.fill", title: "Home", tab: .Home, index: 0),
    sideBar(icon: "creditcard.fill", title: "Card", tab: .Card, index: 1),
    sideBar(icon: "heart.fill", title: "Favorite", tab: .Favorite, index: 2),
    sideBar(icon: "cart.fill.badge.plus", title: "Purchases", tab: .Purchases, index: 3),
    sideBar(icon: "bell.badge.fill", title: "Notifications", tab: .Notification, index: 4)
]

enum TabIcon: String {
    case Home
    case Card
    case Favorite
    case Purchases
    case Notification
}

struct SideMenuView: View {
    @State var selectedItem: TabIcon = .Home
    @State var yOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color.gray
                .frame(width: 266)
                .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
            VStack{
                VStack(alignment: .leading) {
                    UserImageView()
                    
                    tabView(selectedItem: $selectedItem, yOffset: $yOffset)
                        
                    
                }
                .padding(.leading, 15)
                divider()
                Spacer()
                    
            }
            
        }
        .ignoresSafeArea()
        .frame(maxHeight: .infinity)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    SideMenuView()
}

struct UserImageView: View {
    var body: some View {
        HStack{
            Circle()
                .frame(width: 65, height: 65)
            
            VStack(alignment: .leading, spacing: 4) {
                RoundedRectangle(cornerRadius: 3, style: .continuous)
                    .frame(width: 100, height: 14)
                RoundedRectangle(cornerRadius: 3, style: .continuous)
                    .frame(width: 80, height: 7)
                    .opacity(0.5)
                RoundedRectangle(cornerRadius: 3, style: .continuous)
                    .frame(width: 52, height: 7)
                    .opacity(0.5)
            }
            
        }
        .foregroundStyle(.white)
        .padding(.top, 60)
    }
}

struct tabView: View {
    @Binding var selectedItem: TabIcon
    @Binding var yOffset:CGFloat
    @State var isAnimation = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(width: isAnimation ? 10 : 230, height:45)
                .foregroundStyle(Color.secondary)
                .cornerRadius(7)
                .offset(y: yOffset)
                .padding(.vertical, 8)
                .padding(.horizontal, 5)
                .offset(y: -125)
                .offset(x: -20)
                .animation(.default, value: isAnimation)
            
            VStack(spacing: 0) {
                ForEach(sidebar) { item in
                    Button {
                        withAnimation {
                            isAnimation = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                            withAnimation {
                                selectedItem = item.tab
                                yOffset = CGFloat(item.index) * 70
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){
                            withAnimation {
                                isAnimation = false
                            }
                        }
                    } label: {
                        HStack {
                            ZStack {
                                Circle()
                                    .frame(width: 39, height: 40)
                                    .foregroundStyle(.ultraThinMaterial)
                                Image(systemName: item.icon)
                                    .foregroundStyle(.white)
                            }
                            Text(item.title)
                                .bold()
                                .font(.title3)
                                .foregroundStyle(.white)
                                .padding(.leading, 10)
                            
                            Spacer()
                        }
                        .padding(.top, 30)
                    }
                }
            }
            .frame(width: 240, height: 330)
        }
    }
}

struct divider: View {
    var body: some View {
        Rectangle()
            .frame(width: 266, height: 1)
            .foregroundStyle(.white.opacity(0.4))
            .padding(.top, 30)
    }
}
