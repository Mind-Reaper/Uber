//
//  SignupView.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/4/25.
//

import SwiftUI

struct SignupView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var firstname: String = ""
    @State private var lastname: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
       
            VStack(alignment: .leading) {
                Button {
                    dismiss()
                    
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title)
                        .fontWeight(.semibold)
                        .imageScale(.large)
                        .foregroundColor(.foreground)
                        .padding()
                }
                
                Text("Create new\naccount")
                    .font(.system(size: 40))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                    .frame(width: 250)
                
                
                VStack (spacing: 56) {
                    HStack (spacing: 20) {
                        InputField(text: $firstname, title: "First Name", placeholder: "Enter your first name")
                        InputField(text: $lastname, title: "Last Name", placeholder: "Enter your last name")
                    }
                    InputField(text: $email, title: "Email Address", placeholder: "name@example.com")
                    
                    InputField(text: $password, title: "Create Password", placeholder: "Enter your password", isSecureField: true)
                }
                .padding()
                
                Spacer()
                
                CustomButton(title: "Sign Up") {
                    viewModel.signUp(usingEmail: email, password: password, firstname: firstname, lastname: lastname)
                }
                .padding(.horizontal)
                
                Spacer()
                
        
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    SignupView()
}
