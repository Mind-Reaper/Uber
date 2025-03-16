//
//  LoginView.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/4/25.
//

import SwiftUI

struct LoginView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    
    
    var body: some View {
      
          
                
                VStack {
                    
                    // logo
                    
                    Spacer()
                    
                    Image("uber-logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                    
                    Spacer()
                    
                    
                    // input fields
                    
                    VStack (spacing: 32) {
                        
                        InputField(text: $email, title: "Email Address", placeholder: "name@exmaple.com")
                        
                        InputField(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                        
                        Button {
                            
                        } label: {
                            Text("Forgot Password?")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.buttonBackground)
                                .padding(.top)
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        
                    }.padding(.horizontal)
                    
                    
                    
                    // social sign in view
                    
                    VStack {
                        HStack (spacing: 0) {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray)
                            
                            Text("Sign in with social")
                                .lineLimit(1)
                                .fontWeight(.semibold)
                                .padding(.horizontal)
                                .layoutPriority(1)
                            
                            
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray)
                            
                            
                        }
                        
                        HStack (spacing: 24) {
                            Button {
                                
                            } label: {
                                Image("facebook-sign-in-icon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 44, height: 44)
                            }
                            
                            Button {
                                
                            } label: {
                                Image("google-sign-in-icon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 44, height: 44)
                            }
                        }
                        
                        
                    }.padding()
                        .padding(.vertical)
                    
                    Spacer()
                    
                    // sign in button
                    
                  
                        CustomButton(title: "SIGN IN", systemIcon: "arrow.right") {
                            viewModel.signIn(usingEmail: email, password: password)
                        }
                        .padding(.horizontal)
                    
                    
                    Spacer()
                    
                    // sign up button
                    
                    Button {
                        Router.shared.path.append(AuthViewType.signup)
                    }
                    label: {
                        
                        HStack {
                            Text("Don't have an accont?")
                                .font(.system(size: 14))
                            Text("Sign Up")
                                .font(.system(size: 14, weight: .bold))
                            
                        }
                       
                    }
                    
            }
                .applyCustomBackground()

    }
}

#Preview {
    LoginView()
}
