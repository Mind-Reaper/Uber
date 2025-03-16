//
//  SettingsTile.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/12/25.
//

import SwiftUI

struct SettingsTile: View {
    
    let icon: String
    let title: String
    var subtitle: String? = nil
    var action: () -> Void = { }

    
    var body: some View {
        Button {
            action()
        } label: {
            HStack (spacing: 20) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .font(.title3)
                
                VStack (alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.system(size: 14))
                            .foregroundStyle(.gray)
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .imageScale(.small)
                    .font(.title2)
                    .foregroundColor(.gray)
                
            }
        }
        .listRowBackground(Color.theme.backgroundColor)
    }
}

#Preview {
    SettingsTile(
        icon: "house.fill", title: "Home", subtitle: "Add Home"
    )
}
