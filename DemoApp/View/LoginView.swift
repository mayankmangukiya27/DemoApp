//
//  LoginView.swift
//  DemoApp
//
//  Created by Mayank on 15/03/24.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn

struct LoginView: View {
    
    @State var email: String = ""
    @State var showAlert = false
    @EnvironmentObject var auth: UserAuthModel
    
    
    var body: some View {
        ZStack{
            
            VStack{
                Spacer()
                    .frame(height: 90)
                
                Text(welcomeDemoApp)
                    .font(.system(size: 50))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Spacer()
                    .frame(height: 60)
                
                TextField(emailPlaceholder, text: $email)
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                    )
                
                Spacer()
                    .frame(height: 30)
                
                Button(action: {
                    if isValidEmail(email) {
                        
                    } else {
                        showAlert = true
                    }
                }, label: {
                    Text(continuePlaceholder)
                        .fontWeight(.medium)
                        .foregroundColor(isValidEmail(email) ? .white : .gray)
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .background(isValidEmail(email) ? Color.blue : Color.gray.opacity(0.2))
                        .cornerRadius(12)
                })
                
                Spacer()
                    .frame(height: 40)
                
                ZStack{
                    Divider()
                    
                    Text(orContinueWith)
                        .padding(.horizontal)
                        .font(.system(size: 18))
                        .background(Color.white)
                }
                
                Spacer()
                    .frame(height: 40)
                
                Button(action: {
                    auth.signIn()
                }) {
                    HStack(spacing: 12) {
                        Image(googleImage)
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text(continueWithGoogle)
                            .fontWeight(.medium)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .foregroundColor(.black)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(invalidEmail), message: Text(enterValidEmail), dismissButton: .default(Text(ok)))
        }
    }
    
    //MARK: - Functions
    // email validation
    private func isValidEmail(_ email: String) -> Bool {
        // Regular expression for email validation
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
