//
//  InputField.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/4/25.
//

import SwiftUI

struct InputField: View {
    
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    
    
    @State private var showPassword: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text(title)
                .fontWeight(.semibold)
                .font(.footnote)
            
            if isSecureField {
                
                HStack {
                    if showPassword {
                        TextField(placeholder, text: $text) } else {     SecureField(placeholder, text: $text)
                        }
                    Button {
                        
                        showPassword = !showPassword
                        
                    } label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundColor(.foreground)
                    }
                }
            } else {
                TextField(placeholder, text: $text)
            }
            
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color(.systemGray3))
                
            
        }
    }
}

#Preview {
    InputField(text: .constant(""), title: "Input Field", placeholder: "Input text here")
}
