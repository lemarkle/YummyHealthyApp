//
//  LoginView.swift
//  YummyHealthy
//
//  Created by Mark Le on 1/1/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var vm: DataController
    @State private var username = ""
    @State private var password = ""
    @Binding var isLoggedIn: Bool
    
    
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .padding()
            
            SecureField("Password", text: $password)
                .padding()
            
            Button("Login") {
                Task {
                    await vm.login(username: username, password: password)
                }
            }
            .padding()
        }
        .onAppear(perform: vm.checkToken)
    }
    

}

#Preview {
    LoginView(isLoggedIn: .constant(false))
        .environmentObject(DataController.preview)
}
