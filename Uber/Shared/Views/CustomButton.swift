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
    var buttonColor: Color?
    var textColor: Color?
    let action: () -> Void
    
    
    
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                if (title != nil)  {
                    Text(title!)
                        .fontWeight(.bold)
                        .foregroundColor(textColor ?? .buttonForeground)
                }
                
                if (systemIcon != nil) {
                    
                    Image(systemName: systemIcon!)
                        .fontWeight(.bold)
                        .foregroundColor(textColor ?? .buttonForeground)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background(buttonColor ?? .buttonBackground)
            .cornerRadius(10)
        }
       
    }
}

#Preview {
    CustomButton {
        
    }
}
