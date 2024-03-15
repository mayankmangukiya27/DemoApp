//
//  UserAuthModel.swift
//  DemoApp
//
//  Created by Mayank on 15/03/24.
//

import Foundation
import SwiftUI
import FirebaseAuth
import GoogleSignIn

class UserAuthModel: ObservableObject {
    
    @Published var givenName: String = ""
    @Published var profilePicUrl: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String = ""
    
    var onSuccess: ((Bool) -> Void)?

    init(){
        check()
    }
    
    func checkStatus(){
        if(GIDSignIn.sharedInstance.currentUser != nil){
            let user = GIDSignIn.sharedInstance.currentUser
            guard let user = user else { return }
            let givenName = user.profile?.givenName
            let profilePicUrl = user.profile!.imageURL(withDimension: 100)!.absoluteString
            self.givenName = givenName ?? ""
            self.profilePicUrl = profilePicUrl
            self.isLoggedIn = true
            let credential = GoogleAuthProvider.credential(withIDToken: user.idToken?.tokenString ?? "", accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { [weak self] (_, error) in
                guard let self = self else { return }
                if let error = error {
                    print(error.localizedDescription)
                    self.onSuccess?(false)
                } else {
                    debugPrint("Success")
                    self.onSuccess?(true)
                }
            }
        }else{
            self.isLoggedIn = false
            self.givenName = "Not Logged In"
            self.profilePicUrl =  ""
        }
    }
    
    func check(){
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let error = error {
                self.errorMessage = "error: \(error.localizedDescription)"
            }
            self.checkStatus()
        }
    }
    
    func signIn(){
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
        
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController)  { user, error in
            if let error = error {
                self.errorMessage = "Error: \(error.localizedDescription)"
            }
            debugPrint("sign in done by : \(user)")
            self.checkStatus()
         }
    }
    
    func signOut(){
        GIDSignIn.sharedInstance.signOut()
        self.checkStatus()
    }
}
