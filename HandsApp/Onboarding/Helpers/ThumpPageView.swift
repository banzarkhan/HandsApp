//
//  ThumpPageView.swift
//  HandsApp
//
//  Created by Ariuna Banzarkhanova on 02/03/23.
//

import SwiftUI

struct ThumpPage: View {
    
//    var navigationVM: NavigationViewModel
    @AppStorage("NeedsOnboarding") var needsOnboarding = true
    @AppStorage("NeedsTutorial") var needsTutorial = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack{
            VStack{
            Image("ThumpPose")
                .resizable()
                .frame(width: 305.81, height: 190.34)
                .padding(60)
                endButton
            }
        }
    }
    
    var endButton: some View {
        VStack {
            Button(action: {
                print("messaggio  ontrollo")
                needsOnboarding = false
                needsTutorial = true
                dismiss()
//                navigationVM.needOnboarding = true
                //ThumpPage.userOnboarded = true
               // print(UserDefaults.standard.bool(forKey:"userOnboarded"))
                
            }, label: {
                Text ("TRY now!")
                
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(10)
                    .padding(.horizontal, 40.0)
                    .background(Color.white)
                    .cornerRadius(10)
            })
            
        }
    }
}

struct ThumpPage_Previews: PreviewProvider {
    static var previews: some View {
        ThumpPage()
    }
}
