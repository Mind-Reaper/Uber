//
//  UserTile.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/12/25.
//

import SwiftUI

struct UserTile: View {
    
    private var user: AppUser
    
    init(user: AppUser) {
        self.user = user
    }
    
    var body: some View {
        HStack {
            Image("male-profile-photo")
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 64, height: 64)
            
            VStack(alignment: .leading) {
                Text(user.fullname)
                    .font(.system(size: 16, weight: .semibold))
                
                Text(user.email)
                    .foregroundColor(.gray)
                    .font(.system(size: 14, weight: .semibold))
            }
            .padding(.trailing)

        }
    }
}

#Preview {
    UserTile(user: AppUser.empty())
}
