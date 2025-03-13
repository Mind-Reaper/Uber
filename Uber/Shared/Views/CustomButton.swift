//
//  CustomButton.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/4/25.
//

import SwiftUI

struct CustomButton: View {
    
    
    
  
    var title: String?
    var systemIcon: String?
    let action: () -> Void
    
    
    
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                if (title != nil)  {
                    Text(title!)
                        .fontWeight(.bold)
                        .foregroundColor(.buttonForeground)
                }
                
                if (systemIcon != nil) {
                    
                    Image(systemName: systemIcon!)
                        .fontWeight(.bold)
                        .foregroundColor(.buttonForeground)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background(.buttonBackground)
            .cornerRadius(10)
        }
       
    }
}

#Preview {
    CustomButton {
        
    }
}
